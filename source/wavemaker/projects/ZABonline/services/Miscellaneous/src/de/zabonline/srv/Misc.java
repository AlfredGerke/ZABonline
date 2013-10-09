package de.zabonline.srv;

import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import com.wavemaker.runtime.javaservice.JavaServiceSuperClass;
import com.wavemaker.runtime.service.annotations.ExposeToClient;
import com.zabonlinedb.ZABonlineDB;

import de.zabonline.srv.db.ZABonlineDBService;

@ExposeToClient
public class Misc extends JavaServiceSuperClass {

  private Session session;

  public Misc() {

    super(INFO);
  }

  @SuppressWarnings("unchecked")
  public List<Results.ProcResults> getUniqueNameByDb(Integer aTenantId,
    String aExt) {

    List<Results.ProcResults> result = null;
    String errorMsg;

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

        result = session.createSQLQuery("select * from SP_GET_UNIQUENAME_BY_SRV(:SESSIONID, " + ":USERNAME, "
                                        + ":IP, "
                                        + ":TENANTID, "
                                        + ":PHOTO_EXT)")
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
            .setParameter("PHOTO_EXT",
              aExt)
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
  public List<Results.ProcResults> startSearchByDb(Integer aTenantId,
    String aParameterByJSON) {

    List<Results.ProcResults> result = null;
    String errorMsg;

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

        result = session.createSQLQuery("select * from SP_START_SEARCH_BY_SRV(:SESSIONID, " + ":USERNAME, "
                                        + ":IP, "
                                        + ":TENANTID, "
                                        + ":PHOTO_EXT)")
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
            // hier kommen die Parameter resultierend aus dem JSON-String
            // aParameterByJSON
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