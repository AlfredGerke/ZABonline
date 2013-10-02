dojo.provide("wm.packages.zabonline.mod.TitelLookup");
//
dojo.declare("TitelLookup", null, {
  getCaption: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.scope.titelData.getItem(index);
      return item.getValue("caption");
    } else {
      return ret;
    }  
  },
  getCount: function() {
    var count = 0;

    if (this.scope.titelData.getCount() !== null) 
      count = this.scope.titelData.getCount();

    return count;
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {

      var refresh_success = 0;

      this.scope.titelData.clearData();

      this.scope.titelLookupData.input.setValue('CountryId', this.scope.globalData.countryId());
      if (this.scope.titelLookupData.canUpdate()) {
          this.scope.titelLookupData.update();
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
    console.debug('Start TitelLookup.constructor');
    this.scope = globalScope;
    console.debug('End TitelLookup.constructor');
  },
  postscript: function() {
    console.debug('Start TitelLookup.postscript');

    this.scope.connect(this.scope.titelLookupData, "onSuccess", this, "onSuccess");

    console.debug('End TitelLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    try {

    } catch (e) {
        console.error('ERROR IN titelLookupDataSuccess: ' + e);
    }
  }
});