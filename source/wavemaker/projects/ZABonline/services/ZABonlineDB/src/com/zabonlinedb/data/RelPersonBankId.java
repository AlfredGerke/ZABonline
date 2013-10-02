
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RelPersonBankId
 *  06/13/2013 22:11:55
 * 
 */
public class RelPersonBankId
    implements Serializable
{

    private Integer personId;
    private Integer bankId;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RelPersonBankId)) {
            return false;
        }
        RelPersonBankId other = ((RelPersonBankId) o);
        if (this.personId == null) {
            if (other.personId!= null) {
                return false;
            }
        } else {
            if (!this.personId.equals(other.personId)) {
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
        if (this.personId!= null) {
            rtn = (rtn + this.personId.hashCode());
        }
        rtn = (rtn* 37);
        if (this.bankId!= null) {
            rtn = (rtn + this.bankId.hashCode());
        }
        return rtn;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public Integer getBankId() {
        return bankId;
    }

    public void setBankId(Integer bankId) {
        this.bankId = bankId;
    }

}
