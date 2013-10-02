
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.FieldStore
 *  06/13/2013 22:11:57
 * 
 */
public class FieldStore {

    private Integer id;
    private String label;
    private String code;
    private String name;
    private String dataType;
    private Integer typeLength;
    private Integer typeScale;
    private Short mandatory;
    private Short isForeignKey;
    private Short isLookup;
    private String referenceTable;
    private String lookupCaptionField;
    private String lookupRefIdField;
    private String uniqueIdxName;
    private Short isCalculated;
    private String calcSpName;
    private Short isVisible;
    private String description;
    private Short donotdelete;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private Tag tag;
    private com.zabonlinedb.data.FieldStore fieldStore;
    private Category category;
    private Set<com.zabonlinedb.data.RelTableStoreFieldStore> reltablestorefieldstores = new HashSet<com.zabonlinedb.data.RelTableStoreFieldStore>();
    private Set<com.zabonlinedb.data.FieldStore> fieldstores = new HashSet<com.zabonlinedb.data.FieldStore>();

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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public Integer getTypeLength() {
        return typeLength;
    }

    public void setTypeLength(Integer typeLength) {
        this.typeLength = typeLength;
    }

    public Integer getTypeScale() {
        return typeScale;
    }

    public void setTypeScale(Integer typeScale) {
        this.typeScale = typeScale;
    }

    public Short getMandatory() {
        return mandatory;
    }

    public void setMandatory(Short mandatory) {
        this.mandatory = mandatory;
    }

    public Short getIsForeignKey() {
        return isForeignKey;
    }

    public void setIsForeignKey(Short isForeignKey) {
        this.isForeignKey = isForeignKey;
    }

    public Short getIsLookup() {
        return isLookup;
    }

    public void setIsLookup(Short isLookup) {
        this.isLookup = isLookup;
    }

    public String getReferenceTable() {
        return referenceTable;
    }

    public void setReferenceTable(String referenceTable) {
        this.referenceTable = referenceTable;
    }

    public String getLookupCaptionField() {
        return lookupCaptionField;
    }

    public void setLookupCaptionField(String lookupCaptionField) {
        this.lookupCaptionField = lookupCaptionField;
    }

    public String getLookupRefIdField() {
        return lookupRefIdField;
    }

    public void setLookupRefIdField(String lookupRefIdField) {
        this.lookupRefIdField = lookupRefIdField;
    }

    public String getUniqueIdxName() {
        return uniqueIdxName;
    }

    public void setUniqueIdxName(String uniqueIdxName) {
        this.uniqueIdxName = uniqueIdxName;
    }

    public Short getIsCalculated() {
        return isCalculated;
    }

    public void setIsCalculated(Short isCalculated) {
        this.isCalculated = isCalculated;
    }

    public String getCalcSpName() {
        return calcSpName;
    }

    public void setCalcSpName(String calcSpName) {
        this.calcSpName = calcSpName;
    }

    public Short getIsVisible() {
        return isVisible;
    }

    public void setIsVisible(Short isVisible) {
        this.isVisible = isVisible;
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

    public com.zabonlinedb.data.FieldStore getFieldStore() {
        return fieldStore;
    }

    public void setFieldStore(com.zabonlinedb.data.FieldStore fieldStore) {
        this.fieldStore = fieldStore;
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

    public Set<com.zabonlinedb.data.FieldStore> getFieldstores() {
        return fieldstores;
    }

    public void setFieldstores(Set<com.zabonlinedb.data.FieldStore> fieldstores) {
        this.fieldstores = fieldstores;
    }

}
