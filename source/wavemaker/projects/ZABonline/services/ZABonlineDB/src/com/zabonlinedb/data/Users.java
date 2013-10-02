
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Users
 *  06/13/2013 22:11:57
 * 
 */
public class Users {

    private Integer id;
    private String username;
    private String password;
    private String firstName;
    private String name;
    private String email;
    private Short allowLogin;
    private Short donotdelete;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private Roles roles;
    private Tag tag;
    private Person person;
    private Set<com.zabonlinedb.data.Session> sessions = new HashSet<com.zabonlinedb.data.Session>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Short getAllowLogin() {
        return allowLogin;
    }

    public void setAllowLogin(Short allowLogin) {
        this.allowLogin = allowLogin;
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

    public Roles getRoles() {
        return roles;
    }

    public void setRoles(Roles roles) {
        this.roles = roles;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Set<com.zabonlinedb.data.Session> getSessions() {
        return sessions;
    }

    public void setSessions(Set<com.zabonlinedb.data.Session> sessions) {
        this.sessions = sessions;
    }

}
