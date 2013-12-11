
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelPersonContact
 *  12/11/2013 23:29:34
 * 
 */
public class RelPersonContact {

    private RelPersonContactId id;
    private Contact contact;
    private Person person;

    public RelPersonContactId getId() {
        return id;
    }

    public void setId(RelPersonContactId id) {
        this.id = id;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

}
