
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RelPersonCategoryId
 *  06/13/2013 22:11:57
 * 
 */
@SuppressWarnings("serial")
public class RelPersonCategoryId
    implements Serializable
{

    private Integer personId;
    private Integer categoryId;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RelPersonCategoryId)) {
            return false;
        }
        RelPersonCategoryId other = ((RelPersonCategoryId) o);
        if (this.personId == null) {
            if (other.personId!= null) {
                return false;
            }
        } else {
            if (!this.personId.equals(other.personId)) {
                return false;
            }
        }
        if (this.categoryId == null) {
            if (other.categoryId!= null) {
                return false;
            }
        } else {
            if (!this.categoryId.equals(other.categoryId)) {
                return false;
            }
        }
        return true;
    }

    public int hashCode() {
        int rtn = 17;
        rtn = (rtn* 37);
        if (this.personId!= null) {
            rtn = (rtn + this.personId.hashCode());
        }
        rtn = (rtn* 37);
        if (this.categoryId!= null) {
            rtn = (rtn + this.categoryId.hashCode());
        }
        return rtn;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

}
