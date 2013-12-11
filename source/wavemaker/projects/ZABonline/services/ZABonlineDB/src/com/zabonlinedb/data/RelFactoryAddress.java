
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelFactoryAddress
 *  12/11/2013 23:29:35
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
