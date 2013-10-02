
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelFactoryAddress
 *  06/13/2013 22:11:54
 * 
 */
public class RelFactoryAddress {

    private RelFactoryAddressId id;
    private Address address;
    private Factory factory;

    public RelFactoryAddressId getId() {
        return id;
    }

    public void setId(RelFactoryAddressId id) {
        this.id = id;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public Factory getFactory() {
        return factory;
    }

    public void setFactory(Factory factory) {
        this.factory = factory;
    }

}
