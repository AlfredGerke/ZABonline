
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RelPersonAddressId
 *  12/11/2013 23:29:35
 * 
 */
public class RelPersonAddressId
    implements Serializable
{

    private Integer personId;
    private Integer addressId;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RelPersonAddressId)) {
            return false;
        }
        RelPersonAddressId other = ((RelPersonAddressId) o);
        if (this.personId == null) {
            if (other.personId!= null) {
                return false;
            }
        } else {
            if (!this.personId.equals(other.personId)) {
                return false;
            }
        }
        if (this.addressId == null) {
            if (other.addressId!= null) {
                return false;
            }
        } else {
            if (!this.addressId.equals(other.addressId)) {
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
        if (this.addressId!= null) {
            rtn = (rtn + this.addressId.hashCode());
        }
        return rtn;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

}
