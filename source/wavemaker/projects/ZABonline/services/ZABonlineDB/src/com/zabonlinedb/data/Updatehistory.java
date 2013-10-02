
package com.zabonlinedb.data;

import java.util.Date;


/**
 *  ZABonlineDB.Updatehistory
 *  06/13/2013 22:11:55
 * 
 */
public class Updatehistory {

    private Integer id;
    private Integer number;
    private Integer subitem;
    private String script;
    private String description;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public Integer getSubitem() {
        return subitem;
    }

    public void setSubitem(Integer subitem) {
        this.subitem = subitem;
    }

    public String getScript() {
        return script;
    }

    public void setScript(String script) {
        this.script = script;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

}
