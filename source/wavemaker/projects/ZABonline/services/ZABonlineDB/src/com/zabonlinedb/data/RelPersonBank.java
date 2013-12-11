
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelPersonBank
 *  12/11/2013 23:29:34
 * 
 */
public class RelPersonBank {

    private RelPersonBankId id;
    private Person person;
    private Bank bank;

    public RelPersonBankId getId() {
        return id;
    }

    public void setId(RelPersonBankId id) {
        this.id = id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Bank getBank() {
        return bank;
    }

    public void setBank(Bank bank) {
        this.bank = bank;
    }

}
