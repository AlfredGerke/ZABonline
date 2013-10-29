dojo.provide("wm.packages.zabonline.mod.TableStoreLookup");
//
dojo.declare("TableStoreLookup", null, {
  getTableName: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.scope.tableStoreData.getItem(index);
      return item.getValue("tableName");
    } else {
      return ret;
    }  
  },
  getCount: function() {
    var count = 0;

    if (this.scope.tableStoreData.getCount() !== null) { 
      count = this.scope.tableStoreData.getCount();
    }  

    return count;
  },
  getLabel: function() {
    return "";
  },
  refresh: function(label, force) {
    if ((this.getCount() === 0) || (force == 1)) {

      var refresh_success = 0;

      this.scope.tableStoreData.clearData();

      this.scope.tableStoreLookupData.input.setValue('label', getLabel);
      if (this.scope.tableStoreLookupData.canUpdate()) {
        this.scope.tableStoreLookupData.update();
        refresh_success = 1;
      } else {
        refresh_success = 0;
      }

      return refresh_success;
    } else {
      return this.getCount();
    }
  },
  constructor: function(globalScope) {
    console.debug('Start TableStoreLookup.constructor');
    this.scope = globalScope;
    console.debug('End TableStoreLookup.constructor');
  },
  postscript: function() {
    console.debug('Start TableStoreLookup.postscript');
  
    this.scope.connect(this.scope.tableStoreData, "onSuccess", this, "onSuccess");
  
    console.debug('End TableStoreLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    try {

    } catch (e) {
      console.error('ERROR IN tableStoreLookupDataSuccess: ' + e);
    }
  }
});