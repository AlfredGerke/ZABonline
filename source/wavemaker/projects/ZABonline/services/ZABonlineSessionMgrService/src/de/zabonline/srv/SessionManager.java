package de.zabonline.srv;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import com.wavemaker.runtime.RuntimeAccess;
import com.zabonlinedb.ZABonlineDB;
import com.wavemaker.runtime.security.SecurityService;

import de.zabonline.srv.db.ZABonlineDBService;

public class SessionManager extends com.wavemaker.runtime.javaservice.JavaServiceSuperClass {

  private Session session;

  public SessionManager() {

    super(INFO);
  }

  private static HttpServletRequest getHttpServletRequest() {

    HttpServletRequest req = RuntimeAccess.getInstance()
        .getRequest();

    return req;
  }

  private static SecurityService getSecurityService() {

    SecurityService service = (SecurityService) RuntimeAccess.getInstance()
        .getServiceBean("securityService");

    return service;
  }

  public static String getRemoteAddress() {

    HttpServletRequest req = getHttpServletRequest();

    return req.getRemoteAddr();
  }

  public static Boolean isAthenticated() {

    SecurityService service = getSecurityService();
    Boolean isAuthentic = service.isAuthenticated();

    return isAuthentic;
  }

  public static Integer getTenantId() {

    Integer tenantId = RuntimeAccess.getInstance()
        .getTenantId();

    return tenantId;
  }

  public static String getUserName() {

    SecurityService service = getSecurityService();
    String userName = service.getUserName();

    return userName;
  }

  public static String getUserId() {

    SecurityService service = getSecurityService();
    String userId = service.getUserId();

    return userId;
  }

  public static String getSessionId() {

    HttpSession sess = RuntimeAccess.getInstance()
        .getSession();

    return sess.getId();
  }

  @SuppressWarnings("unchecked")
  public List<Results.SuccessInfo> registerSession() {

    List<Results.SuccessInfo> result = null;

    String errorMsg;

    String userName = getUserName();
    String sessionId = getSessionId();
    Boolean isAuthentic = isAthenticated();
    String ipByRequest = getRemoteAddress();

    ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();

    dbService.getDataServiceManager()
        .begin();

    session = dbService.getDataServiceManager()
        .getSession();
    try {
      if (isAuthentic) {
        result = session.createSQLQuery("select * from SP_REGISTERSESSION(:SESSIONID, :USERNAME, :IP)")
            .addScalar("success",
              Hibernate.INTEGER)
            .setParameter("SESSIONID",
              sessionId)
            .setParameter("USERNAME",
              userName)
            .setParameter("IP",
              ipByRequest)
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

  @SuppressWarnings("unchecked")
  public List<Results.SuccessInfo> touchSession() {

    List<Results.SuccessInfo> result = null;

    String errorMsg;

    String userName = getUserName();
    String sessionId = getSessionId();
    Boolean isAuthentic = isAthenticated();
    String ipByRequest = getRemoteAddress();

    ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();

    dbService.getDataServiceManager()
        .begin();

    session = dbService.getDataServiceManager()
        .getSession();
    try {
      if (isAuthentic) {
        result = session.createSQLQuery("select * from SP_TOUCHSESSION(:SESSIONID, :USERNAME, :IP)")
            .addScalar("success",
              Hibernate.INTEGER)
            .setParameter("SESSIONID",
              sessionId)
            .setParameter("USERNAME",
              userName)
            .setParameter("IP",
              ipByRequest)
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

  @SuppressWarnings("unchecked")
  public List<Results.SuccessInfo> closeSession() {

    List<Results.SuccessInfo> result = null;

    String errorMsg;

    String userName = getUserName();
    String sessionId = getSessionId();
    Boolean isAuthentic = isAthenticated();
    String ipByRequest = getRemoteAddress();

    ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();

    dbService.getDataServiceManager()
        .begin();

    session = dbService.getDataServiceManager()
        .getSession();
    try {
      if (isAuthentic) {
        result = session.createSQLQuery("select * from SP_CLOSESESSION(:SESSIONID, :USERNAME, :IP)")
            .addScalar("success",
              Hibernate.INTEGER)
            .setParameter("SESSIONID",
              sessionId)
            .setParameter("USERNAME",
              userName)
            .setParameter("IP",
              ipByRequest)
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
}