dojo.provide("wm.packages.zabonline.mod.Controller");

dojo.declare("Controller", null, {
  constructor: function(globalScope, localScope) {
    console.debug('Start Controller.constructor');
    
    this.globalScope = globalScope;
    if (!localScope) {
      localScope = globalScope;
    }
    this.localScope = localScope;
    
    this.subscribeForChannels();
    
    console.debug('End Controller.constructor');
  },
  postscript: function() {
    try {
      console.debug('Start Controller.postscript');

      console.debug('End Controller.postscript');
    } catch (e) {
      console.error('ERROR IN postscript: ' + e);
    } 
  },
  handleSubscribeByResData: function(subscription) {
    var local = this.localScope;
    var global = this.globalScope;
      
    dojo.subscribe(subscription, function(resData) {
      switch (resData.kind) {
        case 0:
          //
          break;
        case 1:
          global.toastError(local.getDictionaryItem(resData.message));
          //
          break;
        case 2:
          global.toastError(local.getDictionaryItem(resData.list[0].message) + ": " + local.getDictionaryItem(resData.list[1].message));
          //
          break;
        case 3:
          global.toastSuccess(local.getDictionaryItem(resData.message));
          //
          break;
        case 4:
          global.toastSuccess(local.getDictionaryItem(resData.message));
          //
          break;
        default:
          global.toastError(local.getDictionaryItem("FAILD_BY_UNKNOWN_REASON"));
          //          
          break;
      }                                                                  
    });     
  },
  subscribeForChannels: function() {
    console.debug('Start Controller.subscribeForChannels.SuperClass');
    
    console.debug('End Controller.subscribeForChannels.SuperClass');
  },
  handleErrorByCtrl: function(msg, e, code) {
    this.handleExceptionByCtrl(msg, e, code);
  },
  handleExceptionByCtrl: function(msg, e, code) {
    var global = this.globalScope;
    var local = this.localScope;
    
    console.error(msg + " - " + e);
    
    if (!code) {
      global.toastError(msg);
    } else {
      if (code==1) {
        global.alert(e);
      }
    }        
  },
  showSearch: function(sender, searchParameter, title) {
    var local = this.localScope;
    try {    
      dojo.publish('init-search-by-parameter', [sender, searchParameter, title]);
    } catch(e) {
      this.handleExceptionByCtrl(this.localScope.name + ".showSearch() failed: " + e.toString(), e, -1);
    }
  },
  showCatalogItem: function(sender, catalogParameter, callback, title) {
    var local = this.localScope;
    try {    
      dojo.publish('init-catalogitem-by-parameter', [sender, catalogParameter, callback, title]);
    } catch(e) {
      this.handleExceptionByCtrl(local.name + ".showCatalogItem() failed: " + e.toString(), e, -1);
    }
  },
  showCountryCodes: function(sender, catalogParameter, callback, title) {
    var local = this.localScope;
    try {    
      dojo.publish('init-countrycode-by-parameter', [sender, catalogParameter, callback, title]);
    } catch(e) {
      this.handleExceptionByCtrl(local.name + ".showCountryCodes() failed: " + e.toString(), e, -1);
    }
  }    
});
