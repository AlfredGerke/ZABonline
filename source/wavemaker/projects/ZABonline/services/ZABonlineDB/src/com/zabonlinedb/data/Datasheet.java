
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Datasheet
 *  06/13/2013 22:11:56
 * 
 */
public class Datasheet {

    private Integer id;
    private String caption;
    private String description;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tag tag;
    private Tenant tenant;
    private TableStore tableStore;
    private Set<com.zabonlinedb.data.Factory> factories = new HashSet<com.zabonlinedb.data.Factory>();

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

    public Tenant getTenant() {
        return tenant;
    }

    public void setTenant(Tenant tenant) {
        this.tenant = tenant;
    }

    public TableStore getTableStore() {
        return tableStore;
    }

    public void setTableStore(TableStore tableStore) {
        this.tableStore = tableStore;
    }

    public Set<com.zabonlinedb.data.Factory> getFactories() {
        return factories;
    }

    public void setFactories(Set<com.zabonlinedb.data.Factory> factories) {
        this.factories = factories;
    }

}
