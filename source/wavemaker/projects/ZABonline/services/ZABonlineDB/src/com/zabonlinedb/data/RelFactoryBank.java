
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelFactoryBank
 *  12/11/2013 23:29:35
 * 
 */
public class RelFactoryBank {

    private RelFactoryBankId id;
    private Factory factory;
    private Bank bank;

    public RelFactoryBankId getId() {
        return id;
    }

    public void setId(RelFactoryBankId id) {
        this.id = id;
    }

    public Factory getFactory() {
        return factory;
    }

    public void setFactory(Factory factory) {
        this.factory = factory;
    }

    public Bank getBank() {
        return bank;
    }

    public void setBank(Bank bank) {
        this.bank = bank;
    }

}
