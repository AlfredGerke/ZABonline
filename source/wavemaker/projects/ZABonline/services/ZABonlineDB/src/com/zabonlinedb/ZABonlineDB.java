
package com.zabonlinedb;

import java.util.List;
import com.wavemaker.json.type.TypeDefinition;
import com.wavemaker.runtime.data.DataServiceManager;
import com.wavemaker.runtime.data.DataServiceManagerAccess;
import com.wavemaker.runtime.data.TaskManager;
import com.wavemaker.runtime.service.LiveDataService;
import com.wavemaker.runtime.service.PagingOptions;
import com.wavemaker.runtime.service.PropertyOptions;
import com.wavemaker.runtime.service.TypedServiceReturn;
import com.zabonlinedb.data.Country;
import com.zabonlinedb.data.Users;
import com.zabonlinedb.data.output.GetLookupAddressTypeByCountryRtnType;
import com.zabonlinedb.data.output.GetLookupAreaCodeRtnType;
import com.zabonlinedb.data.output.GetLookupContactPartnerByTenantRtnType;
import com.zabonlinedb.data.output.GetLookupContactTypeByCountryRtnType;
import com.zabonlinedb.data.output.GetLookupCountryRtnType;
import com.zabonlinedb.data.output.GetLookupPersonByMarriageRtnType;
import com.zabonlinedb.data.output.GetLookupPersonByTenantRtnType;
import com.zabonlinedb.data.output.GetLookupRoleRtnType;
import com.zabonlinedb.data.output.GetLookupSalutationByCountryRtnType;
import com.zabonlinedb.data.output.GetLookupTenantRtnType;
import com.zabonlinedb.data.output.GetLookupTitelByCountryRtnType;


/**
 *  Operations for service "ZABonlineDB"
 *  10/28/2013 22:24:35
 * 
 */
@SuppressWarnings("unchecked")
public class ZABonlineDB
    implements DataServiceManagerAccess, LiveDataService
{

    private DataServiceManager dsMgr;
    private TaskManager taskMgr;

    public List<GetLookupAreaCodeRtnType> getLookupAreaCode(PagingOptions pagingOptions) {
        return ((List<GetLookupAreaCodeRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupAreaCodeQueryName), pagingOptions));
    }

    public List<GetLookupContactPartnerByTenantRtnType> getLookupContactPartnerByTenant(Integer TenantId, PagingOptions pagingOptions) {
        return ((List<GetLookupContactPartnerByTenantRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupContactPartnerByTenantQueryName), TenantId, pagingOptions));
    }

    public List<Country> getCountryByCode(String Code, PagingOptions pagingOptions) {
        return ((List<Country> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getCountryByCodeQueryName), Code, pagingOptions));
    }

    public List<GetLookupAddressTypeByCountryRtnType> getLookupAddressTypeByCountry(Integer CountryId, PagingOptions pagingOptions) {
        return ((List<GetLookupAddressTypeByCountryRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupAddressTypeByCountryQueryName), CountryId, pagingOptions));
    }

    public List<GetLookupContactTypeByCountryRtnType> getLookupContactTypeByCountry(Integer CountryId, PagingOptions pagingOptions) {
        return ((List<GetLookupContactTypeByCountryRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupContactTypeByCountryQueryName), CountryId, pagingOptions));
    }

    public List<GetLookupTitelByCountryRtnType> getLookupTitelByCountry(Integer CountryId, PagingOptions pagingOptions) {
        return ((List<GetLookupTitelByCountryRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupTitelByCountryQueryName), CountryId, pagingOptions));
    }

    public List<GetLookupRoleRtnType> getLookupRole(PagingOptions pagingOptions) {
        return ((List<GetLookupRoleRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupRoleQueryName), pagingOptions));
    }

    public List<Users> getInfoByUserName(String Username, PagingOptions pagingOptions) {
        return ((List<Users> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getInfoByUserNameQueryName), Username, pagingOptions));
    }

    public List<GetLookupPersonByTenantRtnType> getLookupPersonByTenant(Integer TenantId, PagingOptions pagingOptions) {
        return ((List<GetLookupPersonByTenantRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupPersonByTenantQueryName), TenantId, pagingOptions));
    }

    public List<GetLookupPersonByMarriageRtnType> getLookupPersonByMarriage(Integer TenantId, PagingOptions pagingOptions) {
        return ((List<GetLookupPersonByMarriageRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupPersonByMarriageQueryName), TenantId, pagingOptions));
    }

    public List<GetLookupSalutationByCountryRtnType> getLookupSalutationByCountry(Integer CountryId, PagingOptions pagingOptions) {
        return ((List<GetLookupSalutationByCountryRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupSalutationByCountryQueryName), CountryId, pagingOptions));
    }

    public List<GetLookupTenantRtnType> getLookupTenant(PagingOptions pagingOptions) {
        return ((List<GetLookupTenantRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupTenantQueryName), pagingOptions));
    }

    public List<GetLookupCountryRtnType> getLookupCountry(PagingOptions pagingOptions) {
        return ((List<GetLookupCountryRtnType> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getLookupCountryQueryName), pagingOptions));
    }

    public com.zabonlinedb.data.Address getAddressById(Integer id, PagingOptions pagingOptions) {
        List<com.zabonlinedb.data.Address> rtn = ((List<com.zabonlinedb.data.Address> ) dsMgr.invoke(taskMgr.getQueryTask(), (ZABonlineDBConstants.getAddressByIdQueryName), id, pagingOptions));
        if (rtn.isEmpty()) {
            return null;
        } else {
            return rtn.get(0);
        }
    }

    public Object insert(Object o) {
        return dsMgr.invoke(taskMgr.getInsertTask(), o);
    }

    public TypedServiceReturn read(TypeDefinition rootType, Object o, PropertyOptions propertyOptions, PagingOptions pagingOptions) {
        return ((TypedServiceReturn) dsMgr.invoke(taskMgr.getReadTask(), rootType, o, propertyOptions, pagingOptions));
    }

    public Object update(Object o) {
        return dsMgr.invoke(taskMgr.getUpdateTask(), o);
    }

    public void delete(Object o) {
        dsMgr.invoke(taskMgr.getDeleteTask(), o);
    }

    public void begin() {
        dsMgr.begin();
    }

    public void commit() {
        dsMgr.commit();
    }

    public void rollback() {
        dsMgr.rollback();
    }

    public DataServiceManager getDataServiceManager() {
        return dsMgr;
    }

    public void setDataServiceManager(DataServiceManager dsMgr) {
        this.dsMgr = dsMgr;
    }

    public TaskManager getTaskManager() {
        return taskMgr;
    }

    public void setTaskManager(TaskManager taskMgr) {
        this.taskMgr = taskMgr;
    }

}
