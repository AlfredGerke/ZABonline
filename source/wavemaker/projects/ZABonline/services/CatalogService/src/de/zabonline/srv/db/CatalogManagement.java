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

@ExposeToClient
public class CatalogManagement extends JavaServiceSuperClass {

  private Session session;

  public CatalogManagement() {

    super(INFO);
  }

  @SuppressWarnings("unchecked")
  public List<Results.ProcResults> addCatalogItem(String aCatalog,
    Integer aTenantId,
    Integer aCountryId,
    Boolean aDoNotDelete,
    String aCaption,
    String aDesc) {

    List<Results.ProcResults> result = null;

    String errorMsg;

    Boolean isAuthentic = SessionManager.isAthenticated();
    String sessionId = SessionManager.getSessionId();
    String userName = SessionManager.getUserName();
    String ipByRequest = SessionManager.getRemoteAddress();
    
    Short aDoNotDelete_smallint = (short) ((aDoNotDelete) ? 1 : 0);

    ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
    dbService.getDataServiceManager()
        .begin();
    session = dbService.getDataServiceManager()
        .getSession();

    try {
      if (isAuthentic) {
        result = session.createSQLQuery("select * from SP_ADDCATALOGITEM_BY_SRV(:SESSIONID, " 
                                        + ":USERNAME, "
                                        + ":IP, "
                                        + ":TENANTID, "
                                        + ":DONOTDELETE, "
                                        + ":CATALOG, "
                                        + ":COUNTRYID, "
                                        + ":CAPTION, "
                                        + ":DESC)")
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
            .setParameter("TENANTID",
              aTenantId)              
            .setParameter("DONOTDELETE",
              aDoNotDelete_smallint)
            .setParameter("CATALOG", 
              aCatalog)
            .setParameter("COUNTRYID",
              aCountryId)
            .setParameter("CAPTION",
              aCaption)
            .setParameter("DESC",
              aDesc)
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
    }
  }
}
