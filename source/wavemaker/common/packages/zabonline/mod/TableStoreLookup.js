dojo.provide("wm.packages.zabonline.mod.TableStoreLookup");
//
dojo.declare("TableStoreLookup", null, {
  getTableName: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.getResultVar().getItem(index);
      return item.getValue("tableName");
    } else {
      return ret;
    }  
  },
  getCount: function() {
    var count = 0;

    if (this.getResultVar.getCount() !== null) { 
      count = this.getResultVar.getCount();
    }  

    return count;
  },
  setResultVar: function(resVar) {
    this.resultVar = resVar;
    this.scope.connect(this.getResultVar, "onSuccess", this, "onSuccess");    
  },
  getResultVar: function() {
    return this.resultVar;
  },
  setLabel: function(label) {
    this.label = label;
  },
  getLabel: function() {
    return this.label;                                                    
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {
      
      var refresh_success = 0;

      this.getResultVar.clearData();

      this.scope.tableStoreLookupData.input.setValue('label', this.getLabel());
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