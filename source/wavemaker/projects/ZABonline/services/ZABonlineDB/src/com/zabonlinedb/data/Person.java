
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Person
 *  12/11/2013 23:29:35
 * 
 */
public class Person {

    private Integer id;
    private String firstname;
    private String name1;
    private String name2;
    private String name3;
    private Short married;
    private Date marriedSince;
    private String marriagePartnerFirstname;
    private String marriagePartnerName1;
    private String salutation1;
    private String salutation2;
    private Date dayOfBirth;
    private Short isprivate;
    private byte[] picture;
    private String description;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private Titel titel;
    private Tag tag;
    private Salutation salutation;
    private com.zabonlinedb.data.Person person;
    private Set<com.zabonlinedb.data.RelPersonBank> relPersonBanks = new HashSet<com.zabonlinedb.data.RelPersonBank>();
    private Set<com.zabonlinedb.data.Person> persons = new HashSet<com.zabonlinedb.data.Person>();
    private Set<com.zabonlinedb.data.RelPersonAddress> relPersonAddresses = new HashSet<com.zabonlinedb.data.RelPersonAddress>();
    private Set<com.zabonlinedb.data.RelPersonContact> relPersonContacts = new HashSet<com.zabonlinedb.data.RelPersonContact>();
    private Set<com.zabonlinedb.data.Factory> factories = new HashSet<com.zabonlinedb.data.Factory>();
    private Set<com.zabonlinedb.data.Users> userss = new HashSet<com.zabonlinedb.data.Users>();
    private Set<com.zabonlinedb.data.RelPersonCategory> relpersoncategories = new HashSet<com.zabonlinedb.data.RelPersonCategory>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getName1() {
        return name1;
    }

    public void setName1(String name1) {
        this.name1 = name1;
    }

    public String getName2() {
        return name2;
    }

    public void setName2(String name2) {
        this.name2 = name2;
    }

    public String getName3() {
        return name3;
    }

    public void setName3(String name3) {
        this.name3 = name3;
    }

    public Short getMarried() {
        return married;
    }

    public void setMarried(Short married) {
        this.married = married;
    }

    public Date getMarriedSince() {
        return marriedSince;
    }

    public void setMarriedSince(Date marriedSince) {
        this.marriedSince = marriedSince;
    }

    public String getMarriagePartnerFirstname() {
        return marriagePartnerFirstname;
    }

    public void setMarriagePartnerFirstname(String marriagePartnerFirstname) {
        this.marriagePartnerFirstname = marriagePartnerFirstname;
    }

    public String getMarriagePartnerName1() {
        return marriagePartnerName1;
    }

    public void setMarriagePartnerName1(String marriagePartnerName1) {
        this.marriagePartnerName1 = marriagePartnerName1;
    }

    public String getSalutation1() {
        return salutation1;
    }

    public void setSalutation1(String salutation1) {
        this.salutation1 = salutation1;
    }

    public String getSalutation2() {
        return salutation2;
    }

    public void setSalutation2(String salutation2) {
        this.salutation2 = salutation2;
    }

    public Date getDayOfBirth() {
        return dayOfBirth;
    }

    public void setDayOfBirth(Date dayOfBirth) {
        this.dayOfBirth = dayOfBirth;
    }

    public Short getIsprivate() {
        return isprivate;
    }

    public void setIsprivate(Short isprivate) {
        this.isprivate = isprivate;
    }

    public byte[] getPicture() {
        return picture;
    }

    public void setPicture(byte[] picture) {
        this.picture = picture;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public Titel getTitel() {
        return titel;
    }

    public void setTitel(Titel titel) {
        this.titel = titel;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Salutation getSalutation() {
        return salutation;
    }

    public void setSalutation(Salutation salutation) {
        this.salutation = salutation;
    }

    public com.zabonlinedb.data.Person getPerson() {
        return person;
    }

    public void setPerson(com.zabonlinedb.data.Person person) {
        this.person = person;
    }

    public Set<com.zabonlinedb.data.RelPersonBank> getRelPersonBanks() {
        return relPersonBanks;
    }

    public void setRelPersonBanks(Set<com.zabonlinedb.data.RelPersonBank> relPersonBanks) {
        this.relPersonBanks = relPersonBanks;
    }

    public Set<com.zabonlinedb.data.Person> getPersons() {
        return persons;
    }

    public void setPersons(Set<com.zabonlinedb.data.Person> persons) {
        this.persons = persons;
    }

    public Set<com.zabonlinedb.data.RelPersonAddress> getRelPersonAddresses() {
        return relPersonAddresses;
    }

    public void setRelPersonAddresses(Set<com.zabonlinedb.data.RelPersonAddress> relPersonAddresses) {
        this.relPersonAddresses = relPersonAddresses;
    }

    public Set<com.zabonlinedb.data.RelPersonContact> getRelPersonContacts() {
        return relPersonContacts;
    }

    public void setRelPersonContacts(Set<com.zabonlinedb.data.RelPersonContact> relPersonContacts) {
        this.relPersonContacts = relPersonContacts;
    }

    public Set<com.zabonlinedb.data.Factory> getFactories() {
        return factories;
    }

    public void setFactories(Set<com.zabonlinedb.data.Factory> factories) {
        this.factories = factories;
    }

    public Set<com.zabonlinedb.data.Users> getUserss() {
        return userss;
    }

    public void setUserss(Set<com.zabonlinedb.data.Users> userss) {
        this.userss = userss;
    }

    public Set<com.zabonlinedb.data.RelPersonCategory> getRelpersoncategories() {
        return relpersoncategories;
    }

    public void setRelpersoncategories(Set<com.zabonlinedb.data.RelPersonCategory> relpersoncategories) {
        this.relpersoncategories = relpersoncategories;
    }

}
