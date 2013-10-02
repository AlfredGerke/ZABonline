dojo.provide("wm.packages.zabonline.mod.ContactTypeLookup");
//
dojo.declare("ContactTypeLookup", null, {
  getCaption: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.scope.contactTypeData.getItem(index);
      return item.getValue("caption");
    } else {
      return ret;
    }  
  },
  getCount: function() {
    var count = 0;

    if (this.scope.contactTypeData.getCount() !== null) { 
      count = this.scope.contactTypeData.getCount();
    }  

    return count;
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {

      var refresh_success = 0;

      this.scope.contactTypeData.clearData();

      this.scope.contactTypeLookupData.input.setValue('CountryId', this.scope.globalData.countryId());
      if (this.scope.contactTypeLookupData.canUpdate()) {
          this.scope.contactTypeLookupData.update();
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
    console.debug('Start ContactTypeLookup.constructor');
    this.scope = globalScope;
    console.debug('End ContactTypeLookup.constructor');
  },
  postscript: function() {
    console.debug('Start ContactTypeLookup.postscript');

    this.scope.connect(this.scope.contactTypeData, "onSuccess", this, "onSuccess");

    console.debug('End ContactTypeLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    try {

    } catch (e) {
      console.error('ERROR IN contactTypeLookupDataSuccess: ' + e);
    }
  }
});
