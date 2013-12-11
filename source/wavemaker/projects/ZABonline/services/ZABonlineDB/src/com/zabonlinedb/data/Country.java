
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Country
 *  12/11/2013 23:29:34
 * 
 */
public class Country {

    private Integer id;
    private String countryCode;
    private String countryCaption;
    private String currencyCode;
    private String CURRENCY_CAPTION;
    private String description;
    private Short donotdelete;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tag tag;
    private Set<com.zabonlinedb.data.Titel> titels = new HashSet<com.zabonlinedb.data.Titel>();
    private Set<com.zabonlinedb.data.AddressType> addressTypes = new HashSet<com.zabonlinedb.data.AddressType>();
    private Set<com.zabonlinedb.data.ContactType> contactTypes = new HashSet<com.zabonlinedb.data.ContactType>();
    private Set<com.zabonlinedb.data.Salutation> salutations = new HashSet<com.zabonlinedb.data.Salutation>();
    private Set<com.zabonlinedb.data.Tenant> tenants = new HashSet<com.zabonlinedb.data.Tenant>();
    private Set<com.zabonlinedb.data.Category> categories = new HashSet<com.zabonlinedb.data.Category>();
    private Set<com.zabonlinedb.data.AreaCode> areacodes = new HashSet<com.zabonlinedb.data.AreaCode>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getCountryCaption() {
        return countryCaption;
    }

    public void setCountryCaption(String countryCaption) {
        this.countryCaption = countryCaption;
    }

    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }

    public String getCURRENCY_CAPTION() {
        return CURRENCY_CAPTION;
    }

    public void setCURRENCY_CAPTION(String CURRENCY_CAPTION) {
        this.CURRENCY_CAPTION = CURRENCY_CAPTION;
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

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Set<com.zabonlinedb.data.Titel> getTitels() {
        return titels;
    }

    public void setTitels(Set<com.zabonlinedb.data.Titel> titels) {
        this.titels = titels;
    }

    public Set<com.zabonlinedb.data.AddressType> getAddressTypes() {
        return addressTypes;
    }

    public void setAddressTypes(Set<com.zabonlinedb.data.AddressType> addressTypes) {
        this.addressTypes = addressTypes;
    }

    public Set<com.zabonlinedb.data.ContactType> getContactTypes() {
        return contactTypes;
    }

    public void setContactTypes(Set<com.zabonlinedb.data.ContactType> contactTypes) {
        this.contactTypes = contactTypes;
    }

    public Set<com.zabonlinedb.data.Salutation> getSalutations() {
        return salutations;
    }

    public void setSalutations(Set<com.zabonlinedb.data.Salutation> salutations) {
        this.salutations = salutations;
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

    public Set<com.zabonlinedb.data.AreaCode> getAreacodes() {
        return areacodes;
    }

    public void setAreacodes(Set<com.zabonlinedb.data.AreaCode> areacodes) {
        this.areacodes = areacodes;
    }

}
