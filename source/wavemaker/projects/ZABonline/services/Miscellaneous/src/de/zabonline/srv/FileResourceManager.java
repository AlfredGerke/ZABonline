/**
 *  Erweiterung der von Wavemaker erstellten Javasourcen
 * 
 *  1.0.0 Build 1
 *  
 *  2013-03-26
 *  
 *  Copyright by Alfred Gerke
 */
package de.zabonline.srv;

import com.wavemaker.runtime.RuntimeAccess;

import javax.activation.MimetypesFileTypeMap;
import java.io.File;
import java.io.FileInputStream;
//import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import de.zabonline.srv.Results;
import de.zabonline.srv.ZABonlineTypes.MimeTypeIdentInfo;
import de.zabonline.srv.ZABonlineConstants;
import de.zabonline.srv.RelationIdents;
import de.zabonline.srv.ResourcePurpose;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;


/**
 * Dateihändling der ZABonline
 * 
 * @author Alfred
 * 
 * @version 1.0.0 Build 1
 * 
 */
public class FileResourceManager {

  private static Logger logger = LogManager.getLogger("FileResourceManager");	
  private Session session = null;
  private RelationIdents relationIdent = RelationIdents.UNKNOWN;

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aSession
   */
  public FileResourceManager(RelationIdents aRelation,
    Session aSession) {

    super();

    relationIdent = aRelation;

    if (aSession != null)
      session = aSession;
  }

  /**
   * Mimetype Informationen
   * 
   * @author Alfred
   * 
   * @version 1.0.0 Build 1
   * 
   */
  public class MimeTypeInfo {

    String mimeType;
    String subType;

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @param aMimeTypeInfo
     */
    public MimeTypeInfo(String aMimeTypeInfo) {

      //
      setMimetype(aMimeTypeInfo);
      setSubtype(aMimeTypeInfo);
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @param aMimetype
     * @param aIdent
     * @return
     */
    private MimeTypeIdentInfo getMimeTypeInfoByIdent(String aMimetype,
        MimeTypeIdents aIdent) {

      MimeTypeIdentInfo result = new MimeTypeIdentInfo();
      int idx = aMimetype.lastIndexOf("/");
      String subStr = "";

      switch (aIdent) {
        case UNKNOWN:
          result.setIdent("");

          break;
        case MIMETYPE:
          subStr = aMimetype.trim()
              .substring(0,
                  idx);
          result.setIdent(subStr);

          break;
        case SUBTYPE:
          idx++;
          subStr = aMimetype.trim()
              .substring(idx);
          result.setIdent(subStr);

          break;
        default:
          result.setIdent("");
          break;
      }
      return result;
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @param aMimetype
     */
    private void setMimetype(String aMimetype) {

      this.mimeType = getMimeTypeInfoByIdent(aMimetype,
          MimeTypeIdents.MIMETYPE).getIdent();
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @return
     */
    public String getMimetype() {

      return this.mimeType;
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @param aMimetype
     */
    private void setSubtype(String aMimetype) {

      this.subType = getMimeTypeInfoByIdent(aMimetype,
          MimeTypeIdents.SUBTYPE).getIdent();
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @return
     */
    public String getSubtype() {

      return this.subType;
    }
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aUploadFile
   * @return
   */
  private String getMimeTypeByFilename(File aUploadFile) {

    String result = "";

    result = new MimetypesFileTypeMap().getContentType(aUploadFile.getName());

    return result;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aUploadFile
   * @param aShortFilename
   * @param aMimetype
   * @param aSuptype
   * @param aAccessMode
   * @return
   */
  @SuppressWarnings("unchecked")
  private List<Results.ProcResults> insertIntoDb(String aSessionId,
      String aUsername,
      String aIpByRequest,
      Integer aTenantId,
      File aUploadFile,
      String aShortFilename,
      String aUniquename,
      String aMimetype,
      String aSuptype,
      AccessMode aAccessMode) {

    List<Results.ProcResults> result = null;
    String errorMsg = "";     
    
    try {
      
      InputStream inStream = new FileInputStream(aUploadFile);   
      int expected = inStream.available();
      byte[] bytes = new byte[expected];
         
      int streamLength = inStream.read(bytes);
      
      if (expected != streamLength) {
        inStream.close();
        throw new RuntimeException(ZABonlineConstants.ERROR_SAVE_FILE_TO_DB);
      }
      
      result = session.createSQLQuery("select * from SP_UPDATE_DOC_BY_FILE_BY_SRV(:SESSIONID, " + ":USERNAME, "
          + ":IP, " + ":TENANTID, " + ":FILE_UNIQUE_NAME, " + ":FILE_REAL_NAME, " + ":MIMETYPE, " + ":SUBTYPE, "
          + ":RELATION_TYPE, " + ":ACCESS_MODE, " + ":DATA_OBJECT)")
          .addScalar("success",
              Hibernate.INTEGER)
          .addScalar("code",
              Hibernate.INTEGER)
          .addScalar("info",
              Hibernate.STRING)
          .setParameter("SESSIONID",
              aSessionId)
          .setParameter("USERNAME",
              aUsername)
          .setParameter("IP",
              aIpByRequest)
          .setParameter("TENANTID",
              aTenantId)
          .setParameter("FILE_UNIQUE_NAME",
              aUniquename)
          .setParameter("FILE_REAL_NAME",
              aShortFilename)
          .setParameter("MIMETYPE",
              aMimetype)
          .setParameter("SUBTYPE",
              aSuptype)
          .setParameter("RELATION_TYPE",
              relationIdent.toString())
          .setParameter("ACCESS_MODE",
              aAccessMode.toString())
          .setBinary("DATA_OBJECT", bytes)  
          .setResultTransformer(Transformers.aliasToBean(Results.ProcResults.class))
          .list();

      inStream.close();

    } catch (IOException ex) {
      if (ex.getCause() == null) {
        errorMsg = ex.getMessage();
      } else {
        errorMsg = ex.getCause()
            .getMessage();
      }

      if (errorMsg.trim()
          .isEmpty()) {
        errorMsg = ZABonlineConstants.ERROR_SAVE_FILE_TO_DB;
      }

      throw new RuntimeException(errorMsg);
    } catch (HibernateException ex) {
      if (ex.getCause() == null) {
        errorMsg = ex.getMessage();
      } else {
        errorMsg = ex.getCause()
            .getMessage();
      }

      if (errorMsg.trim()
          .isEmpty()) {
        errorMsg = ZABonlineConstants.ERROR_SAVE_FILE_TO_DB;
      }

      throw new RuntimeException(errorMsg);
    }
    
    return result;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aUploadFile
   * @param aUniqueFilename
   * @param aResourceDataDir
   * @return
   */
  private Boolean copyFileResouce(File aUploadFile,
      String aUniqueFilename,
      String aResourceDataDir) {

    Boolean result = false;
    String errorMsg = "";

    String moveDir = RuntimeAccess.getInstance()
        .getSession()
        .getServletContext()
        .getRealPath(aResourceDataDir);

    File dataDir = new File(moveDir);
    File movedFile = new File(dataDir, aUniqueFilename);

    InputStream inStream = null;
    OutputStream outStream = null;

    try {

      if (!dataDir.exists()) {
        dataDir.mkdir();
      }

      inStream = new FileInputStream(aUploadFile);
      outStream = new FileOutputStream(movedFile);

      byte[] buffer = new byte[1024];

      int length;

      while ((length = inStream.read(buffer)) > 0) {
        outStream.write(buffer,
            0,
            length);
      }

      inStream.close();
      outStream.close();

      result = true;

    } catch (IOException ex) {
      result = false;

      if (ex.getCause() == null) {
        errorMsg = ex.getMessage();
      } else {
        errorMsg = ex.getCause()
            .getMessage();
      }

      if (errorMsg.trim()
          .isEmpty()) {
        errorMsg = ZABonlineConstants.ERROR_COPY_FILERESOURCE;
      }

      throw new RuntimeException(errorMsg);
    }

    return result;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aUploadFile
   * @param aShortFilename
   * @param aMimetype
   * @param aSubtype
   * @param aAccessMode
   * @return
   */
  private Boolean deploy(String aSessionId,
      String aUsername,
      String aIpByRequest,
      Integer aTenantId,
      File aUploadFile,
      String aShortFilename,
      String aUniquename,
      String aMimetype,
      String aSubtype,
      AccessMode aAccessMode,
      ResourcePurpose aPurpose) {

    Boolean result = false;
    List<Results.ProcResults> resultByDb = insertIntoDb(aSessionId,
        aUsername,
        aIpByRequest,
        aTenantId,
        aUploadFile,
        aShortFilename,
        aUniquename,
        aMimetype,
        aSubtype,
        aAccessMode);

    if (resultByDb.size() > 0) {
      if (resultByDb.get(0)
          .getSuccess() == 1) {
        switch (relationIdent) {
          case BY_PERSON:
            if (aPurpose == ResourcePurpose.MEMBERPHOTO) {
            result = copyFileResouce(aUploadFile,
                aUniquename,
                ZABonlineConstants.RESOURCE_MEMBERDATA_DIR);
            } else {
              result = true;
            }

            break;
          default:
            /* zumindest die DB-Operation war erfolgreich */
            result = true;

            break;
        }
      }
    }

    return result;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aShortFilename
   * @param aRelSourceDir
   * @param aAccessMode
   * @return
   */
  public Boolean deployFileResource(String aSessionId,
      String aUsername,
      String aIpByRequest,
      Integer aTenantId,
      String aShortFilename,
      String aUniquename,
      String aRelSourceDir,
      AccessMode aAccessMode,
      ResourcePurpose aPurpose) {

	logger.info("before doInsert");
	
    Boolean result = false;
    String mimeTypeByFile = "";
    MimeTypeInfo typeInfo;
    String mimeType = "";
    String subType = "";
    Boolean doInsert = false;
    String uploadDir = RuntimeAccess.getInstance()
        .getSession()
        .getServletContext()
        .getRealPath(aRelSourceDir);
    File upload_file = new File(uploadDir, aShortFilename);

    mimeTypeByFile = getMimeTypeByFilename(upload_file);

    typeInfo = new MimeTypeInfo(mimeTypeByFile);
    mimeType = typeInfo.getMimetype();
    subType = typeInfo.getSubtype();

    doInsert = ((!mimeType.isEmpty()) && (!subType.isEmpty()));
    
    if (doInsert) {
      result = deploy(aSessionId,
          aUsername,
          aIpByRequest,
          aTenantId,
          upload_file,
          aShortFilename,
          aUniquename,
          mimeType,
          subType,
          aAccessMode,
          aPurpose);
    }

    return result;
  }
}