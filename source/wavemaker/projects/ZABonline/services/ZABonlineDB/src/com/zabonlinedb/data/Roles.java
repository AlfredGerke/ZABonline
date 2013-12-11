
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Roles
 *  12/11/2013 23:29:35
 * 
 */
public class Roles {

    private Integer id;
    private String caption;
    private String description;
    private Short isAdmin;
    private Short setup;
    private Short members;
    private Short activityRecording;
    private Short dtaus;
    private Short billing;
    private Short importRl;
    private Short referenceData;
    private Short reporting;
    private Short donotdelete;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Short MISC;
    private Short FILERESOURCE;
    private Short CLOSESESSION;
    private Short EXPORT;
    private Short FIND;
    private Tag tag;
    private Set<com.zabonlinedb.data.Users> userses = new HashSet<com.zabonlinedb.data.Users>();

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

    public Short getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(Short isAdmin) {
        this.isAdmin = isAdmin;
    }

    public Short getSetup() {
        return setup;
    }

    public void setSetup(Short setup) {
        this.setup = setup;
    }

    public Short getMembers() {
        return members;
    }

    public void setMembers(Short members) {
        this.members = members;
    }

    public Short getActivityRecording() {
        return activityRecording;
    }

    public void setActivityRecording(Short activityRecording) {
        this.activityRecording = activityRecording;
    }

    public Short getDtaus() {
        return dtaus;
    }

    public void setDtaus(Short dtaus) {
        this.dtaus = dtaus;
    }

    public Short getBilling() {
        return billing;
    }

    public void setBilling(Short billing) {
        this.billing = billing;
    }

    public Short getImportRl() {
        return importRl;
    }

    public void setImportRl(Short importRl) {
        this.importRl = importRl;
    }

    public Short getReferenceData() {
        return referenceData;
    }

    public void setReferenceData(Short referenceData) {
        this.referenceData = referenceData;
    }

    public Short getReporting() {
        return reporting;
    }

    public void setReporting(Short reporting) {
        this.reporting = reporting;
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

    public Short getMISC() {
        return MISC;
    }

    public void setMISC(Short MISC) {
        this.MISC = MISC;
    }

    public Short getFILERESOURCE() {
        return FILERESOURCE;
    }

    public void setFILERESOURCE(Short FILERESOURCE) {
        this.FILERESOURCE = FILERESOURCE;
    }

    public Short getCLOSESESSION() {
        return CLOSESESSION;
    }

    public void setCLOSESESSION(Short CLOSESESSION) {
        this.CLOSESESSION = CLOSESESSION;
    }

    public Short getEXPORT() {
        return EXPORT;
    }

    public void setEXPORT(Short EXPORT) {
        this.EXPORT = EXPORT;
    }

    public Short getFIND() {
        return FIND;
    }

    public void setFIND(Short FIND) {
        this.FIND = FIND;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Set<com.zabonlinedb.data.Users> getUserses() {
        return userses;
    }

    public void setUserses(Set<com.zabonlinedb.data.Users> userses) {
        this.userses = userses;
    }

}
