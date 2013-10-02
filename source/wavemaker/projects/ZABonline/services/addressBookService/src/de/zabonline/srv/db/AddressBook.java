package de.zabonline.srv.db;

import java.util.Date;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import com.zabonlinedb.ZABonlineDB;

import de.zabonline.srv.db.ZABonlineDBService;
import de.zabonline.srv.Results;
import de.zabonline.srv.SessionManager;
import de.zabonline.srv.ZABonlineConstants;
import de.zabonline.srv.FileResourceManager;
import de.zabonline.srv.AccessMode;
import de.zabonline.srv.RelationIdents;
import de.zabonline.srv.JSONDataManager;
import de.zabonline.srv.ResourcePurpose;

public class AddressBook extends
		com.wavemaker.runtime.javaservice.JavaServiceSuperClass {

	private Session session;

	public AddressBook() {
		super(INFO);
	}

	@SuppressWarnings("unchecked")
	public List<Results.ProcResults> testProc(Integer aTenantId,
			Integer aInteger, Integer aSmallInt, String aVarchar254,
			String aVarchar2000, Date aDate) {

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
								"select * from SP_TESTPROC(:SESSIONID, :USERNAME, :IP, :TENANTID, :INTEGERPARAM, :SMALLINTPARAM, :VARCHAR254PARAM, :VARSCHAR2000PARAM, :DATEPARAM)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("TENANTID", aTenantId)
						.setParameter("INTEGERPARAM", aInteger)
						.setParameter("SMALLINTPARAM", aSmallInt)
						.setParameter("VARCHAR254PARAM", aVarchar254)
						.setParameter("VARSCHAR2000PARAM", aVarchar2000)
						.setParameter("DATEPARAM", aDate)
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
			// Alt: WM 6.4.x
			// throw ex;
		}
	}

	@SuppressWarnings("unchecked")
	private List<Results.ProcResults> getUniqueNameByDb(Integer aTenantId,
			String aExt) {

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
								"select * from SP_GET_UNIQUENAME_BY_SRV(:SESSIONID, "
										+ ":USERNAME, " + ":IP, "
										+ ":TENANTID, " + ":PHOTO_EXT)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("TENANTID", aTenantId)
						.setParameter("PHOTO_EXT", aExt)
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
			// Alt: WM 6.4.x
			// throw ex;
		}
	}

	protected String getUniqueName(Integer aTenantId, String aExt) {
		String result = "";
		String errorMsg = "";

		List<Results.ProcResults> uniqRes = getUniqueNameByDb(aTenantId, aExt);
		if (uniqRes.size() > 0) {
			if (uniqRes.get(0).getSuccess() == 1) {
				try {
					result = JSONDataManager.getInstance().getStringByIdent(uniqRes.get(0), "uniquename");
				} catch (RuntimeException ex) {
					if (ex.getCause().equals(null)) {
						errorMsg = ex.getMessage();
					} else {
						errorMsg = ex.getCause().getMessage();
					}

					if (errorMsg.trim().isEmpty()) {
						errorMsg = ZABonlineConstants.UNKNOWN_ERROR_BY_DBSERVICE;
					}

					throw new RuntimeException(errorMsg);
				}
			}
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<Results.ProcResults> addAddressBookItem(Integer aTenantId,
			Integer aSalutationId, String aAltsalutation, Integer aTitelId,
			String aFirstName, String aName, String aName2, Date aDayOfBirth,
			Boolean aIsPrivatePerson, Boolean aIsMarried, Integer aMarriedToId,
			Date aMarriedSince, String aMarriagePartnerFirstName,
			String aMarriagePartnerName1, Boolean aAddressDataPresent,
			Integer aAddressTypeId, String aDistrict, String aZipcode,
			String aCity, String aPostOfficeBox, String aStreet,
			String aStreetAddressFrom, String aStreetAddressTo,
			Boolean aIsPostAddress, Boolean aIsPrivateAddress,
			Boolean aContactDataPresent, Integer aContactTypeId,
			String aAreaCode, String aPhoneFmt, String aFaxFmt, String aWWW,
			String aEmail, String aSkype, String aMessangerName,
			Boolean aBankDataPresent, String aDepositor, String aBlzFmt,
			String aKtoFmt, String aIBAN, String aBIC,
			Boolean aInfoDataPresent, String aInfo, Boolean aPhotoPresent,
			String aPhotoUniqueName, String aPhotoRealName) {

		List<Results.ProcResults> result = null;
		
        String errorMsg = "";
        String uniqueName = "";
		String fileExt = "";
		
		Short aIsPrivatePerson_smallint = (short) ((aIsPrivatePerson) ? 1 : 0);
		Short aIsMarried_smallint = (short) ((aIsMarried) ? 1 : 0);
		Short aAddressDataPresent_smallint = (short) ((aAddressDataPresent) ? 1	: 0);
		Short aIsPostAddress_smallint = (short) ((aAddressDataPresent) ? 1 : 0);
		Short aIsPrivateAddress_smallint = (short) ((aIsPrivateAddress) ? 1 : 0);
		Short aInfoDataPresent_smallint = (short) ((aInfoDataPresent) ? 1 : 0);
		Short aContactDataPresent_smallint = (short) ((aContactDataPresent) ? 1	: 0);
		Short aBankDataPresent_smallint = (short) ((aBankDataPresent) ? 1 : 0);
		Short aPhotoPresent_smallint = (short) ((aPhotoPresent) ? 1 : 0);

		if (aPhotoPresent_smallint == 1) {
			if (aPhotoRealName != null) {
				if (!aPhotoRealName.trim().isEmpty()) {
					boolean hasExtension = aPhotoRealName.indexOf(".") != -1;
					fileExt = (hasExtension) ? aPhotoRealName.substring(aPhotoRealName.lastIndexOf(".")) : "";
				}
			}
		}
		
		Boolean isAuthentic = SessionManager.isAthenticated();
		String sessionId = SessionManager.getSessionId();
		String userName = SessionManager.getUserName();
		String ipByRequest = SessionManager.getRemoteAddress();		
		
		ZABonlineDB dbService = ZABonlineDBService.getZABonlineDBService();
		dbService.getDataServiceManager().begin();
		session = dbService.getDataServiceManager().getSession();
		FileResourceManager fileResourceMgr = new FileResourceManager(RelationIdents.BY_PERSON, session);
		
		try {
			if (isAuthentic) {
				result = session
						.createSQLQuery(
								"select * from SP_ADD_ADDRESSBOOKITEM_BY_SRV(:SESSIONID, "
										+ ":USERNAME, " + ":IP, "
										+ ":TENANTID, " + ":SALUTATION_ID, "
										+ ":ALTSALUTATION, " + ":TITEL_ID, "
										+ ":FIRSTNAME, " + ":NAME, "
										+ ":NAME2, " + ":DAY_OF_BIRTH, "
										+ ":ISPRIVATE_PERSON, "
										+ ":ISMARRIED, " + ":MARRIED_TO_ID, "
										+ ":MARRIED_SINCE, "
										+ ":MARRIAGE_PARTNER_FIRSTNAME, "
										+ ":MARRIAGE_PARTNER_NAME1, "
										+ ":ADDRESSDATAPRESENT, "
										+ ":ADDRESS_TYPE_ID, " + ":DISTRICT, "
										+ ":ZIPCODE, " + ":CITY, "
										+ ":POST_OFFICE_BOX, " + ":STREET, "
										+ ":STREET_ADDRESS_FROM, "
										+ ":STREET_ADDRESS_TO, "
										+ ":ISPOSTADDRESS, "
										+ ":ISPRIVATE_ADDRESS, "
										+ ":CONTACTDATAPRESENT, "
										+ ":CONTACT_TYPE_ID, " + ":AREA_CODE, "
										+ ":PHONE_FMT, " + ":FAX_FMT, "
										+ ":WWW, " + ":EMAIL, " + ":SKYPE, "
										+ ":MESSANGERNAME, "
										+ ":BANKDATAPRESENT, " + ":DEPOSITOR, "
										+ ":BLZ_FMT, " + ":KTO_FMT, "
										+ ":IBAN, " + ":BIC, "
										+ ":INFODATAPRESENT, " + ":INFO, "
										+ ":PHOTOPRESENT, "
										+ ":PHOTO_UNIQUE_NAME, "
										+ ":PHOTO_REAL_NAME, " + ":PHOTO_EXT)")
						.addScalar("success", Hibernate.INTEGER)
						.addScalar("code", Hibernate.INTEGER)
						.addScalar("info", Hibernate.STRING)
						.setParameter("SESSIONID", sessionId)
						.setParameter("USERNAME", userName)
						.setParameter("IP", ipByRequest)
						.setParameter("TENANTID", aTenantId)
						.setParameter("SALUTATION_ID", aSalutationId)
						.setParameter("ALTSALUTATION", aAltsalutation)
						.setParameter("TITEL_ID", aTitelId)
						.setParameter("FIRSTNAME", aFirstName)
						.setParameter("NAME", aName)
						.setParameter("NAME2", aName2)
						.setParameter("DAY_OF_BIRTH", aDayOfBirth)
						.setParameter("ISPRIVATE_PERSON", aIsPrivatePerson_smallint)
						.setParameter("ISMARRIED", aIsMarried_smallint)
						.setParameter("MARRIED_TO_ID", aMarriedToId)
						.setParameter("MARRIED_SINCE", aMarriedSince)
						.setParameter("MARRIAGE_PARTNER_FIRSTNAME", aMarriagePartnerFirstName)
						.setParameter("MARRIAGE_PARTNER_NAME1",	aMarriagePartnerName1)
						.setParameter("ADDRESSDATAPRESENT",	aAddressDataPresent_smallint)
						.setParameter("ADDRESS_TYPE_ID", aAddressTypeId)
						.setParameter("DISTRICT", aDistrict)
						.setParameter("ZIPCODE", aZipcode)
						.setParameter("CITY", aCity)
						.setParameter("POST_OFFICE_BOX", aPostOfficeBox)
						.setParameter("STREET", aStreet)
						.setParameter("STREET_ADDRESS_FROM", aStreetAddressFrom)
						.setParameter("STREET_ADDRESS_TO", aStreetAddressTo)
						.setParameter("ISPOSTADDRESS", aIsPostAddress_smallint)
						.setParameter("ISPRIVATE_ADDRESS", aIsPrivateAddress_smallint)
						.setParameter("CONTACTDATAPRESENT",	aContactDataPresent_smallint)
						.setParameter("CONTACT_TYPE_ID", aContactTypeId)
						.setParameter("AREA_CODE", aAreaCode)
						.setParameter("PHONE_FMT", aPhoneFmt)
						.setParameter("FAX_FMT", aFaxFmt)
						.setParameter("WWW", aWWW)
						.setParameter("EMAIL", aEmail)
						.setParameter("SKYPE", aSkype)
						.setParameter("MESSANGERNAME", aMessangerName)
						.setParameter("BANKDATAPRESENT", aBankDataPresent_smallint)
						.setParameter("DEPOSITOR", aDepositor)
						.setParameter("BLZ_FMT", aBlzFmt)
						.setParameter("KTO_FMT", aKtoFmt)
						.setParameter("IBAN", aIBAN)
						.setParameter("BIC", aBIC)
						.setParameter("INFODATAPRESENT", aInfoDataPresent_smallint)
						.setParameter("INFO", aInfo)
						.setParameter("PHOTOPRESENT", aPhotoPresent_smallint)
						.setParameter("PHOTO_UNIQUE_NAME", aPhotoUniqueName)
						.setParameter("PHOTO_REAL_NAME", aPhotoRealName)
						.setParameter("PHOTO_EXT", fileExt)
						.setResultTransformer(
								Transformers
										.aliasToBean(Results.ProcResults.class))
						.list();

				if (result.size() > 0) {
					if (result.get(0).getSuccess() == 1) {
						if (aPhotoPresent_smallint == 1) {
							uniqueName = JSONDataManager.getInstance().getStringByIdent(result.get(0), "uniquename");
							if (!uniqueName.trim().isEmpty()) {
								if (!fileResourceMgr.deployFileResource(sessionId,
												                        userName,
												                        ipByRequest,
												                        aTenantId,
												                        aPhotoRealName,
												                        uniqueName,
												                        ZABonlineConstants.REL_RESOURCE_TEMP_DIR,
												                        AccessMode.UPDATE,
												                        ResourcePurpose.MEMBERPHOTO)) {
									throw new RuntimeException(ZABonlineConstants.NO_VALID_PROCESSING_BY_FILERESOURCE);
								}
							} else {
								throw new RuntimeException(ZABonlineConstants.NO_VALID_UNIQUENAME);
							}
						}
					}
				}

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
			// Alt: WM 6.4.x
			// throw ex;
		}
	}
}