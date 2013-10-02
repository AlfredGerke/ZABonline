dojo.provide("wm.packages.zabonline.mod.AddressTypeLookup");
//
dojo.declare("AddressTypeLookup", null, {
  getCaption: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.scope.addressTypeData.getItem(index);
      return item.getValue("caption");
    } else {
      return ret;
    }  
  },
  getCount: function() {
    var count = 0;

    if (this.scope.addressTypeData.getCount() !== null) { 
      count = this.scope.addressTypeData.getCount();
    }  

    return count;
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {

      var refresh_success = 0;

      this.scope.addressTypeData.clearData();

      this.scope.addressTypeLookupData.input.setValue('CountryId', this.scope.globalData.countryId());
      if (this.scope.addressTypeLookupData.canUpdate()) {
        this.scope.addressTypeLookupData.update();
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
    console.debug('Start AddressTypeLookup.constructor');
    this.scope = globalScope;
    console.debug('End AddressTypeLookup.constructor');
  },
  postscript: function() {
    console.debug('Start AddressTypeLookup.postscript');
  
    this.scope.connect(this.scope.addressTypeData, "onSuccess", this, "onSuccess");
  
    console.debug('End AddressTypeLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    try {

    } catch (e) {
      console.error('ERROR IN addressTypeLookupDataSuccess: ' + e);
    }
  }
});