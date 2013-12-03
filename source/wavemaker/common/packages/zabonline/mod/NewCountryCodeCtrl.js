dojo.provide("wm.packages.zabonline.mod.NewCountryCodeCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("NewCountryCodeCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewCountryCodeCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewCountryCodeCtrl.constructor');
  },
  initControls: function() {
    var local = this.localScope;
    
    local.pnlCatalogTitle.setTitle(local.getDictionaryItem("CAPTION_CATALOG"));  
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;  
    
    this.initControls();    
  },  
  onInitControls: function() {
    /**
     * "parameter" ist ein JSON-String
     * Es muss immer die "kind"-Eigenschaft angegeben sein
     * "kind" gibt immer die Struktur des JSON-Strings vor          
     * für "kind": 1002
     *     "page": z.B. NewCountry -> Name der Page     
     */
    var local = this.localScope;
    
  },
  setByQuickSetup: function(target, doRequire, doClear) {
    var local = this.localScope;
    var ret = false;    
    var no_reg_expr = local.getDictionaryItem("REG_EXPR_NO_EXPR");
     
    try {
      switch (target) {
        case "Catalog":  
          local.edtCountryCode.quickSetup(doRequire, no_reg_expr, doClear);
          local.edtCurrencyCode.quickSetup(doRequire, no_reg_expr, doClear);
          local.edtAreaCode.quickSetup(doRequire, no_reg_expr, doClear);
          local.edtDescription.quickSetup(doRequire, no_reg_expr, doClear);
          //
          ret = true;          
          break;
        default:
          throw "NewCountryCodeCtrl.setQuickSetup: keine gültige Auswahl";
          //
          ret = flase;          
          break;
      }
      return ret;
    } catch (e) {
      this.handleExceptionByCtrl(local.name + ".setByQuickSetup() failed: " + e.toString(), e, -1);
      return false;
    }
  },  
  clearData: function(target) {
    var global = this.globalScope;
    var local = this.localScope;    
    var ret = false;
    
    try {
      switch (target) {
        case "Catalog":
          local.pnlDetail.clearData();                   
          //          
          ret = true;          
          break;
        default:
          throw "NewCountryCodeCtrl.clearData: keine gültige Auswahl";
          //
          ret = flase;          
          break;
      }      
      return ret;
    } catch (e) {
      this.handleExceptionByCtrl(local.name + ".clearData() failed: " + e.toString(), e, -1);      
      return false;
    }
  },  
  clearWizard: function() {
    try {
      if (!this.setByQuickSetup("Catalog", true, true)) {
        throw "Fehler beim Einrichten der Katalogbezeichnung!";
      }
            
      if (!this.clearData("Catalog")) {
        throw "Fehler beim Zurücksetzen der Katalogbezeichnung!";
      }

      /* 
       * Stand 2013-12-02: wird derzeit nicht benätigt
       *       
      if (!this.initSelectMenu()) {
        global.toastWarning(local.getDictionaryItem("ERROR_MSG_BY_INIT_SELECTMENU"));
      }
       *
       *
       */              
      
      return true;
    } catch (e) {    
      this.handleExceptionByCtrl(this.localScope.name + ".clearWizard() failed: " + e.toString(), e, -1);      
      return false;
    }
  },  
  onInitCountryCode: function() {
  },
  initSelectMenu: function(target, idx) {  
    var global = this.globalScope;
    var local = this.localScope;
    var doBreak = true;
        
    try {
      console.debug("Start NewCountryCodeCtrl.initSelectMenu");
      
      if (!target) {
        target = "???";
        doBreak = false; 
      }
      
      if (!idx) {
        idx = 0;
      }
      
      switch (target) {
        case "???":
          //
          //var initCountryCodeValue = global.globalData.countryCode();
          //local.edtContryCode.setDisplayValue(initCountryCodeValue);
          //
          break;
        default:
          throw "NewTenantCtrl.initSelectMenu: keine gültige Auswahl";
          //
          break;    
      }
      console.debug("End NewCountryCodeCtrl.initSelectMenu");
                  
      return true;
    } catch (e) {
      this.handleExceptionByCtrl(local.name + ".initSelectMenu() failed: " + e.toString(), e, -1);
      return false;
    }     
  },    
  loadLookupData: function() {
    var local = this.localScope;
    var global = this.globalScope;      
    var success = 0;
    
    try {           
      success = 1;

      if (success == 1) {
        this.globalScope.globalData.tenantId(local.varTenantId);
      }  
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(local.name + ".loadLookupData() failed: " + e.toString(), e, -1);      
      return false;      
    }  
  },
  initCatalogItemByParameter: function(sender, parameter, callback, title) {
    /**
     * "parameter" ist ein JSON-String
     * Es muss immer die "kind"-Eigenschaft angegeben sein
     * "kind" gibt immer die Struktur des JSON-Strings vor          
     * für "kind": 1002
     *     "page": z.B. NewCountry -> Name der Page 
     *     "catalog": COUNTRY_CODES         
     */         
    var global = this.globalScope;
    var local = this.localScope;
    
    this.sender = sender;
    this.callback = callback;
    try {    
      var kindFound = parameter.search(/kind/);
      if (kindFound != -1) {      
        this.catalogParameter = dojo.fromJson(parameter);
                 
        console.debug('CountryCodeCtrl.initCatalogItemByParameter.sender: ' + sender.name);
        console.debug('CountryCodeCtrl.initCatalogItemByParameter.katalogparameter:' + parameter);
             
        if (title) {
          global.dlgCatalogItem.setTitle(title);         
        }
        
        this.conHandle = local.connect(global.dlgCatalogItem, "onClose", this, "resetParameter");
        
        global.dlgCountryCodes.setPageName(this.catalogParameter.page);
        global.dlgCountryCodes.show();
      } else {
         throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_NO_KIND_FOUND");
      }                  
    } catch(e) {
      this.handleExceptionByCtrl(local.name + ".initCatalogItemByParameter() failed: " + e.toString(), e, -1);
    }  
  },
  resetParameter: function() {
    var global = this.globalScope;
    var local = this.localScope;
        
    local.disconnect(this.conHandle);
        
    this.callback(this.sender, this.catalogParameter.catalog);    
        
    this.catalogParameter = null;
    
    console.debug('CatalogItemCtrl.resetParameter');
  },  
  subscribeForChannels: function() {
    console.debug('Start Controller.subscribeForChannels.SubClass');

    dojo.subscribe('init-countrycode-by-parameter', this, "initCatalogItemByParameter");
    /*
     *
     *     
    this.handleSubscribeByResData("NO_MANDATORY_MANDANT_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_VALID_MANDANT_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_VALID_DONOTLOGIN_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_CATALOG_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_CATALOGTABLE_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_COUNTRY_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_VALID_COUNTRY_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_CAPTION_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_DESCRIPTION_BY_NEWCATALOGITEM");    
    this.handleSubscribeByResData("INSERT_BY_COUNTRYCODES_FAILD_BY_NEWCOUNTRY");
    this.handleSubscribeByResData("ADD_COUNTRYCODES_SUCCEEDED");
     *
     *
     */          
    this.handleSubscribeByResData("FAILD_BY_OBSCURE_PROCESSING");
    
    console.debug('End Controller.subscribeForChannels.SubClass');
  },
  handleExceptionByCtrl: function(msg, e, code) {
    this.inherited (arguments);    
  },
  handleSubscribeByResData: function(subscription) {
    this.inherited (arguments);
  },
  checkGrantAdminAddCountry: function() {
    var local = this.localScope;
    var success = 0;
    
    if (local.checkGrantAdmin.canUpdate()) {
      local.checkGrantAdmin.update();
      success = 1;
    } else {
      success = 0;
    }
    
    return success;   
  }    
});