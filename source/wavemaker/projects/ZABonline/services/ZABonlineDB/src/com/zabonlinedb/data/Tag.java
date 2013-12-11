
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Tag
 *  12/11/2013 23:29:34
 * 
 */
public class Tag {

    private Integer id;
    private String tag;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Set<com.zabonlinedb.data.AddressType> addressTypes = new HashSet<com.zabonlinedb.data.AddressType>();
    private Set<com.zabonlinedb.data.Bank> banks = new HashSet<com.zabonlinedb.data.Bank>();
    private Set<com.zabonlinedb.data.Contact> contacts = new HashSet<com.zabonlinedb.data.Contact>();
    private Set<com.zabonlinedb.data.ContactType> contactTypes = new HashSet<com.zabonlinedb.data.ContactType>();
    private Set<com.zabonlinedb.data.Person> persons = new HashSet<com.zabonlinedb.data.Person>();
    private Set<com.zabonlinedb.data.Session> sessions = new HashSet<com.zabonlinedb.data.Session>();
    private Set<com.zabonlinedb.data.Tenant> tenants = new HashSet<com.zabonlinedb.data.Tenant>();
    private Set<com.zabonlinedb.data.Category> categories = new HashSet<com.zabonlinedb.data.Category>();
    private Set<com.zabonlinedb.data.FieldStore> fieldstores = new HashSet<com.zabonlinedb.data.FieldStore>();
    private Set<com.zabonlinedb.data.Factory> factories = new HashSet<com.zabonlinedb.data.Factory>();
    private Set<com.zabonlinedb.data.Address> addresses = new HashSet<com.zabonlinedb.data.Address>();
    private Set<com.zabonlinedb.data.Users> userses = new HashSet<com.zabonlinedb.data.Users>();
    private Set<com.zabonlinedb.data.Datasheet> datasheets = new HashSet<com.zabonlinedb.data.Datasheet>();
    private Set<com.zabonlinedb.data.TableStore> tablestores = new HashSet<com.zabonlinedb.data.TableStore>();
    private Set<com.zabonlinedb.data.Roles> roleses = new HashSet<com.zabonlinedb.data.Roles>();
    private Set<com.zabonlinedb.data.Country> countries = new HashSet<com.zabonlinedb.data.Country>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public Short getSoftdel() {
        return softdel;
    }

    public void setSoftdel(Short softdel) {
        this.softdel = softdel;
    }

    public String getCreUser() {
        return creUser;
    }

    public void setCreUser(String creUser) {
        this.creUser = creUser;
    }

    public Date getCreDate() {
        return creDate;
    }

    public void setCreDate(Date creDate) {
        this.creDate = creDate;
    }

    public String getChgUser() {
        return chgUser;
    }

    public void setChgUser(String chgUser) {
        this.chgUser = chgUser;
    }

    public Date getChgDate() {
        return chgDate;
    }

    public void setChgDate(Date chgDate) {
        this.chgDate = chgDate;
    }

    public Set<com.zabonlinedb.data.AddressType> getAddressTypes() {
        return addressTypes;
    }

    public void setAddressTypes(Set<com.zabonlinedb.data.AddressType> addressTypes) {
        this.addressTypes = addressTypes;
    }

    public Set<com.zabonlinedb.data.Bank> getBanks() {
        return banks;
    }

    public void setBanks(Set<com.zabonlinedb.data.Bank> banks) {
        this.banks = banks;
    }

    public Set<com.zabonlinedb.data.Contact> getContacts() {
        return contacts;
    }

    public void setContacts(Set<com.zabonlinedb.data.Contact> contacts) {
        this.contacts = contacts;
    }

    public Set<com.zabonlinedb.data.ContactType> getContactTypes() {
        return contactTypes;
    }

    public void setContactTypes(Set<com.zabonlinedb.data.ContactType> contactTypes) {
        this.contactTypes = contactTypes;
    }

    public Set<com.zabonlinedb.data.Person> getPersons() {
        return persons;
    }

    public void setPersons(Set<com.zabonlinedb.data.Person> persons) {
        this.persons = persons;
    }

    public Set<com.zabonlinedb.data.Session> getSessions() {
        return sessions;
    }

    public void setSessions(Set<com.zabonlinedb.data.Session> sessions) {
        this.sessions = sessions;
    }

    public Set<com.zabonlinedb.data.Tenant> getTenants() {
        return tenants;
    }

    public void setTenants(Set<com.zabonlinedb.data.Tenant> tenants) {
        this.tenants = tenants;
    }

    public Set<com.zabonlinedb.data.Category> getCategories() {
        return categories;
    }

    public void setCategories(Set<com.zabonlinedb.data.Category> categories) {
        this.categories = categories;
    }

    public Set<com.zabonlinedb.data.FieldStore> getFieldstores() {
        return fieldstores;
    }

    public void setFieldstores(Set<com.zabonlinedb.data.FieldStore> fieldstores) {
        this.fieldstores = fieldstores;
    }

    public Set<com.zabonlinedb.data.Factory> getFactories() {
        return factories;
    }

    public void setFactories(Set<com.zabonlinedb.data.Factory> factories) {
        this.factories = factories;
    }

    public Set<com.zabonlinedb.data.Address> getAddresses() {
        return addresses;
    }

    public void setAddresses(Set<com.zabonlinedb.data.Address> addresses) {
        this.addresses = addresses;
    }

    public Set<com.zabonlinedb.data.Users> getUserses() {
        return userses;
    }

    public void setUserses(Set<com.zabonlinedb.data.Users> userses) {
        this.userses = userses;
    }

    public Set<com.zabonlinedb.data.Datasheet> getDatasheets() {
        return datasheets;
    }

    public void setDatasheets(Set<com.zabonlinedb.data.Datasheet> datasheets) {
        this.datasheets = datasheets;
    }

    public Set<com.zabonlinedb.data.TableStore> getTablestores() {
        return tablestores;
    }

    public void setTablestores(Set<com.zabonlinedb.data.TableStore> tablestores) {
        this.tablestores = tablestores;
    }

    public Set<com.zabonlinedb.data.Roles> getRoleses() {
        return roleses;
    }

    public void setRoleses(Set<com.zabonlinedb.data.Roles> roleses) {
        this.roleses = roleses;
    }

    public Set<com.zabonlinedb.data.Country> getCountries() {
        return countries;
    }

    public void setCountries(Set<com.zabonlinedb.data.Country> countries) {
        this.countries = countries;
    }

}
