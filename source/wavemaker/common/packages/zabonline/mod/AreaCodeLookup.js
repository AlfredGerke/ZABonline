dojo.provide("wm.packages.zabonline.mod.AreaCodeLookup");
//
dojo.declare("AreaCodeLookup", null, {
  getCount: function() {
    var count = 0;

    if (this.scope.areaCodeData.getCount() !== null) { 
      count = this.scope.areaCodeData.getCount();
    }  

    return count;
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {

      var refresh_success = 0;

      this.scope.areaCodeData.clearData();

      this.scope.areaCodeLookupData.input.setValue('CountryId', this.scope.globalData.countryId());
      if (this.scope.areaCodeLookupData.canUpdate()) {
          this.scope.areaCodeLookupData.update();
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
    console.debug('Start AreaCodeLookup.constructor');
    this.scope = globalScope;
    console.debug('End AreaCodeLookup.constructor');
  },
  postscript: function() {
    console.debug('Start AreaCodeLookup.postscript');

    this.scope.connect(this.scope.areaCodeData, "onSuccess", this, "onSuccess");

    console.debug('End AreaCodeLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    try {

    } catch (e) {
        console.error('ERROR IN areaCodeLookupDataSuccess: ' + e);
    }
  }
});