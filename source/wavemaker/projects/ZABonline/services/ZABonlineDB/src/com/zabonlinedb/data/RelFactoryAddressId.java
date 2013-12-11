
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RelFactoryAddressId
 *  12/11/2013 23:29:35
 * 
 */
public class RelFactoryAddressId
    implements Serializable
{

    private Integer addressId;
    private Integer factoryId;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RelFactoryAddressId)) {
            return false;
        }
        RelFactoryAddressId other = ((RelFactoryAddressId) o);
        if (this.addressId == null) {
            if (other.addressId!= null) {
                return false;
            }
        } else {
            if (!this.addressId.equals(other.addressId)) {
                return false;
            }
        }
        if (this.factoryId == null) {
            if (other.factoryId!= null) {
                return false;
            }
        } else {
            if (!this.factoryId.equals(other.factoryId)) {
                return false;
            }
        }
        return true;
    }

    public int hashCode() {
        int rtn = 17;
        rtn = (rtn* 37);
        if (this.addressId!= null) {
            rtn = (rtn + this.addressId.hashCode());
        }
        rtn = (rtn* 37);
        if (this.factoryId!= null) {
            rtn = (rtn + this.factoryId.hashCode());
        }
        return rtn;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public Integer getFactoryId() {
        return factoryId;
    }

    public void setFactoryId(Integer factoryId) {
        this.factoryId = factoryId;
    }

}
