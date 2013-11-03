dojo.provide("wm.packages.zabonline.mod.ZabonlineCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("ZabonlineCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start Zabonline.constructor');
    
    console.debug('End Zabonline.constructor');
  },
  postscript: function() {
    try {
      console.debug('Start Zabonline.postscript');

      console.debug('End Zabonline.postscript');
    } catch (e) {
      console.error('ERROR IN postscript: ' + e);
    } 
  },
  requireLookups: function() {
    try {
      console.debug('Start Zabonline.requireLookups');
      
      wm.require("zabonline.mod.TitelLookup", true);
      wm.require("zabonline.mod.AddressTypeLookup", true);
      wm.require("zabonline.mod.ContactTypeLookup", true);
      wm.require("zabonline.mod.AreaCodeLookup", true);
      wm.require("zabonline.mod.SalutationLookup", true);
      wm.require("zabonline.mod.CountryCodeLookup", true);
      
      console.debug('End Zabonline.requireLookups');
    } catch (e) {
      console.error('ERROR IN requireLookups: ' + e);
    }    
  },
  createLookups: function() {
    try {
      console.debug('Start Zabonline.createLookups');
      
      this.globalScope.titelLookup = new TitelLookup(app);
      this.globalScope.addressTypeLookup = new AddressTypeLookup(app);
      this.globalScope.contactTypeLookup = new ContactTypeLookup(app);
      this.globalScope.areaCodeLookup = new AreaCodeLookup(app);
      this.globalScope.salutationLookup = new SalutationLookup(app);
      this.globalScope.countryCodeLookup = new CountryCodeLookup(app);
      
      console.debug('End Zabonline.createLookups');
    } catch (e) {
      console.error('ERROR IN createLookups: ' + e);
    }        
  },
  requireGlobalData: function(usr) {
    try {
      console.debug('Start Zabonline.requireGlobalData');
      
      wm.require("zabonline.mod.GlobalData", true);
      dojo.ready(this.globalScope.createGlobalDataOnRequireReady(usr));
              
      console.debug('End Zabonline.requireGlobalData');    
    } catch (e) {
      console.error('ERROR IN requireGlobalData: ' + e);
    }
  },
  createGlobalData: function(usr, onInitLookupData) {
    try {
      console.debug('Start Zabonline.createGlobalData');
      
      this.globalScope.globalData = new GlobalData(app, onInitLookupData);
      this.globalScope.globalData.refresh(usr);
      
      console.debug('End Zabonline.createGlobalData');
    } catch (e) {
      console.error('ERROR IN createGlobalData: ' + e);                                                   
    }         
  },
  reInitWizard: function() {
    try {
      console.debug('Start Zabonline.reInitWizard');
      
      if (!this.wizDLGByShowWizard) {
        this.globalScope.wizDialog.setPageName("");
      } else {
        this.wizDLGByShowWizard.setPageName("");
      }
      
      console.debug('End Zabonline.reInitWizard');
    } catch (e) {
      console.error('ERROR IN reInitWizard: ' + e);                                                      
    }             
  },
  onCloseWizard: function() {
      console.debug('Start Zabonline.onCloseWizard');
      var global = this.globalScope;
      try {
        this.reInitWizard();
        if (!this.wizDLGByShowWizard) {
          this.globalScope.wizDialog.hide();
        } else {
          this.wizDLGByShowWizard.hide();
        }
      } finally {
        global.disconnect(this.conHandle);
        this.conHandle = null;
        this.wizDLGByShowWizard = null;
      }
        
      console.debug('End Zabonline.onCloseWizard');        
  },
  closeWizard: function(askFor, title) {
    try {
      console.debug('Start Zabonline.closeWizard');      
      
      if (askFor) {
        this.globalScope.dlgConfirmDlg.setTitle((!title) ? this.globalScope.getDictionaryItem("CONFIRM_DLG_TITLE") : title);
        this.globalScope.dlgConfirmDlg.setUserPrompt(askFor);  
        this.globalScope.dlgConfirmDlg.showModal();
      } else {
        this.onCloseWizard();
      }
            
      console.debug('End Zabonline.closeWizard');
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".closeWizard() failed: " + e.toString(), e, -1);
    }
  },
  showWizard: function(page, title, inWiz, sender, callback, subscribtion) {
    var global = this.globalScope;    
    try {          
      if (!inWiz) {

        if (callback) {
          this.conHandle = global.connect(global.wizSubDialog, "onClose", sender, callback);
        }                

        this.wizDLGByShowWizard = null;             
        this.globalScope.wizDialog.setTitle(title);
        this.globalScope.wizDialog.setPageName(page);
        this.globalScope.wizDialog.show();
      } else {

        if (callback) {
          this.conHandle = global.connect(global.wizSubDialog, "onClose", sender, callback);
        }          
        
        this.wizDLGByShowWizard = this.globalScope.wizSubDialog;
        this.wizDLGByShowWizard.setTitle(title);
        this.wizDLGByShowWizard.setPageName(page);
        this.wizDLGByShowWizard.show();              
      }
      
      if (subscribtion) {
        dojo.publish(subscribtion, [true]);
      }            

    } catch (e) {      
      this.handleExceptionByCtrl(this.localScope.name + ".showWizard() failed: " + e.toString(), e, -1);
    }
  },
  subscribeForChannels: function() {
    dojo.subscribe("close-wizard", this, "onCloseWizard");
  },
  executeByGrant: function(select) {
    var global = this.globalScope;  
    
    switch (select) {
    case "???":
        dojo.publish(select, [global]);
        //
        break;
    default:
        //
        break;
    }  
  },
  executeByGrantAdmin: function(select) {
    var global = this.globalScope;  
    
    switch (select) {
    case "main-add-field":
        dojo.publish(select, [global]);
        //
        break;
    case "main-add-table":
        dojo.publish(select, [global]);
        //
        break;
    case "main-add-tenant":
        dojo.publish(select, [global]);
        //
        break;
    case "main-add-user":
        dojo.publish(select, [global]);
        //
        break;    
    case "main-add-role":
        dojo.publish(select, [global]);
        //
        break;               
    case "main-add-goto-schema":
        dojo.publish(select, [global]);
        //
        break;
    default:
        //
        break;
    }  
  },  
  startGrantedModuleByChannel: function(grant, channel) {
    var global = this.globalScope;
    
    global.grantToCheck.setValue("dataValue", grant);
    global.selectMenu.setValue("dataValue", channel);
    
    if (global.checkGrant.canUpdate()) {
      global.checkGrant.update();
    }
  },
  startAdminGrantedModuleByChannel: function(channel) {
    var global = this.globalScope;

    global.selectMenu.setValue("dataValue", channel);
    
    if (global.checkGrantAdmin.canUpdate()) {
      global.checkGrantAdmin.update();
    }
  }                
});