package de.zabonline.srv.db;

import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import com.wavemaker.runtime.javaservice.JavaServiceSuperClass;
import com.wavemaker.runtime.service.annotations.ExposeToClient;
import com.zabonlinedb.ZABonlineDB;

import de.zabonline.srv.Results;
import de.zabonline.srv.SessionManager;
import de.zabonline.srv.ZABonlineConstants;
import de.zabonline.srv.db.ZABonlineDBService;

@ExposeToClient
public class ZABonlineAdmin extends JavaServiceSuperClass {

  private Session session;

  public ZABonlineAdmin() {

    super(INFO);
  }

  @SuppressWarnings("unchecked")
  public List<Results.ProcResults> addUserData(Integer aRoleId,
    Integer aTenantId,
    Integer aPersonId,
    String aUsername,
    String aPassword,
    String aFirstname,
    String aName,
    String aEmail,
    Boolean aAllowLogin) {

    List<Results.ProcResults> result = null;

    String errorMsg = "";

    Short aAllowLogin_smallint = (short) ((aAllowLogin) ? 1 : 0);

    Boolean isAuthentic = SessionManager.isAthenticated();
    String sessionId = SessionManager.getSessionId();
    String userName = SessionManager.getUserName();
    String ipByRequest = SessionManager.getRemoteAddress();

    ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
    dbService.getDataServiceManager()
        .begin();
    session = dbService.getDataServiceManager()
        .getSession();

    try {
      if (isAuthentic) {
        result = session.createSQLQuery("select * from SP_ADD_USER_BY_SRV(:SESSIONID, " + ":USERNAME, "
                                        + ":IP, "
                                        + ":ROLE_ID, "
                                        + ":TENANT_ID, "
                                        + ":PERSON_ID, "
                                        + ":USER, "
                                        + ":PASS, "
                                        + ":FIRSTNAME, "
                                        + ":NAME, "
                                        + ":EMAIL, "
                                        + ":ALLOW_LOGIN)")
            .addScalar("success",
              Hibernate.INTEGER)
            .addScalar("code",
              Hibernate.INTEGER)
            .addScalar("info",
              Hibernate.STRING)
            .setParameter("SESSIONID",
              sessionId)
            .setParameter("USERNAME",
              userName)
            .setParameter("IP",
              ipByRequest)
            .setParameter("ROLE_ID",
              aRoleId)
            .setParameter("TENANT_ID",
              aTenantId)
            .setParameter("PERSON_ID",
              aPersonId)
            .setParameter("USER",
              aUsername)
            .setParameter("PASS",
              aPassword)
            .setParameter("FIRSTNAME",
              aFirstname)
            .setParameter("NAME",
              aName)
            .setParameter("EMAIL",
              aEmail)
            .setParameter("ALLOW_LOGIN",
              aAllowLogin_smallint)
            .setResultTransformer(Transformers.aliasToBean(Results.ProcResults.class))
            .list();

        dbService.commit();
      } else {
        throw new RuntimeException(ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
      }

      return result;
    }

    catch (RuntimeException ex) {
      dbService.rollback();

      if (ex.getCause() == null) {
        errorMsg = ex.getMessage();
      } else {
        errorMsg = ex.getCause()
            .getMessage();
      }

      if (errorMsg.trim()
          .isEmpty()) {
        errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
      }

      throw new RuntimeException(errorMsg);
      // Alt: WM 6.4.x
      // throw ex;
    }
  }
  
  @SuppressWarnings("unchecked")
  public List<Results.ProcResults> addRoleData(String aCaption,
    String aDescription,
    Boolean aIsAdmin,
    Boolean aSetup,
    Boolean aMembers,
    Boolean aActivityRecording,
    Boolean aSEPA,
    Boolean aBilling,
    Boolean aImport,
    Boolean aExport,
    Boolean aReferenceData,
    Boolean aReporting,
    Boolean aMisc,
    Boolean aFileresource) {

    List<Results.ProcResults> result = null;

    String errorMsg = "";

    Short aIsAdmin_smallint = (short) ((aIsAdmin) ? 1 : 0);
    Short aSetup_smallint = (short) ((aSetup) ? 1 : 0);
    Short aMembers_smallint = (short) ((aMembers) ? 1 : 0);
    Short aActivityRecording_smallint = (short) ((aActivityRecording) ? 1 : 0);
    Short aSEPA_smallint = (short) ((aSEPA) ? 1 : 0);
    Short aBilling_smallint = (short) ((aBilling) ? 1 : 0);
    Short aImport_smallint = (short) ((aImport) ? 1 : 0);
    Short aExport_smallint = (short) ((aExport) ? 1 : 0);
    Short aReferenceData_smallint = (short) ((aReferenceData) ? 1 : 0);
    Short aReporting_smallint = (short) ((aReporting) ? 1 : 0);
    Short aMisc_smallint = (short) ((aMisc) ? 1 : 0);
    Short aFileresource_smallint = (short) ((aFileresource) ? 1 : 0);

    Boolean isAuthentic = SessionManager.isAthenticated();
    String sessionId = SessionManager.getSessionId();
    String userName = SessionManager.getUserName();
    String ipByRequest = SessionManager.getRemoteAddress();

    ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
    dbService.getDataServiceManager()
        .begin();
    session = dbService.getDataServiceManager()
        .getSession();

    try {
      if (isAuthentic) {
        result = session.createSQLQuery("select * from SP_ADD_ROLE_BY_SRV(:SESSIONID, " + ":USERNAME, "
                                        + ":IP, "
                                        + ":ISADMIN, "
                                        + ":SETUP, "
                                        + ":MEMBERS, "
                                        + ":ACTIVITYRECORDING, "
                                        + ":SEPA, "
                                        + ":BILLING, "
                                        + ":IMPORT, "
                                        + ":EXPORT, "
                                        + ":REFERENCEDATA, "
                                        + ":REPORTING, "
                                        + ":MISC, "
                                        + ":FILERESOURCE)")
            .addScalar("success",
              Hibernate.INTEGER)
            .addScalar("code",
              Hibernate.INTEGER)
            .addScalar("info",
              Hibernate.STRING)
            .setParameter("SESSIONID",
              sessionId)
            .setParameter("USERNAME",
              userName)
            .setParameter("IP",
              ipByRequest)
            .setParameter("ISADMIN",
              aIsAdmin_smallint)
            .setParameter("SETUP",
              aSetup_smallint)
            .setParameter("MEMBERS",
              aMembers_smallint)
            .setParameter("ACTIVITYRECORDING",
              aActivityRecording_smallint)
            .setParameter("SEPA",
              aSEPA_smallint)
            .setParameter("BILLING",
              aBilling_smallint)
            .setParameter("IMPORT",
              aImport_smallint)
            .setParameter("EXPORT",
              aExport_smallint)
            .setParameter("REFERENCEDATA",
              aReferenceData_smallint)
            .setParameter("REPORTING",
              aReporting_smallint)
            .setParameter("MISC",
              aMisc_smallint)
            .setParameter("FILERESOURCE",
              aFileresource_smallint)              
            .setResultTransformer(Transformers.aliasToBean(Results.ProcResults.class))
            .list();

        dbService.commit();
      } else {
        throw new RuntimeException(ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
      }

      return result;
    }

    catch (RuntimeException ex) {
      dbService.rollback();

      if (ex.getCause() == null) {
        errorMsg = ex.getMessage();
      } else {
        errorMsg = ex.getCause()
            .getMessage();
      }

      if (errorMsg.trim()
          .isEmpty()) {
        errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
      }

      throw new RuntimeException(errorMsg);
      // Alt: WM 6.4.x
      // throw ex;
    }
  }  
}