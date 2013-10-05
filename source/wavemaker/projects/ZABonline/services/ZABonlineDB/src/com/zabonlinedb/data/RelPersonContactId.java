
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RelPersonContactId
 *  06/13/2013 22:11:57
 * 
 */
@SuppressWarnings("serial")
public class RelPersonContactId
    implements Serializable
{

    private Integer personId;
    private Integer contactId;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RelPersonContactId)) {
            return false;
        }
        RelPersonContactId other = ((RelPersonContactId) o);
        if (this.personId == null) {
            if (other.personId!= null) {
                return false;
            }
        } else {
            if (!this.personId.equals(other.personId)) {
                return false;
            }
        }
        if (this.contactId == null) {
            if (other.contactId!= null) {
                return false;
            }
        } else {
            if (!this.contactId.equals(other.contactId)) {
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
        if (this.contactId!= null) {
            rtn = (rtn + this.contactId.hashCode());
        }
        return rtn;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public Integer getContactId() {
        return contactId;
    }

    public void setContactId(Integer contactId) {
        this.contactId = contactId;
    }

}
