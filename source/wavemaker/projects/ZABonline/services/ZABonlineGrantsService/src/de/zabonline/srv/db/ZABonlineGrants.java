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
public class ZABonlineGrants extends JavaServiceSuperClass {

  private Session session;

  public ZABonlineGrants() {

    super(INFO);
  }

  @SuppressWarnings("unchecked")
  public List<Results.SuccessInfo> checkGrant(String aGrant) {

    List<Results.SuccessInfo> result = null;

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
        result = session.createSQLQuery("select * from SP_CHECKGRANT_BY_SVR(:SESSIONID, :USERNAME, :IP, :GRANT)")
            .addScalar("success",
              Hibernate.INTEGER)
            .setParameter("SESSIONID",
              sessionId)
            .setParameter("USERNAME",
              userName)
            .setParameter("IP",
              ipByRequest)
            .setParameter("GRANT",
              aGrant)
            .setResultTransformer(Transformers.aliasToBean(Results.SuccessInfo.class))
            .list();

        dbService.commit();
      } else {
        throw new RuntimeException(ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
      }

      return result;
    } catch (RuntimeException ex) {
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

  public List<Results.SuccessInfo> checkGrantAdmin() {

    return checkGrant("IS_ADMIN");
  }
  
  public List<Results.SuccessInfo> checkGrantReferenceData() {
    return checkGrant("REFERENCE_DATA");
  }  
}
