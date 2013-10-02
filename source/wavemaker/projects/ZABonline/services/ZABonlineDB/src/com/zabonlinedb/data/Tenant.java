
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Tenant
 *  06/13/2013 22:11:56
 * 
 */
public class Tenant {

    private Integer id;
    private String caption;
    private String description;
    private Short donotdelete;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Country country;
    private Tag tag;
    private Set<com.zabonlinedb.data.Bank> banks = new HashSet<com.zabonlinedb.data.Bank>();
    private Set<com.zabonlinedb.data.Contact> contacts = new HashSet<com.zabonlinedb.data.Contact>();
    private Set<com.zabonlinedb.data.Person> persons = new HashSet<com.zabonlinedb.data.Person>();
    private Set<com.zabonlinedb.data.FieldStore> fieldstores = new HashSet<com.zabonlinedb.data.FieldStore>();
    private Set<com.zabonlinedb.data.Factory> factories = new HashSet<com.zabonlinedb.data.Factory>();
    private Set<com.zabonlinedb.data.Address> addresses = new HashSet<com.zabonlinedb.data.Address>();
    private Set<com.zabonlinedb.data.Users> userses = new HashSet<com.zabonlinedb.data.Users>();
    private Set<com.zabonlinedb.data.Datasheet> datasheets = new HashSet<com.zabonlinedb.data.Datasheet>();
    private Set<com.zabonlinedb.data.TableStore> tablestores = new HashSet<com.zabonlinedb.data.TableStore>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Short getDonotdelete() {
        return donotdelete;
    }

    public void setDonotdelete(Short donotdelete) {
        this.donotdelete = donotdelete;
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

    public Country getCountry() {
        return country;
    }

    public void setCountry(Country country) {
        this.country = country;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
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

    public Set<com.zabonlinedb.data.Person> getPersons() {
        return persons;
    }

    public void setPersons(Set<com.zabonlinedb.data.Person> persons) {
        this.persons = persons;
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

}
