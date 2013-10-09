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
}