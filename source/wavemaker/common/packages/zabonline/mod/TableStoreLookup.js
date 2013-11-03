// Modul wird für die Löschung freigegeben
// Das Modul wird wahrscheinlich aus dem Projekt entfernt
dojo.provide("wm.packages.zabonline.mod.TableStoreLookup");
//
dojo.declare("TableStoreLookup", null, {
  getTableName: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.getItemFunc(this.callbackScope, this.label, index);
      return item.getValue("tableName");
    } else {
      return ret;
    }  
  },
  getCount: function() {
    var count = this.getCountFunc(this.callbackScope, this.label);

    if (count !== null) { 
      return count;
    } else {
      return 0;
    }  
  },
  registerCallback: function(scope, callbackGetItem, callbackClearData, callbackGetCount) {
    this.callbackScope = scope;
    this.getItemFunc = callbackGetItem;
    this.clearDataFunc = callbackClearData;
    this.getCountFunc = callbackGetCount;    
  },
  setLabel: function(label) {
    this.label = label;
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {
      
      var refresh_success = 0;

      this.clearDataFunc(this.callbackScope, this.label);

      this.scope.tableStoreLookupData.input.setValue('label', this.label);
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
  
    console.debug('End TableStoreLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    try {
      console.debug('Start TableStoreLookup.onSuccess');
      
      console.debug('End TableStoreLookup.onSuccess');      
    } catch (e) {
      console.error('ERROR IN tableStoreLookupDataSuccess: ' + e);
    }
  }
});