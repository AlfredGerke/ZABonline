dojo.provide("wm.packages.zabonline.mod.NewRoleCtrl");

wm.require("zabonline.mod.Controller", true);

dojo.declare("NewRoleCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewRoleCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewRoleCtrl.constructor');
  },
  initControls: function(global, local) {
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;
    
    this.initControls(global, local); 
  },
  initAsSubDialog: function(onStart) {
    var local = this.localScope;
    if (onStart) {
    } else {
    }
  },  
  setByQuickSetup: function(target, doRequire, doClear) {
    var local = this.localScope;
    var ret = false;    
    try {
      switch (target) {
        case "Role":  
          //
          ret = true;          
          break;
        case "Properties":
          //
          ret = true;
          break;
        default:
          throw "NewRoleCtrl.setQuickSetup: keine gültige Auswahl";
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
  loadRoleLookupData: function() {
    var local = this.localScope;
    var success = 0;
    try {
      if (local.roleLookupVar.canUpdate()) {
          local.roleLookupVar.update();
          success = 1;
      } else {
        success = 0;
      }             
            
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".loadRoleLookupData() failed: " + e.toString(), e, -1);      
      return false;      
    }  
  },    
  loadLookupData: function(target) {
    var success = 0;
    var local = this.localScope;
    try { 
      
      success = this.loadRoleLookupData();

      if (success == 1) {                              
        this.globalScope.globalData.tenantId(this.localScope.varTenantId);
      }
      
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".loadLookupData() failed: " + e.toString(), e, -1);      
      return false;      
    }
  },  
  clearData: function(target) {
    var global = this.globalScope;
    var local = this.localScope;    
  
    var ret = false;
    try {
      switch (target) {
        case "Role":
          local.layRole.clearData();                   
          //          
          ret = true;          
          break;
        case "Properties":
          local.layProperties.clearData();
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
          throw "NewRoleCtrl.clearData: keine gültige Auswahl";
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
      if (!this.setByQuickSetup("Role", false, true)) {
        throw "Fehler beim Einrichten vom Anmeldedaten!";
      }
      if (!this.setByQuickSetup("Properties", false, true)) {
        throw "Fehler beim Einrichten von Verkn&uuml;pfungen!";
      }      
      //
      if (!this.clearData("Role")) {
        throw "Fehler beim Zurücksetzen von Anmeldedaten!";
      }
      if (!this.clearData("Properties")) {
        throw "Fehler beim Zurücksetzen von Verkn&uuml;pfungen!";
      }
      if (!this.clearData("SummeryInfo")) {
        throw "Fehler beim Zurücksetzen der Zusammenfassung!";
      }
      //
      this.selectLayerByIdx(layIdx);
      //
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
        case "Role":
          var rolename = global.utils.setDefaultStr(local.edtRoleCaption.getDataValue());
         
          checked = (rolename.trim() !== "");
          //          
          break;
        case "Properites":
          checked = true;
          //         
          break;
        case "Summary":
          checked = true;
          //
          break;  
        default:
          throw "NewRoleCtrl.checkData: keine gültige Auswahl";
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
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_USER_DATA");
        }
        //
        break;
      case 1:
        if (inChangeInfo.newIndex == previousIndex) {
          doChange = true;
        } else {
          doChange = this.checkData("Properties");
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
      this.handleExceptionByCtrl(this.localScope.name + ".wizNewUserCanchange() failed: " + e.toString(), e);      
      return inChangeInfo.canChange;
    } 
  },  
  setSummery: function (target) {
    var global = this.globalScope;
    var local = this.localScope;
    var ret = false;
    try {
      switch (target) {
      case "Role":
        var user = local.getDictionaryItem("CAPTION_USERNAME") + ": " + global.utils.setDefaultStr(local.edtUser.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var firstname = local.getDictionaryItem("CAPTION_FIRSTNAME") + ": " + global.utils.setDefaultStr(local.edtFirstname.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var name = local.getDictionaryItem("CAPTION_NAME") + ": " + global.utils.setDefaultStr(local.edtName.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var email = local.getDictionaryItem("CAPTION_EMAIL") + ": " + global.utils.setDefaultStr(local.edtEmail.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        //
        local.lblSumInfoUser.setCaption(user);
        local.lblSumInfoFirstname.setCaption(firstname);
        local.lblSumInfoName.setCaption(name);
        local.lblSumInfoEmail.setCaption(email);
        //
        ret = true;  
        break;  	
      case "Properties":
        var role = local.getDictionaryItem("CAPTION_ROLE") + ": " + global.utils.setDefaultStr(local.edtRole.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var tenant = local.getDictionaryItem("CAPTION_TENANT") + ": " + global.utils.setDefaultStr(local.edtTenant.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var person = local.getDictionaryItem("CAPTION_PERSON") + ": " + global.utils.setDefaultStr(local.edtPerson.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        //
        local.lblSumInfoRole.setCaption(role);
        local.lblSumInfoTenant.setCaption(tenant);
        local.lblSumInfoPerson.setCaption(person);
        //
        ret = true;  
        break;
      default:
        throw "NewRoleCtrl.setSummery: keine gültige Auswahl";
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
    this.setSummery("User");
    this.setSummery("Related");
    this.setSummery("Admin");
  },
  getActiveLayer: function() {
    var local = this.localScope;
    
    return  local.wizNewUser.getActiveLayer();
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
            local.navCallUser.update();
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
    
    this.handleSubscribeByResData("ADD_USER_SUCCEEDED");
    this.handleSubscribeByResData("NO_MANDATORY_ROLE_ID_BY_NEWUSER");
    this.handleSubscribeByResData("NO_VALID_ROLE_ID_BY_NEWUSER");   
    this.handleSubscribeByResData("NO_MANDATORY_MANDANT_ID_BY_NEWUSER");
    this.handleSubscribeByResData("NO_VALID_MANDANT_ID_BY_NEWUSER");
    this.handleSubscribeByResData("NO_VALID_PERSON_ID_BY_NEWUSER");
    this.handleSubscribeByResData("NO_MANDATORY_USERNAME_BY_NEWUSER");
    this.handleSubscribeByResData("NO_MANDATORY_PASSWORD_BY_NEWUSER");
    this.handleSubscribeByResData("NO_MANDATORY_FIRSTNAME_BY_NEWUSER");
    this.handleSubscribeByResData("NO_MANDATORY_NAME_BY_NEWUSER");
    this.handleSubscribeByResData("NO_MANDATORY_EMAIL_BY_NEWUSER");
    this.handleSubscribeByResData("NO_VALID_ALLOW_LOGIN_BY_NEWUSER");
    this.handleSubscribeByResData("DUPLICATE_USERNAME_NOT_ALLOWED_BY_NEWUSER");
    this.handleSubscribeByResData("INSERT_BY_USER_FAILD_BY_NEWUSER");
    
    this.handleSubscribeByResData("FAILD_BY_OBSCURE_PROCESSING");
    
    console.debug('End Controller.subscribeForChannels.SubClass');    
  },
  infoByUnhandledCode: function(success) {
    var global = this.globalScope;
    var local = this.localScope;
    
    if (success) {
        global.toastSuccess(local.getDictionaryItem("ADD_USER_SUCCEEDED"));
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