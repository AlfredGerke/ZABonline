
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RelFactoryBankId
 *  12/11/2013 23:29:35
 * 
 */
@SuppressWarnings("serial")
public class RelFactoryBankId
    implements Serializable
{

    private Integer factoryId;
    private Integer bankId;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RelFactoryBankId)) {
            return false;
        }
        RelFactoryBankId other = ((RelFactoryBankId) o);
        if (this.factoryId == null) {
            if (other.factoryId!= null) {
                return false;
            }
        } else {
            if (!this.factoryId.equals(other.factoryId)) {
                return false;
            }
        }
        if (this.bankId == null) {
            if (other.bankId!= null) {
                return false;
            }
        } else {
            if (!this.bankId.equals(other.bankId)) {
                return false;
            }
        }
        return true;
    }

    public int hashCode() {
        int rtn = 17;
        rtn = (rtn* 37);
        if (this.factoryId!= null) {
            rtn = (rtn + this.factoryId.hashCode());
        }
        rtn = (rtn* 37);
        if (this.bankId!= null) {
            rtn = (rtn + this.bankId.hashCode());
        }
        return rtn;
    }

    public Integer getFactoryId() {
        return factoryId;
    }

    public void setFactoryId(Integer factoryId) {
        this.factoryId = factoryId;
    }

    public Integer getBankId() {
        return bankId;
    }

    public void setBankId(Integer bankId) {
        this.bankId = bankId;
    }

}
