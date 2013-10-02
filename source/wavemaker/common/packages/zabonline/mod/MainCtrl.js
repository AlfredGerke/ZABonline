dojo.provide("wm.packages.zabonline.mod.MainCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("MainCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start MainCtrl.constructor');
    
    this.initStart();
    
    console.debug('End MainCtrl.constructor');
  },
  showWarningOnConnect: function (usrPrompt) {
    try {
      this.localScope.dlgWarningOnConnect.setUserPrompt(usrPrompt);
      this.localScope.dlgWarningOnConnect.showModal();
    } catch (e) {
      console.error('ERROR IN showWarningOnConnect:' + e);
    }    
  },
  enableGUI: function () {    
    try {
      if (this.globalScope.globalData.globalDataFound()) {
        this.localScope.lbxMain.setDisabled(false);
      } else {
        this.localScope.dlgWarningOnStart.showModal();
      }
      return true;
    } catch (e) {
      console.error('ERROR IN enableGUI:' + e);
      return false;
    }         
  },
  initStart: function() {
    try {          
      this.localScope.connect(this.globalScope, "onInitLookupData", this.localScope, "onEnableGUI");
      dojo.subscribe("session-expiration", this.localScope, "onCloseSession");
      dojo.subscribe("session-expiration-servicecall", this.localScope, "onCloseSession");
      dojo.subscribe("session-expiration-databasecall", this.localScope, "onCloseSessionByDBCall");
    } catch (e) {
      console.error('ERROR IN initStart:' + e);
    }
  },
  startAddPageByName: function(global, name, titel) {
    var local = this.localScope;
    try {
      global.controller.showWizard(name, titel);
    } catch (e) {
      local.controller.handleExceptionByCtrl(local.name + "." + name + ".startAddPageByName() failed: " + e.toString(), e);
    }  
  },
  startAddUser: function(global) {
    this.startAddPageByName(global, "NewUser", "Neuanlage Benutzer");
  },
  startAddTenant: function(global) {
    this.startAddPageByName(global, "NewTenant", "Neuanlage Mandant");  
  },  
  startAddRole: function(global) {
    this.startAddPageByName(global, "NewRole", "Neuanlage Benutzerrolle");   
  },
  startAddFields: function(global) {
    this.startAddPageByName(global, "NewField", "Neuanlage Datenbankfeld");     
  },
  startAddTables: function(global) {
    this.startAddPageByName(global, "NewTable", "Neuanlage Datenbanktabelle");        
  },
  startErrOnCloseDlg: function(inError, msg) {
    var local = this.localScope;
    
    local.dlgErrorOnLogout.setTitle(local.getDictionaryItem("DLG_ERROR_ON_LOGOUT_TITEL"));
    local.dlgErrorOnLogout.setUserPrompt((!msg) ? inError : msg);  
    local.dlgErrorOnLogout.showModal();  
  
  },   
  handleSubscribeByResData: function(subscription) {
    this.inherited (arguments);
  },
  subscribeForChannels: function() {
    var global = this.globalScope;
    var local = this.localScope;
    
    console.debug('Start Controller.subscribeForChannels.SubClass');   
    
    dojo.subscribe("main-add-field", this, "startAddFields");
    dojo.subscribe("main-add-table", this, "startAddTables");
    //dojo.subscribe("main-add-goto-schema", this, "");
    dojo.subscribe("main-add-tenant", this, "startAddTenant");
    dojo.subscribe("main-add-user", this, "startAddUser");
    dojo.subscribe("main-add-role", this, "startAddRole");
    
    //this.handleSubscribeByResData("???"); <-- nur für Subsription für Service-Success-Results   
    
    console.debug('End Controller.subscribeForChannels.SubClass');    
  },  
  showSearch: function(subscription, searchParameter, titel) {
    this.inherited (arguments);
  }  
});