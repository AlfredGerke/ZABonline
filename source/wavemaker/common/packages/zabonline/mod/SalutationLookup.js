dojo.provide("wm.packages.zabonline.mod.SalutationLookup");
//
dojo.declare("SalutationLookup", null, {
  getCaption: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.scope.salutationData.getItem(index);
      return item.getValue("caption");
    } else {
      return ret;
    }  
  },
  getDescriptionByIndex: function(index, ret) {
    if (this.getCount() > index) {
      var item = this.scope.salutationData.getItem(index);
      return item.getValue("description");
    } else {
      return ret;
    }
  },
  getCount: function() {
    var count = 0;

    if (this.scope.salutationData.getCount() !== null) { 
      count = this.scope.salutationData.getCount();
    }  

    return count;
  },
  refresh: function(force) {
    if ((this.getCount() === 0) || (force == 1)) {

      var refresh_success = 0;

      this.scope.salutationData.clearData();

      this.scope.salutationLookupData.input.setValue('CountryId', this.scope.globalData.countryId());
      if (this.scope.salutationLookupData.canUpdate()) {
          this.scope.salutationLookupData.update();
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
    console.debug('Start SalutationLookup.constructor');
    this.scope = globalScope;
    console.debug('End SalutationLookup.constructor');
  },
  postscript: function() {
    console.debug('Start SalutationLookup.postscript');

    this.scope.connect(this.scope.salutationLookupData, "onSuccess", this, "onSuccess");

    console.debug('End SalutationLookup.postscript');
  },
  onSuccess: function(inSender, inDeprecated) {
    try {
      console.debug('Start SalutationLookup.onSuccess');
      
      console.debug('End SalutationLookup.onSuccess');
    } catch (e) {
      console.error('ERROR IN salutationLookupDataSuccess: ' + e);
    }
  }
});
