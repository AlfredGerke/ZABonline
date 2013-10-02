
package com.zabonlinedb.data;



/**
 *  ZABonlineDB.RelTableStoreFieldStore
 *  06/13/2013 22:11:58
 * 
 */
public class RelTableStoreFieldStore {

    private RelTableStoreFieldStoreId id;
    private TableStore tableStore;
    private FieldStore fieldStore;

    public RelTableStoreFieldStoreId getId() {
        return id;
    }

    public void setId(RelTableStoreFieldStoreId id) {
        this.id = id;
    }

    public TableStore getTableStore() {
        return tableStore;
    }

    public void setTableStore(TableStore tableStore) {
        this.tableStore = tableStore;
    }

    public FieldStore getFieldStore() {
        return fieldStore;
    }

    public void setFieldStore(FieldStore fieldStore) {
        this.fieldStore = fieldStore;
    }

}
