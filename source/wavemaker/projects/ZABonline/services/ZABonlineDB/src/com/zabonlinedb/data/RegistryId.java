
package com.zabonlinedb.data;

import java.io.Serializable;


/**
 *  ZABonlineDB.RegistryId
 *  12/11/2013 23:29:34
 * 
 */
public class RegistryId
    implements Serializable
{

    private String keyname;
    private String section;
    private String ident;
    private String value;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof RegistryId)) {
            return false;
        }
        RegistryId other = ((RegistryId) o);
        if (this.keyname == null) {
            if (other.keyname!= null) {
                return false;
            }
        } else {
            if (!this.keyname.equals(other.keyname)) {
                return false;
            }
        }
        if (this.section == null) {
            if (other.section!= null) {
                return false;
            }
        } else {
            if (!this.section.equals(other.section)) {
                return false;
            }
        }
        if (this.ident == null) {
            if (other.ident!= null) {
                return false;
            }
        } else {
            if (!this.ident.equals(other.ident)) {
                return false;
            }
        }
        if (this.value == null) {
            if (other.value!= null) {
                return false;
            }
        } else {
            if (!this.value.equals(other.value)) {
                return false;
            }
        }
        return true;
    }

    public int hashCode() {
        int rtn = 17;
        rtn = (rtn* 37);
        if (this.keyname!= null) {
            rtn = (rtn + this.keyname.hashCode());
        }
        rtn = (rtn* 37);
        if (this.section!= null) {
            rtn = (rtn + this.section.hashCode());
        }
        rtn = (rtn* 37);
        if (this.ident!= null) {
            rtn = (rtn + this.ident.hashCode());
        }
        rtn = (rtn* 37);
        if (this.value!= null) {
            rtn = (rtn + this.value.hashCode());
        }
        return rtn;
    }

    public String getKeyname() {
        return keyname;
    }

    public void setKeyname(String keyname) {
        this.keyname = keyname;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public String getIdent() {
        return ident;
    }

    public void setIdent(String ident) {
        this.ident = ident;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

}
