dojo.provide("wm.packages.zabonline.mod.NewTenantCtrl");

wm.require("zabonline.mod.Controller", true);

dojo.declare("NewTenantCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewTenantCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewTenantCtrl.constructor');
  },
  initControls: function(global, local) {
    local.edtSessionIdleTime.setValue("helpText", local.getDictionaryItem("HELP_SESSIONIDLETIME_INFO"));
    local.edtSessionLifetime.setValue("helpText", local.getDictionaryItem("HELP_SESSIONLIFETIME_INFO"));
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;
    
    this.initControls(global, local); 
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
  setByQuickSetup: function(target, doRequire, doClear) {
    var local = this.localScope;
    var ret = false;    
    try {
      switch (target) {
        case "Tenant":  
          local.edtTenantCaption.quickSetup(doRequire, local.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
          //
          ret = true;          
          break;
        case "Related":
          //
          ret = true;
          break;
        case "Properties":
          local.edtSessionIdleTime.quickSetup(doRequire, local.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
          local.edtSessionLifetime.quickSetup(doRequire, local.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
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
      global.globalData.tenantId(local.varTenantId);
    
      success = 1;
      
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
          var rolename = global.utils.setDefaultStr(local.edtRoleCaption.getDataValue());
         
          checked = (rolename.trim() !== "");
          //          
          break;
        case "Related":
          checked = true;
          //         
          break;          
        case "Properties":
          var idletiem = local.edtSessionIdleTime.getDataValue(); 
          var lifetime =  local.edtSessionLifetime.getDataValue(); 
          
          checked = ((idletime) and (lifetime));
          if checked then
            checked = ((idletime > 0) and (lifetime > 0));
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
  onWizNewRoleCanChange: function(inSender, inChangeInfo) {
    var global = this.globalScope;
    var local = this.localScope;  
    var doChange = false;
    var errorMsg = "";
    var previousIndex = inSender.layerIndex - 1; 
    try {
      switch (inSender.layerIndex) {
      case 0:
        doChange = this.checkData("Role");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_ROLE_DATA");
        }
        //
        break;
      case 1:
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
      case 2:
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
      this.handleExceptionByCtrl(this.localScope.name + ".wizNewRoleCanchange() failed: " + e.toString(), e);      
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
      case "Role":
        var rolecaption = local.getDictionaryItem("CAPTION_ROLENAME") + ": " + global.utils.setDefaultStr(local.edtRoleCaption.getDisplayValue(), no_info);
        var roledesc = local.getDictionaryItem("CAPTION_ROLEDESC") + ": " + global.utils.setDefaultStr(local.edtRoleDesc.getDisplayValue(), no_info);
        //
        local.lblSumInfoCaption.setCaption(rolecaption);
        local.lblSumInfoDesc.setCaption(roledesc);
        //
        ret = true;  
        break;  	
      case "Properties":
        var is_admin = local.getDictionaryItem("CAPTION_IS_ADMIN") + ": " + global.utils.setDefaultStr(local.cbxIsAdmin.getDisplayValue(), no_info);
        var member = local.getDictionaryItem("CAPTION_MEMBER") + ": " + global.utils.setDefaultStr(local.cbxMembers.getDisplayValue(), no_info);
        var activity_recording = local.getDictionaryItem("CAPTION_ACTIVITY_RECORDING") + ": " + global.utils.setDefaultStr(local.cbxActivityRecording.getDisplayValue(), no_info);
        var sepa = local.getDictionaryItem("CAPTION_SEPA") + ": " + global.utils.setDefaultStr(local.cbxSEPA.getDisplayValue(), no_info);
        var billing = local.getDictionaryItem("CAPTION_BILLING") + ": " + global.utils.setDefaultStr(local.cbxBilling.getDisplayValue(), no_info);
        var import_data = local.getDictionaryItem("CAPTION_IMPORT") + ": " + global.utils.setDefaultStr(local.cbxImport.getDisplayValue(), no_info);
        var export_data = local.getDictionaryItem("CAPTION_EXPORT") + ": " + global.utils.setDefaultStr(local.cbxExport.getDisplayValue(), no_info);
        var reference_data = local.getDictionaryItem("CAPTION_REFERNCE_DATA") + ": " + global.utils.setDefaultStr(local.cbxReferenceData.getDisplayValue(), no_info);
        var reports = local.getDictionaryItem("CAPTION_REPORTS") + ": " + global.utils.setDefaultStr(local.cbxReporting.getDisplayValue(), no_info);
        var misc = local.getDictionaryItem("CAPTION_MISC") + ": " + global.utils.setDefaultStr(local.cbxMisc.getDisplayValue(), no_info);
        var file_resources = local.getDictionaryItem("CAPTION_FILE_RESOURCES") + ": " + global.utils.setDefaultStr(local.cbxFileressource.getDisplayValue(), no_info);
        var setup = local.getDictionaryItem("CAPTION_SETUP") + ": " + global.utils.setDefaultStr(local.cbxSetup.getDisplayValue(), no_info);
        //
        local.lblSumInfoIsAdmin.setCaption(is_admin);
        local.lblSumInfoMember.setCaption(member);
        local.lblSumInfoActivityRecording.setCaption(activity_recording);
        local.lblSumInfoSEPA.setCaption(sepa);
        local.lblSumInfoBilling.setCaption(billing);
        local.lblSumInfoImport.setCaption(import_data);
        local.lblSumInfoExport.setCaption(export_data);
        local.lblSumInfoReferenceData.setCaption(reference_data);
        local.lblSumInfoReports.setCaption(reports);
        local.lblSumInfoMisc.setCaption(misc);
        local.lblSumInfoFileresources.setCaption(file_resources);
        local.lblSumInfoSetup.setCaption(setup);
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
    this.setSummery("Role");
    this.setSummery("Properties");
  },
  getActiveLayer: function() {
    var local = this.localScope;
    
    return  local.wizNewRole.getActiveLayer();
  },  
  selectLayerByIdx: function(idx) {
    var local = this.localScope;
    if ((!(idx) && (idx === 0)) || (idx)) {      
      var  currentLayer = this.getActiveLayer();
      if (currentLayer.getIndex() !== idx) {
        switch (idx) {
          case 0:
            local.navCallRole.update();
            //
            break;
          case 1:
            local.navCallProperties.update();
            //
            break;
          case 2:
            local.navCallSummery.update();
            //
            break;
          default:
            local.navCallRole.update();
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
    this.handleSubscribeByResData("NO_MANDATORY_TENANT_CAPTION_BY_NEWTENANT");
    this.handleSubscribeByResData("DUPLICATE_TENANTCAPTION_NOT_ALLOWED_BY_NEWTENANT");
    this.handleSubscribeByResData("INSERT_BY_TENANT_FAILD_BY_NEWTENANT");
    
    this.handleSubscribeByResData("FAILD_BY_OBSCURE_PROCESSING");
    
    console.debug('End Controller.subscribeForChannels.SubClass');    
  },
  infoByUnhandledCode: function(success) {
    var global = this.globalScope;
    var local = this.localScope;
    
    if (success) {
        global.toastSuccess(local.getDictionaryItem("ADD_ROLE_SUCCEEDED"));
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