
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelPersonCategory
 *  06/13/2013 22:11:57
 * 
 */
public class RelPersonCategory {

    private RelPersonCategoryId id;
    private Person person;
    private Category category;

    public RelPersonCategoryId getId() {
        return id;
    }

    public void setId(RelPersonCategoryId id) {
        this.id = id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

}
