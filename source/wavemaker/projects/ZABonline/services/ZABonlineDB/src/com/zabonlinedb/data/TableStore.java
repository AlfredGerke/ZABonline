
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.TableStore
 *  12/11/2013 23:29:35
 * 
 */
public class TableStore {

    private Integer id;
    private String label;
    private String tableName;
    private String description;
    private Short donotdelete;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private Tag tag;
    private Category category;
    private Set<com.zabonlinedb.data.RelTableStoreFieldStore> reltablestorefieldstores = new HashSet<com.zabonlinedb.data.RelTableStoreFieldStore>();
    private Set<com.zabonlinedb.data.Datasheet> datasheets = new HashSet<com.zabonlinedb.data.Datasheet>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
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

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Set<com.zabonlinedb.data.RelTableStoreFieldStore> getReltablestorefieldstores() {
        return reltablestorefieldstores;
    }

    public void setReltablestorefieldstores(Set<com.zabonlinedb.data.RelTableStoreFieldStore> reltablestorefieldstores) {
        this.reltablestorefieldstores = reltablestorefieldstores;
    }

    public Set<com.zabonlinedb.data.Datasheet> getDatasheets() {
        return datasheets;
    }

    public void setDatasheets(Set<com.zabonlinedb.data.Datasheet> datasheets) {
        this.datasheets = datasheets;
    }

}
