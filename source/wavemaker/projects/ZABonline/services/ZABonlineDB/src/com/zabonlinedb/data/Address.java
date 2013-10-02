
package com.zabonlinedb.data;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


/**
 *  ZABonlineDB.Address
 *  06/13/2013 22:11:55
 * 
 */
public class Address {

    private Integer id;
    private String street;
    private String streetAddressFrom;
    private String streetAddressTo;
    private String city;
    private String district;
    private Integer zipcode;
    private String postOfficeBox;
    private Short ispostaddress;
    private Short isprivate;
    private Short softdel;
    private String creUser;
    private Date creDate;
    private String chgUser;
    private Date chgDate;
    private Tenant tenant;
    private AddressType addressType;
    private Tag tag;
    private Set<com.zabonlinedb.data.RelPersonAddress> relPersonAddresses = new HashSet<com.zabonlinedb.data.RelPersonAddress>();
    private Set<com.zabonlinedb.data.RelFactoryAddress> relfactoryaddresss = new HashSet<com.zabonlinedb.data.RelFactoryAddress>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getStreetAddressFrom() {
        return streetAddressFrom;
    }

    public void setStreetAddressFrom(String streetAddressFrom) {
        this.streetAddressFrom = streetAddressFrom;
    }

    public String getStreetAddressTo() {
        return streetAddressTo;
    }

    public void setStreetAddressTo(String streetAddressTo) {
        this.streetAddressTo = streetAddressTo;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public Integer getZipcode() {
        return zipcode;
    }

    public void setZipcode(Integer zipcode) {
        this.zipcode = zipcode;
    }

    public String getPostOfficeBox() {
        return postOfficeBox;
    }

    public void setPostOfficeBox(String postOfficeBox) {
        this.postOfficeBox = postOfficeBox;
    }

    public Short getIspostaddress() {
        return ispostaddress;
    }

    public void setIspostaddress(Short ispostaddress) {
        this.ispostaddress = ispostaddress;
    }

    public Short getIsprivate() {
        return isprivate;
    }

    public void setIsprivate(Short isprivate) {
        this.isprivate = isprivate;
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

    public AddressType getAddressType() {
        return addressType;
    }

    public void setAddressType(AddressType addressType) {
        this.addressType = addressType;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Set<com.zabonlinedb.data.RelPersonAddress> getRelPersonAddresses() {
        return relPersonAddresses;
    }

    public void setRelPersonAddresses(Set<com.zabonlinedb.data.RelPersonAddress> relPersonAddresses) {
        this.relPersonAddresses = relPersonAddresses;
    }

    public Set<com.zabonlinedb.data.RelFactoryAddress> getRelfactoryaddresss() {
        return relfactoryaddresss;
    }

    public void setRelfactoryaddresss(Set<com.zabonlinedb.data.RelFactoryAddress> relfactoryaddresss) {
        this.relfactoryaddresss = relfactoryaddresss;
    }

}
