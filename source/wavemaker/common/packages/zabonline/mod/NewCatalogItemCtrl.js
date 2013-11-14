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
  },
  loadLookupData: function() {
  },
  initCatalogItemByParameter: function(sender, parameter, titel) {
    /**
     * "parameter" ist ein JSON-String
     * Es muss immer die "kind"-Eigenschaft angegeben sein
     * "kind" gibt immer die Struktur des JSON-Strings vor          
     * für "kind": 1001
     *   "mode" unterscheiden zwischen Admin und Nicht-Admins
     *   "mode": 0 -> ist nicht admin
     *   "mode": 1 -> ist admin
     *   "page": z.B. NewCatalogItem -> Name der Page     
     *   "catalog": z.B. SALUATION -> Namer der Tabelle des Katalogs     
     *   "callback": Callback soll nach dem Beenden des Dialoges getriggert werden                         
     */         
    var global = this.globalScope;
    var local = this.localScope;
    try {    
      var kindFound = parameter.search(/kind/);
      if (kindFound != -1) {      
        this.catalogParameter = dojo.fromJson(parameter);
      
        console.debug('CatalogItemCtrl.initCatalogItemByParameter.sender: ' + sender.name)
        console.debug('CatalogItemCtrl.initCatalogItemByParameter.katalogparameter:' + parameter)
             
        if (titel) {
          global.dlgCatalogItem.setTitel(titel);
        }
  
        global.dlgCatalogItem.setPageName(this.catalogParameter.page);
        global.dlgCatalogItem.show();
    
      } else {
         throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_NO_KIND_FOUND");
      }                  
    } catch(e) {
      this.handleExceptionByCtrl(local.name + ".initCatalogItemByParameter() failed: " + e.toString(), e, -1);
    }  
  },
  resetParameter: function() {
    var global = this.globalScope;
        
    this.catalogParameter = null;
    
    console.debug('CatalogItemCtrl.resetParameter');
  },  
  subscribeForChannels: function() {
    console.debug('Start Controller.subscribeForChannels.SubClass');

    dojo.subscribe('init-catalogitem-by-parameter', this, "initCatalogItemByParameter");
    
    console.debug('End Controller.subscribeForChannels.SubClass');
  },
  handleExceptionByCtrl: function(msg, e, code) {
    this.inherited (arguments);    
  },
  handleSubscribeByResData: function(subscription) {
    this.inherited (arguments);
  }    
});