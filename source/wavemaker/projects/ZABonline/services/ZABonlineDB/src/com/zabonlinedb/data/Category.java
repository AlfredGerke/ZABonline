
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Category
 *  06/13/2013 22:11:56
 * 
 */
public class Category {

    private Integer id;
    private String label;
    private String caption;
    private String description;
    private Short donotdelete;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tag tag;
    private Country country;
    private Set<com.zabonlinedb.data.FieldStore> fieldstores = new HashSet<com.zabonlinedb.data.FieldStore>();
    private Set<com.zabonlinedb.data.RelPersonCategory> relpersoncategories = new HashSet<com.zabonlinedb.data.RelPersonCategory>();
    private Set<com.zabonlinedb.data.TableStore> tablestores = new HashSet<com.zabonlinedb.data.TableStore>();

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

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Country getCountry() {
        return country;
    }

    public void setCountry(Country country) {
        this.country = country;
    }

    public Set<com.zabonlinedb.data.FieldStore> getFieldstores() {
        return fieldstores;
    }

    public void setFieldstores(Set<com.zabonlinedb.data.FieldStore> fieldstores) {
        this.fieldstores = fieldstores;
    }

    public Set<com.zabonlinedb.data.RelPersonCategory> getRelpersoncategories() {
        return relpersoncategories;
    }

    public void setRelpersoncategories(Set<com.zabonlinedb.data.RelPersonCategory> relpersoncategories) {
        this.relpersoncategories = relpersoncategories;
    }

    public Set<com.zabonlinedb.data.TableStore> getTablestores() {
        return tablestores;
    }

    public void setTablestores(Set<com.zabonlinedb.data.TableStore> tablestores) {
        this.tablestores = tablestores;
    }

}
