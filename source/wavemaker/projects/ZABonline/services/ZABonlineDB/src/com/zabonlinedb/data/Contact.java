
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Contact
 *  06/13/2013 22:11:58
 * 
 */
public class Contact {

    private Integer id;
    private String areaCode;
    private Integer phone;
    private String phoneFmt;
    private Integer fax;
    private String faxFmt;
    private String www;
    private String email;
    private String skype;
    private String messangername;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private ContactType contactType;
    private Tag tag;
    private Set<com.zabonlinedb.data.RelPersonContact> relPersonContacts = new HashSet<com.zabonlinedb.data.RelPersonContact>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAreaCode() {
        return areaCode;
    }

    public void setAreaCode(String areaCode) {
        this.areaCode = areaCode;
    }

    public Integer getPhone() {
        return phone;
    }

    public void setPhone(Integer phone) {
        this.phone = phone;
    }

    public String getPhoneFmt() {
        return phoneFmt;
    }

    public void setPhoneFmt(String phoneFmt) {
        this.phoneFmt = phoneFmt;
    }

    public Integer getFax() {
        return fax;
    }

    public void setFax(Integer fax) {
        this.fax = fax;
    }

    public String getFaxFmt() {
        return faxFmt;
    }

    public void setFaxFmt(String faxFmt) {
        this.faxFmt = faxFmt;
    }

    public String getWww() {
        return www;
    }

    public void setWww(String www) {
        this.www = www;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSkype() {
        return skype;
    }

    public void setSkype(String skype) {
        this.skype = skype;
    }

    public String getMessangername() {
        return messangername;
    }

    public void setMessangername(String messangername) {
        this.messangername = messangername;
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

    public ContactType getContactType() {
        return contactType;
    }

    public void setContactType(ContactType contactType) {
        this.contactType = contactType;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Set<com.zabonlinedb.data.RelPersonContact> getRelPersonContacts() {
        return relPersonContacts;
    }

    public void setRelPersonContacts(Set<com.zabonlinedb.data.RelPersonContact> relPersonContacts) {
        this.relPersonContacts = relPersonContacts;
    }

}
