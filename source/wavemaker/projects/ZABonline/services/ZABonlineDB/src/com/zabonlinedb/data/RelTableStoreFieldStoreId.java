
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RelTableStoreFieldStoreId
 *  12/11/2013 23:29:34
 * 
 */
@SuppressWarnings("serial")
public class RelTableStoreFieldStoreId
    implements Serializable
{

    private Integer tableId;
    private Integer fieldId;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RelTableStoreFieldStoreId)) {
            return false;
        }
        RelTableStoreFieldStoreId other = ((RelTableStoreFieldStoreId) o);
        if (this.tableId == null) {
            if (other.tableId!= null) {
                return false;
            }
        } else {
            if (!this.tableId.equals(other.tableId)) {
                return false;
            }
        }
        if (this.fieldId == null) {
            if (other.fieldId!= null) {
                return false;
            }
        } else {
            if (!this.fieldId.equals(other.fieldId)) {
                return false;
            }
        }
        return true;
    }

    public int hashCode() {
        int rtn = 17;
        rtn = (rtn* 37);
        if (this.tableId!= null) {
            rtn = (rtn + this.tableId.hashCode());
        }
        rtn = (rtn* 37);
        if (this.fieldId!= null) {
            rtn = (rtn + this.fieldId.hashCode());
        }
        return rtn;
    }

    public Integer getTableId() {
        return tableId;
    }

    public void setTableId(Integer tableId) {
        this.tableId = tableId;
    }

    public Integer getFieldId() {
        return fieldId;
    }

    public void setFieldId(Integer fieldId) {
        this.fieldId = fieldId;
    }

}
