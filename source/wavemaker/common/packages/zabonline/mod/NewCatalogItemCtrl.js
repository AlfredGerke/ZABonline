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
    
    local.connect(global.countryCodeLookup, "onSuccess", this, "onInitCountryCode");    
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
          throw "NewCatalogItemCtrl.setQuickSetup: keine g�ltige Auswahl";
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
          throw "NewCatalogItemCtrl.clearData: keine g�ltige Auswahl";
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
        throw "Fehler beim Zur�cksetzen der Mandantenbezeichnung!";
      }

      if (!this.initSelectMenu()) {
        global.toastWarning(this.getDictionaryItem("ERROR_MSG_BY_INIT_SELECTMENU"));
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
          throw "NewTenantCtrl.initSelectMenu: keine g�ltige Auswahl";
          //
          break;    
      }
      console.debug("End NewCatalogItemCtrl.initSelectMenu");
                  
      return true;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".initSelectMenu() failed: " + e.toString(), e, -1);
      return false;
    }     
  },    
  loadLookupData: function() {
    var local = this.localScope;
    var global = this.globalScope;  
    
    var success = 0;
    try {      
     
      if (global.countryCodeLookup.refresh() > 0) {
        success = 1;
      } else {
        success = 0;
      }    

      if (success == 1) {
        this.globalScope.globalData.tenantId(this.localScope.varTenantId);
      }  
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(local.name + ".loadLookupData() failed: " + e.toString(), e, -1);      
      return false;      
    }  
  },
  initCatalogItemByParameter: function(sender, parameter, title) {
    /**
     * "parameter" ist ein JSON-String
     * Es muss immer die "kind"-Eigenschaft angegeben sein
     * "kind" gibt immer die Struktur des JSON-Strings vor          
     * f�r "kind": 1001
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
             
        if (title) {
          global.dlgCatalogItem.setTitle(title);
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