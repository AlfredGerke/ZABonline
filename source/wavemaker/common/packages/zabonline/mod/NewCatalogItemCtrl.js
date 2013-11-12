dojo.provide("wm.packages.zabonline.mod.NewCatalogItemCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("NewCatalogItemCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewCatalogItemCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewCatalogItemCtrl.constructor');
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;  
  }
});