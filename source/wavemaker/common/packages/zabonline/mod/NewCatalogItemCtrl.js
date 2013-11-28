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
  initControls: function() {
    var local = this.localScope;
    
    local.pnlCatalogTitle.setTitle(local.getDictionaryItem("CAPTION_CATALOG"));  
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;  
    
    this.initControls();    
  },  
  setCountryCodeControlByMode: function(mode){
    var local = this.localScope;
    switch (mode) {
      case 0:
        local.btnFindCountry.setShowing(false);
        local.btnAddCountryCode.setShowing(false);
        local.edtContryCode.setDisabled(true);
        
        break;
      case 1:
        local.btnFindCountry.setShowing(true);
        local.btnAddCountryCode.setShowing(true);
        local.edtContryCode.setDisabled(false);
                
        break;
      default:
        local.btnFindCountry.setShowing(false);
        local.btnAddCountryCode.setShowing(false);
        local.edtContryCode.setDisabled(true);
      
        break;    
    }
  },
  onInitControls: function() {
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
    var local = this.localScope;
    var catalog = this.catalogParameter.catalog; 
    var mode = this.catalogParameter.mode;
    
    if (catalog) {
      local.pnlCatalogTitle.setTitle(local.getDictionaryItem("CAPTION_CATALOG") + ": " + catalog); 
      local.varCatalog.setValue("dataValue", catalog);  
    }
    
    if (mode) {
      this.setCountryCodeControlByMode(mode);
    } else {
      this.setCountryCodeControlByMode(0);
    }
  },
  setByQuickSetup: function(target, doRequire, doClear) {
    var local = this.localScope;
    var ret = false;    
    var no_reg_expr = local.getDictionaryItem("REG_EXPR_NO_EXPR"); 
    try {
      switch (target) {
        case "Catalog":  
          //local.edtContryCode.quickSetup(doRequire, no_reg_expr, doClear);
          local.edtDescription.quickSetup(doRequire, no_reg_expr, doClear);
          local.edtCaption.quickSetup(doRequire, no_reg_expr, doClear);
          //
          ret = true;          
          break;
        default:
          throw "NewCatalogItemCtrl.setQuickSetup: keine gültige Auswahl";
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
          throw "NewCatalogItemCtrl.clearData: keine gültige Auswahl";
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
        throw "Fehler beim Einrichten der Mandantenbezeichnung!";
      }
            
      if (!this.clearData("Catalog")) {
        throw "Fehler beim Zurücksetzen der Mandantenbezeichnung!";
      }

      if (!this.initSelectMenu()) {
        global.toastWarning(local.getDictionaryItem("ERROR_MSG_BY_INIT_SELECTMENU"));
      }
      
      return true;
    } catch (e) {    
      this.handleExceptionByCtrl(this.localScope.name + ".clearWizard() failed: " + e.toString(), e, -1);      
      return false;
    }
  },  
  onInitCountryCode: function() {
    this.initSelectMenu("CountryCode");
  },
  initSelectMenu: function(target, idx) {  
    var global = this.globalScope;
    var local = this.localScope;
    var doBreak = true;    
    try {
      console.debug("Start NewCatalogItemCtrl.initSelectMenu");
      
      if (!target) {
        target = "CountryCode";
        doBreak = false; 
      }
      
      if (!idx) {
        idx = 0;
      }
      
      switch (target) {
        case "CountryCode":
          //
          var initCountryCodeValue = global.globalData.countryCode();
          local.edtContryCode.setDisplayValue(initCountryCodeValue);
          //
          break;
        default:
          throw "NewTenantCtrl.initSelectMenu: keine gültige Auswahl";
          //
          break;    
      }
      console.debug("End NewCatalogItemCtrl.initSelectMenu");
                  
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
      if (!this.cclCon) {
        this.cclCon = local.connect(global.countryCodeLookup, "onSuccess", this, "onInitCountryCode");
      }
     
      if (global.countryCodeLookup.refresh() > 0) {
        success = 1;
      } else {
        success = 0;
      }    

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
     * für "kind": 1001
     *   "mode" unterscheiden zwischen Admin und Nicht-Admins
     *   "mode": 0 -> ist nicht admin
     *   "mode": 1 -> ist admin
     *   "page": z.B. NewCatalogItem -> Name der Page     
     *   "catalog": z.B. SALUATION -> Namer der Tabelle des Katalogs                             
     */         
    var global = this.globalScope;
    var local = this.localScope;
    
    this.sender = sender;
    this.callback = callback;
    try {    
      var kindFound = parameter.search(/kind/);
      if (kindFound != -1) {      
        this.catalogParameter = dojo.fromJson(parameter);
                 
        console.debug('CatalogItemCtrl.initCatalogItemByParameter.sender: ' + sender.name);
        console.debug('CatalogItemCtrl.initCatalogItemByParameter.katalogparameter:' + parameter);
             
        if (title) {
          global.dlgCatalogItem.setTitle(title);         
        }
        
        global.dlgCatalogItem.setPageName(this.catalogParameter.page);
        global.dlgCatalogItem.show();
        
        this.conHandle = local.connect(global.dlgCatalogItem, "onClose", this, "resetParameter");
        
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

    dojo.subscribe('init-catalogitem-by-parameter', this, "initCatalogItemByParameter");
    this.handleSubscribeByResData("NO_MANDATORY_MANDANT_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_VALID_MANDANT_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_VALID_DONOTLOGIN_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_CATALOG_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_CATALOGTABLE_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_COUNTRY_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_VALID_COUNTRY_ID_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_CAPTION_BY_NEWCATALOGITEM");
    this.handleSubscribeByResData("NO_MANDATORY_DESCRIPTION_BY_NEWCATALOGITEM");    
    this.handleSubscribeByResData("INSERT_BY_CATALOGITEM_FAILD_BY_NEWCATLOGITEM");
    this.handleSubscribeByResData("ADD_CATALOGITEM_SUCCEEDED");
    this.handleSubscribeByResData("FAILD_BY_OBSCURE_PROCESSING");
    
    console.debug('End Controller.subscribeForChannels.SubClass');
  },
  handleExceptionByCtrl: function(msg, e, code) {
    this.inherited (arguments);    
  },
  handleSubscribeByResData: function(subscription) {
    this.inherited (arguments);
  }    
});