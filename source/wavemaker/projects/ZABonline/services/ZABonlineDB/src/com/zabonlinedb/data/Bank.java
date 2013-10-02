
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Bank
 *  06/13/2013 22:11:55
 * 
 */
public class Bank {

    private Integer id;
    private String caption;
    private Integer blz;
    private Integer kto;
    private String iban;
    private String bic;
    private String description;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private Tag tag;
    private Set<com.zabonlinedb.data.RelPersonBank> relPersonBanks = new HashSet<com.zabonlinedb.data.RelPersonBank>();
    private Set<com.zabonlinedb.data.RelFactoryBank> relfactorybanks = new HashSet<com.zabonlinedb.data.RelFactoryBank>();

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

    public Integer getBlz() {
        return blz;
    }

    public void setBlz(Integer blz) {
        this.blz = blz;
    }

    public Integer getKto() {
        return kto;
    }

    public void setKto(Integer kto) {
        this.kto = kto;
    }

    public String getIban() {
        return iban;
    }

    public void setIban(String iban) {
        this.iban = iban;
    }

    public String getBic() {
        return bic;
    }

    public void setBic(String bic) {
        this.bic = bic;
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

    public Set<com.zabonlinedb.data.RelPersonBank> getRelPersonBanks() {
        return relPersonBanks;
    }

    public void setRelPersonBanks(Set<com.zabonlinedb.data.RelPersonBank> relPersonBanks) {
        this.relPersonBanks = relPersonBanks;
    }

    public Set<com.zabonlinedb.data.RelFactoryBank> getRelfactorybanks() {
        return relfactorybanks;
    }

    public void setRelfactorybanks(Set<com.zabonlinedb.data.RelFactoryBank> relfactorybanks) {
        this.relfactorybanks = relfactorybanks;
    }

}
