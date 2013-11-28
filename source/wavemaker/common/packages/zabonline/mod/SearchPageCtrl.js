dojo.provide("wm.packages.zabonline.mod.SearchPageCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("SearchPageCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start SearchPageCtrl.constructor');
    
    this.initStart();
    
    console.debug('End SearchPageCtrl.constructor');
  },
  initControls: function(global, local) {
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;
    
    this.initControls(global, local);
  },
  loadLookupData: function() {
    var success = 1;
    var local = this.localScope;
    try { 
    
      if (success == 1) {                              
        this.globalScope.globalData.tenantId(this.localScope.varTenantId);
      }
      
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".loadLookupData() failed: " + e.toString(), e, -1);      
      return false;      
    }
  },
  handleExceptionByCtrl: function(msg, e, code) {
    this.inherited (arguments);    
  },
  handleSubscribeByResData: function(subscription) {
    this.inherited (arguments);
  },  
  initSearchByParameter: function(sender, parameter, titel) {
    /**
     * "parameter" ist ein JSON-String
     * Es muss immer die "kind"-Eigenschaft angegeben sein
     * "kind" gibt immer die Struktur des JSON-Strings vor          
     * für "kind": 1000
     *   "mode" stellt die Art der Suche ien
     *   "mode": 0 -> Mit jeder Zeicheneingabe eine Suchanfrage an den Server schicken
     *   "mode": 1 -> Erst mit Return Suche starten
     *   "find": entity in der gesucht werden soll     
     *   "callback": proc die bei der Auswahl eines Suchergebenisses aufgerufen werden soll                         
     */         
    var global = this.globalScope;
    var local = this.localScope;
    try {    
      var kindFound = parameter.search(/kind/);
      if (kindFound != -1) {      
        this.searchParameter = dojo.fromJson(parameter);
      
        console.debug('SearchPageCtrl.initSearchByParameter.sender: ' + sender.name)
        console.debug('SearchPageCtrl.initSearchByParameter.suchparameter:' + parameter)
        
        this.conResetParamterHandle = local.connect(global.dlgSearchPage, "onClose", this, "resetParameter");
      
        if (titel) {
          global.dlgSearchPage.setTitel(titel);
        }
  
        global.dlgSearchPage.show();
      } else {
         throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_NO_KIND_FOUND");
      }                  
    } catch(e) {
      this.handleExceptionByCtrl(local.name + ".initSearchByParameter() failed: " + e.toString(), e, -1);
    }
  },
  resetParameter: function() {
    var global = this.globalScope;
    
    global.disconnect(this.conResetParamterHandle);
    
    this.conResetParamterHandle = null;
    this.searchParameter = null;
    
    console.debug('SearchPageCtrl.resetParameter');
  },
  subscribeForChannels: function() {
    console.debug('Start Controller.subscribeForChannels.SubClass');

    dojo.subscribe('init-search-by-parameter', this, "initSearchByParameter");
    
    console.debug('End Controller.subscribeForChannels.SubClass');
  }          
});
