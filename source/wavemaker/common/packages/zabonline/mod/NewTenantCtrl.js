dojo.provide("wm.packages.zabonline.mod.NewTenantCtrl");

wm.require("zabonline.mod.Controller", true);

dojo.declare("NewTenantCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewTenantCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewTenantCtrl.constructor');
  },
  //Callback wird für TabelStoreLookup benötigt
  tsLookupDataByCallback: function() {
    return function(scope, label) {
      try {
        switch (label) {
        case "PERSON_DATA":
          return scope.tsLookupPersonData;
          
          break;
        case "FACTORY_DATA":
          return scope.tsLookupFactoryData;
          
          break;
        case "CONTACT_DATA":
          return scope.tsLookupContactData;
          
          break;
        case "ADDRESS_DATA":
          return scope.tsLookupAddressData;
          
          break;                      
        default:
          throw "tsLookupDataByCallback: keine gültige Auswahl";
          //
          break;    
      }
      console.debug("End NewTenantCtrl.initSelectMenu");
                  
      } catch (e) {
      console.debug("tsLookupDataByCallback failed: " + e.toString());
      return null;
      }    
    };
  },
  onInitCountryCode: function() {
    this.initSelectMenu("CountryCode");
  },
  onInitDSPeronData: function() {
    this.initSelectMenu("PesonData");  
  },
  onInitDSFactoryData: function() {
    this.initSelectMenu("FactoryData");  
  },
  onInitDSContactData: function() {
    this.initSelectMenu("ContactData");  
  },
  onInitDSAddressData: function() {
    this.initSelectMenu("AddressData");  
  },    
  initControls: function(global, local) {
    local.edtSessionIdleTime.setValue("helpText", local.getDictionaryItem("HELP_SESSIONIDLETIME_INFO"));
    local.edtSessionLifetime.setValue("helpText", local.getDictionaryItem("HELP_SESSIONLIFETIME_INFO"));
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;
    
    this.initControls(global, local); 
  
    local.connect(global.countryCodeLookup, "onSuccess", this, "onInitCountryCode");
    local.connect(local.tsLookupPersonData, "onSuccess", this, "onInitDSPeronData");
    local.connect(local.tsLookupFactoryData, "onSuccess", this, "onInitDSFactoryData");
    local.connect(local.tsLookupContactData, "onSuccess", this, "onInitDSContactData");
    local.connect(local.tsLookupAddressData, "onSuccess", this, "onInitDSAddressData");  
  },
  setReferenceButtons: function(scope, showing){
    scope.btnAddFactoryDatasheet.setShowing(showing);
    scope.btnFindFactoryDatasheet.setShowing(showing);
    scope.btnAddPersonDatasheet.setShowing(showing);
    scope.btnAddContactDatasheet.setShowing(showing);
    scope.btnFindContactDatasheet.setShowing(showing);
    scope.btnAddAddressDatasheet.setShowing(showing);
    scope.btnAddAddressDatasheet.setShowing(showing);  
  },
  initAsSubDialog: function(onStart) {
    var local = this.localScope;
    if (onStart) {
      this.setReferenceButtons(local, false);
    } else {
      this.setReferenceButtons(local, true);    
    }
  },  
  initSelectMenu: function(target, idx) {  
    var global = this.globalScope;
    var local = this.localScope;
    var doBreak = true;    
    try {
      console.debug("Start NewTenantCtrl.initSelectMenu");
      
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
          //Vorerst den Default-CountryCode des Users einstellen
          //var initCountryCodeValue = global.countryCodeLookup.getCode(idx, "");
          var initCountryCodeValue = global.globalData.countryCode();
          local.cboAreaCode.setDisplayValue(initCountryCodeValue);
          //
          if (doBreak) {            
            break;
          }
        case "PesonData":
          global.tableStoreLookup.registerCallback(local, this.tsLookupDataByCallback());
          
          global.tableStoreLookup.setLabel("PERSON_DATA");
          //Vorerst Feld auf "" setzen
          //var initTablename = global.tableStoreLookup.getTableName(idx, "");
          var initTablename = " ";
          local.cboPersonDatasheet.setDisplayValue(initTablename);                           
          //
          if (doBreak) {            
            break;
          }  
        case "FactoryData":
          global.tableStoreLookup.registerCallback(local, this.tsLookupDataByCallback());
          
          //Vorerst Feld auf "" setzen          
          global.tableStoreLookup.setLabel("FACTORY_DATA");
          //var initTablename = global.tableStoreLookup.getTableName(idx, "");
          var initTablename = " ";
          local.cboFactoryDatasheet.setDisplayValue(initTablename);          
          //
          if (doBreak) {            
            break;
          }          
        case "ContactData":
          global.tableStoreLookup.registerCallback(local, this.tsLookupDataByCallback());
          
          //Vorerst Feld auf "" setzen
          global.tableStoreLookup.setLabel("CONTACT_DATA");
          //var initTablename = global.tableStoreLookup.getTableName(idx, "");
          var initTablename = " ";
          local.cboContactDatasheet.setDisplayValue(initTablename);          
          //
          if (doBreak) {            
            break;
          }          
        case "AddressData":  
          global.tableStoreLookup.registerCallback(local, this.tsLookupDataByCallback());

          global.tableStoreLookup.setLabel("ADDRESS_DATA");
          //Vorerst Feld auf "" setzen
          //var initTablename = global.tableStoreLookup.getTableName(idx, "");
          var initTablename = " ";          
          local.cboAddressDatasheet.setDisplayValue(initTablename);
            
          break;         
        default:
          throw "NewTenantCtrl.initSelectMenu: keine gültige Auswahl";
          //
          break;    
      }
      console.debug("End NewTenantCtrl.initSelectMenu");
                  
      return true;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".initSelectMenu() failed: " + e.toString(), e, -1);
      return false;
    }     
  },  
  setByQuickSetup: function(target, doRequire, doClear) {
    var local = this.localScope;
    var ret = false;    
    var no_reg_expr = local.getDictionaryItem("REG_EXPR_NO_EXPR"); 
    try {
      switch (target) {
        case "Tenant":  
          local.edtTenantCaption.quickSetup(doRequire, no_reg_expr, doClear);
          //
          ret = true;          
          break;
        case "Related":
          //
          ret = true;
          break;
        case "Properties":
          local.edtSessionIdleTime.quickSetup(doRequire, no_reg_expr, doClear);
          local.edtSessionLifetime.quickSetup(doRequire, no_reg_expr, doClear);
          //
          ret = true;
          break;          
        default:
          throw "NewTenantCtrl.setQuickSetup: keine gültige Auswahl";
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
  loadLookupData: function(target) {
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
  clearData: function(target) {
    var global = this.globalScope;
    var local = this.localScope;    
  
    var ret = false;
    try {
      switch (target) {
        case "Tenant":
          local.layTenant.clearData();                   
          //          
          ret = true;          
          break;
        case "Related":
          local.layRelated.clearData();
          //
          ret = true;
          break;
        case "Properties":
          local.laySession.clearData();
          //
          ret = true;
          break;          
        case "SummeryInfo":
          local.laySummery.clearData();
          this.setSummeryInfo();
          //
          ret = true;
          break;
        default:
          throw "NewTenantCtrl.clearData: keine gültige Auswahl";
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
  clearWizard: function(layIdx) {
    try {
      if (!this.setByQuickSetup("Tenant", true, true)) {
        throw "Fehler beim Einrichten der Mandantenbezeichnung!";
      }
      
      if (!this.setByQuickSetup("Properties", true, true)) {
        throw "Fehler beim Einrichten der Mandanteneigenschaften!";
      }
            
      if (!this.clearData("Tenant")) {
        throw "Fehler beim Zurücksetzen der Mandantenbezeichnung!";
      }
      
      if (!this.clearData("Related")) {
        throw "Fehler beim Zurücksetzen von von Verkn&uuml;pfungen!";
      }
      
      if (!this.clearData("Properties")) {
        throw "Fehler beim Zurücksetzen von Mandanteneigenschaften!";
      }
      
      if (!this.clearData("SummeryInfo")) {
        throw "Fehler beim Zurücksetzen der Zusammenfassung!";
      }
      
      this.selectLayerByIdx(layIdx);

      if (!this.initSelectMenu()) {
        global.toastWarning(this.getDictionaryItem("ERROR_MSG_BY_INIT_SELECTMENU"));
      }
      
      return true;
    } catch (e) {    
      this.handleExceptionByCtrl(this.localScope.name + ".clearWizard() failed: " + e.toString(), e, -1);      
      return false;
    }
  },
  checkData: function(target) {
    var global = this.globalScope;
    var local = this.localScope;  
    var checked = false;
    try {
      switch (target) {
        case "Tenant":
          var mandant = global.utils.setDefaultStr(local.edtTenantCaption.getDataValue());
         
          checked = (mandant.trim() !== "");
          //          
          break;
        case "Related":
          checked = true;
          //         
          break;          
        case "Properties":
          var idletime = local.edtSessionIdleTime.getDataValue(); 
          var lifetime =  local.edtSessionLifetime.getDataValue(); 
          
          checked = ((idletime) && (lifetime));
          if (checked) {
            checked = ((idletime > 0) && (lifetime > 0));
          }  
          //         
          break;
        case "Summary":
          checked = true;
          //
          break;  
        default:
          throw "NewTenantCtrl.checkData: keine gültige Auswahl";
          //
          checked = flase;
          //          
          break;
      }
      return checked;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".checkData() failed: " + e.toString(), e, -1);      
      return false;
    }
  },  
  onWizNewTenantCanChange: function(inSender, inChangeInfo) {
    var global = this.globalScope;
    var local = this.localScope;  
    var doChange = false;
    var errorMsg = "";
    var previousIndex = inSender.layerIndex - 1; 
    try {
      switch (inSender.layerIndex) {
        case 0:
          doChange = this.checkData("Tenant");
          if (!doChange) {
            errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_TENANT_DATA");
          }
          //
          break;
        case 1:
          if (inChangeInfo.newIndex == previousIndex) {
            doChange = true;
          } else {
            doChange = this.checkData("Related");
            if (!doChange) {
              errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_RELATED_DATA");
            }
          }
          //
          break;
        case 2:
          if (inChangeInfo.newIndex == previousIndex) {
            doChange = true;
          } else {      
            doChange = this.checkData("Properties");
            if (!doChange) {
              errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_PROPERTIES_DATA");
            }
          }  
          //
          break;
        case 3:
          if (inChangeInfo.newIndex == previousIndex) {
            doChange = true;
          } else {      
            doChange = this.checkData("Summary");
            if (!doChange) {
              errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_SUMMARY_DATA");
            }
          }  
          //
          break;  
        default:
          doChange = flase;
          //          
          break;              
      }
      //
      inChangeInfo.canChange = doChange;
      if (!inChangeInfo.canChange) {
        if (errorMsg.trim() !== "") {
          global.toastWarning(errorMsg);
        }
      }
      return inChangeInfo.canChange; 
    } catch (e) {
      inChangeInfo.canChange = false;
      this.handleExceptionByCtrl(this.localScope.name + ".wizNewTenantCanchange() failed: " + e.toString(), e);      
      return inChangeInfo.canChange;
    } 
  },  
  setSummery: function (target) {
    var global = this.globalScope;
    var local = this.localScope;
    var ret = false;
    var no_info = local.getDictionaryItem("CAPTION_NO_INFO"); 
    try {
      switch (target) {
      case "Tenant":
        var tenant_caption = local.getDictionaryItem("CAPTION_TENANTNAME") + ": " + global.utils.setDefaultStr(local.edtTenantCaption.getDisplayValue(), no_info);
        var tenant_desc = local.getDictionaryItem("CAPTION_TENANTDESC") + ": " + global.utils.setDefaultStr(local.edtTenantDesc.getDisplayValue(), no_info);
        //
        local.lblSumInfoMandant.setCaption(tenant_caption);
        local.lblSumInfoDesc.setCaption(tenant_desc);
        //
        ret = true;  
        break;  	
      case "Related":
        var factory_data = local.getDictionaryItem("CAPTION_FACTORY_DATA") + ": " + global.utils.setDefaultStr(local.cboFactoryDatasheet.getDisplayValue(), no_info);
        var person_data = local.getDictionaryItem("CAPTION_PERSON_DATA") + ": " + global.utils.setDefaultStr(local.cboPersonDatasheet.getDisplayValue(), no_info);
        var contact_data = local.getDictionaryItem("CAPTION_CONTACT_DATA") + ": " + global.utils.setDefaultStr(local.cboContactDatasheet.getDisplayValue(), no_info);
        var address_data = local.getDictionaryItem("CAPTION_ADDRESS_DATA") + ": " + global.utils.setDefaultStr(local.cboAddressDatasheet.getDisplayValue(), no_info); 
        //
        local.lblSumInfoFactoryDatasheet.setCaption(factory_data);
        local.lblSumInfoPersonDatasheet.setCaption(person_data);
        local.lblSumInfoContactDatasheet.setCaption(contact_data);
        local.lblSumInfoAddressDatasheet.setCaption(address_data);                
        //
        ret = true;  
        break;
      case "Properties":
        var country_code = local.getDictionaryItem("CAPTION_COUNTRY_CODE") + ": " + global.utils.setDefaultStr(local.cboAreaCode.getDisplayValue(), no_info);
        var idletime = local.getDictionaryItem("CAPTION_SESSION_IDLETIME") + ": " + global.utils.setDefaultStr(local.edtSessionIdleTime.getDisplayValue(), no_info);
        var lifetime = local.getDictionaryItem("CAPTION_SESSION_LIFETIME") + ": " + global.utils.setDefaultStr(local.edtSessionLifetime.getDisplayValue(), no_info);
        //
        local.lblSumInfoAreaCode.setCaption(country_code);
        local.lblSumInfoIdleTime.setCaption(idletime);
        local.lblSumInfoLifetime.setCaption(lifetime);
        //
        ret = true;  
        break;
      default:
        throw "NewTenantCtrl.setSummery: keine gültige Auswahl";
        //
        ret = flase;          
        break;       	
      }
      return ret;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".checkData() failed: " + e.toString(), e, -1);      
      return false;	
    }
  },
  setSummeryInfo: function() {
    this.setSummery("Tenant");
    this.setSummery("Related");
    this.setSummery("Properties");
  },
  getActiveLayer: function() {
    var local = this.localScope;
    
    return local.wizNewTenant.getActiveLayer();
  },  
  selectLayerByIdx: function(idx) {
    var local = this.localScope;
    if ((!(idx) && (idx === 0)) || (idx)) {      
      var  currentLayer = this.getActiveLayer();
      if (currentLayer.getIndex() !== idx) {
        switch (idx) {
          case 0:
            local.navCallTenant.update();
            //
            break;
          case 1:
            local.navCallRelated.update();
            //
            break;
          case 2:
            local.navCallProperties.update();
            //
            break;  
          case 3:
            local.navCallSummery.update();
            //
            break;
          default:
            local.navCallTenant.update();
            //          
            break;
        }           
      }
    }    
  },
  handleSubscribeByResData: function(subscription) {
    this.inherited (arguments);
  },
  subscribeForChannels: function() {
    var global = this.globalScope;
    var local = this.localScope;
    
    console.debug('Start Controller.subscribeForChannels.SubClass');
    
    dojo.subscribe('init-user-as-subdialog', this, "initAsSubDialog");
    
    this.handleSubscribeByResData("ADD_TENANT_SUCCEEDED");
    this.handleSubscribeByResData("INSERT_BY_TENANT_FAILD_BY_NEWTENANT");
    this.handleSubscribeByResData("DUPLICATE_TENANT_NOT_ALLOWED_BY_NEWTENANT");
    this.handleSubscribeByResData("INSERT_BY_TENANT_FAILD_BY_NEWTENANT");
    this.handleSubscribeByResData("NO_GRANT_FOR_ADD_TENANT");
    this.handleSubscribeByResData("NO_MANDATORY_TENANT_BY_NEWTENANT");
    this.handleSubscribeByResData("NO_VALID_COUNTRY_ID_BY_NEWTENANT");    
    this.handleSubscribeByResData("FAILD_BY_OBSCURE_PROCESSING");
    
    console.debug('End Controller.subscribeForChannels.SubClass');    
  },
  infoByUnhandledCode: function(success) {
    var global = this.globalScope;
    var local = this.localScope;
    
    if (success) {
        global.toastSuccess(local.getDictionaryItem("ADD_TENANT_SUCCEEDED"));
    } else {
        global.toastWarning(local.getDictionaryItem("WARNING_BY_OBSCURE_PROCESSING"));
    }  
  },
  handleExceptionByCtrl: function(msg, e, code) {
    this.inherited (arguments);    
  },
  showSearch: function(sender, searchParameter, titel) {
    this.inherited (arguments);
  }       
});