package de.zabonline.srv.db;

import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import com.zabonlinedb.ZABonlineDB;

import de.zabonline.srv.Results;
import de.zabonline.srv.SessionManager;
import de.zabonline.srv.ZABonlineConstants;

public class RegistryAccess extends
		com.wavemaker.runtime.javaservice.JavaServiceSuperClass {

	private Session session;

	public RegistryAccess() {
		super(INFO);
	}

	@SuppressWarnings("unchecked")
	public List<Results.ProcResults> readInteger(String aKey, String aSection,
			String aIdent, Integer aDefault) {

		List<Results.ProcResults> result = null;
		
		String errorMsg;

		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_READINTEGER_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY, :SECTION, :IDENT, :DEFAULT)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setParameter("SECTION", aSection)
						.setParameter("IDENT", aIdent)
						.setParameter("DEFAULT", aDefault)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.ProcResults.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		} catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	public List<Results.ProcResults> readFloat(String aKey, String aSection,
			String aIdent, Float aDefault) {

		List<Results.ProcResults> result = null;

		String errorMsg;
		
		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_READFLOAT_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY, :SECTION, :IDENT, :DEFAULT)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setParameter("SECTION", aSection)
						.setParameter("IDENT", aIdent)
						.setParameter("DEFAULT", aDefault)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.ProcResults.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		} catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	public List<Results.ProcResults> readString(String aKey, String aSection,
			String aIdent, String aDefault) {

		List<Results.ProcResults> result = null;
		
		String errorMsg;

		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_READFLOAT_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY, :SECTION, :IDENT, :DEFAULT)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setParameter("SECTION", aSection)
						.setParameter("IDENT", aIdent)
						.setParameter("DEFAULT", aDefault)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.ProcResults.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		}

		catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	public List<Results.ProcResults> readSection(String aKey, String aSection) {

		List<Results.ProcResults> result = null;

		String errorMsg;
		
		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_READSECTION_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY, :SECTION)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setParameter("SECTION", aSection)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.ProcResults.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		}

		catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	public List<Results.ProcResults> readSections(String aKey) {

		List<Results.ProcResults> result = null;
		
	    String errorMsg; 

		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_READSECTIONS_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.ProcResults.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		}

		catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	public List<Results.SuccessInfo> writeString(String aKey, String aSection,
			String aIdent, String aValue) {

		List<Results.SuccessInfo> result = null;

		String errorMsg;
		
		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_WRITESTRING_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY, :SECTION, :IDENT, :VALUE)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setParameter("SECTION", aSection)
						.setParameter("IDENT", aIdent)
						.setParameter("VALUE", aValue)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.SuccessInfo.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		}

		catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	public List<Results.SuccessInfo> writeInteger(String aKey, String aSection,
			String aIdent, Integer aValue) {

		List<Results.SuccessInfo> result = null;

		String errorMsg;
		
		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_WRITEINTEGER_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY, :SECTION, :IDENT, :VALUE)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setParameter("SECTION", aSection)
						.setParameter("IDENT", aIdent)
						.setParameter("VALUE", aValue)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.SuccessInfo.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		}

		catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	public List<Results.SuccessInfo> writeFloat(String aKey, String aSection,
			String aIdent, Float aValue) {

		List<Results.SuccessInfo> result = null;
		
		String errorMsg;

		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();

		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();

		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_WRITEFLOAT_BY_SRV(:SESSIONID, :USERNAME, :IP, :KEY, :SECTION, :IDENT, :VALUE)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("KEY", aKey)
						.setParameter("SECTION", aSection)
						.setParameter("IDENT", aIdent)
						.setParameter("VALUE", aValue)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.SuccessInfo.class))
						.list();

				dbService.commit();
			} else {
				throw new RuntimeException(
						ZABonlineConstants.NO_VALID_AUTHENTIFICATION);
			}

			return result;
		}

		catch (RuntimeException ex) {
			dbService.rollback();

			if (ex.getCause() == null) {
				errorMsg = ex.getMessage();
			} else {
		     	errorMsg = ex.getCause().getMessage();	
			}
			
			if (errorMsg.trim().isEmpty()) {
				errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
			}
			
			throw new RuntimeException(errorMsg);			
			//Alt: WM 6.4.x 
			//throw ex;
		}
	}
}