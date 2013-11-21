dojo.provide("wm.packages.zabonline.mod.CountryCodeLookup");
//
dojo.declare("CountryCodeLookup", null, {
  getCode: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.scope.countryCodeData.getItem(index);
      return item.getValue("countryCode");
    } else {
      return ret;
    }  
  },
  getCount: function() {
    var count = 0;

    if (this.scope.countryCodeData.getCount() !== null) { 
      count = this.scope.countryCodeData.getCount();
    }  

    return count;
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {
      
      console.debug('CountryCodeLookup.refresh');

      var refresh_success = 0;

      this.scope.countryCodeData.clearData();

      if (this.scope.countryLookupData.canUpdate()) {
          this.scope.countryLookupData.update();
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
    console.debug('Start CountryCodeLookup.constructor');
    this.scope = globalScope;
    console.debug('End CountryCodeLookup.constructor');
  },
  postscript: function() {
    console.debug('Start CountryCodeLookup.postscript');

    this.scope.connect(this.scope.countryLookupData, "onSuccess", this, "onSuccess");

    console.debug('End CountryCodeLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    console.debug('Start CountryCodeLookup.onSuccess');
    try {

    } catch (e) {
        console.error('ERROR IN countryCodeLookupDataSuccess: ' + e);
    }
    console.debug('End CountryCodeLookup.onSuccess');
  }
});
