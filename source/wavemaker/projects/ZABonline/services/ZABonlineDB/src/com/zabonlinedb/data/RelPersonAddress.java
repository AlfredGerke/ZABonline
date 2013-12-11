
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelPersonAddress
 *  12/11/2013 23:29:35
 * 
 */
public class RelPersonAddress {

    private RelPersonAddressId id;
    private Person person;
    private Address address;

    public RelPersonAddressId getId() {
        return id;
    }

    public void setId(RelPersonAddressId id) {
        this.id = id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

}
