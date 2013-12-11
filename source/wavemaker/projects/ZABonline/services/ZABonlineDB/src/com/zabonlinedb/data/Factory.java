
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Factory
 *  12/11/2013 23:29:35
 * 
 */
public class Factory {

    private Integer id;
    private String factoryNumber;
    private String caption;
    private String description1;
    private String description2;
    private String description3;
    private String contactPersonName;
    private String contactPersonFirstname;
    private Integer contactPhone;
    private String contactPhoneFmt;
    private String contactEmail;
    private String description;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private Tag tag;
    private Datasheet datasheet;
    private Person person;
    private Set<com.zabonlinedb.data.RelFactoryAddress> relfactoryaddresss = new HashSet<com.zabonlinedb.data.RelFactoryAddress>();
    private Set<com.zabonlinedb.data.RelFactoryBank> relfactorybanks = new HashSet<com.zabonlinedb.data.RelFactoryBank>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getFactoryNumber() {
        return factoryNumber;
    }

    public void setFactoryNumber(String factoryNumber) {
        this.factoryNumber = factoryNumber;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getDescription1() {
        return description1;
    }

    public void setDescription1(String description1) {
        this.description1 = description1;
    }

    public String getDescription2() {
        return description2;
    }

    public void setDescription2(String description2) {
        this.description2 = description2;
    }

    public String getDescription3() {
        return description3;
    }

    public void setDescription3(String description3) {
        this.description3 = description3;
    }

    public String getContactPersonName() {
        return contactPersonName;
    }

    public void setContactPersonName(String contactPersonName) {
        this.contactPersonName = contactPersonName;
    }

    public String getContactPersonFirstname() {
        return contactPersonFirstname;
    }

    public void setContactPersonFirstname(String contactPersonFirstname) {
        this.contactPersonFirstname = contactPersonFirstname;
    }

    public Integer getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(Integer contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getContactPhoneFmt() {
        return contactPhoneFmt;
    }

    public void setContactPhoneFmt(String contactPhoneFmt) {
        this.contactPhoneFmt = contactPhoneFmt;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public Tenant getTenant() {
        return tenant;
    }

    public void setTenant(Tenant tenant) {
        this.tenant = tenant;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Datasheet getDatasheet() {
        return datasheet;
    }

    public void setDatasheet(Datasheet datasheet) {
        this.datasheet = datasheet;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Set<com.zabonlinedb.data.RelFactoryAddress> getRelfactoryaddresss() {
        return relfactoryaddresss;
    }

    public void setRelfactoryaddresss(Set<com.zabonlinedb.data.RelFactoryAddress> relfactoryaddresss) {
        this.relfactoryaddresss = relfactoryaddresss;
    }

    public Set<com.zabonlinedb.data.RelFactoryBank> getRelfactorybanks() {
        return relfactorybanks;
    }

    public void setRelfactorybanks(Set<com.zabonlinedb.data.RelFactoryBank> relfactorybanks) {
        this.relfactorybanks = relfactorybanks;
    }

}
