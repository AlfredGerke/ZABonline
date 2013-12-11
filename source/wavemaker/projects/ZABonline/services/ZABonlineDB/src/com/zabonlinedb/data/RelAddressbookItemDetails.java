
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelAddressbookItemDetails
 *  12/11/2013 23:29:35
 * 
 */
public class RelAddressbookItemDetails {

    private Integer personId;
    private Integer tenantId;
    private String firstName;
    private String name1;
    private String phoneFmt;
    private String email;

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public Integer getTenantId() {
        return tenantId;
    }

    public void setTenantId(Integer tenantId) {
        this.tenantId = tenantId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getName1() {
        return name1;
    }

    public void setName1(String name1) {
        this.name1 = name1;
    }

    public String getPhoneFmt() {
        return phoneFmt;
    }

    public void setPhoneFmt(String phoneFmt) {
        this.phoneFmt = phoneFmt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

}
