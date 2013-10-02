dojo.provide("wm.packages.zabonline.mod.NewUserCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("NewUserCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewUserCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewUserCtrl.constructor');
  },
  initControls: function(global, local) {
    local.edtPassword.setValue("helpText", local.getDictionaryItem("HELP_PASSWORD_INFO"));
    local.edtRepeatPass.setValue("placeHolder", local.getDictionaryItem("REPEAT_PASSWORD_PLACEHOLDER"));
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;
    
    this.initControls(global, local);
  
   //local.connect(global.salutationLookupData, "onSuccess", this, "onInitSalutation");
  },
  initSelectMenu: function(target, idx) {  
    var global = this.globalScope;
    var local = this.localScope;
    var doBreak = true;    
    try {
      console.debug("Start NewUserCtrl.initSelectMenu");
      
      if (!target) {
        target = "Role";
        doBreak = false; 
      }
      
      if (!idx) {
        idx = 0;
      }
      
      switch (target) {
        case "Role":
          //
          if (doBreak) {            
            break;
          }
        case "Tenant":
          //           
          break;
        default:
          throw "NewUserCtrl.initSelectMenu: keine gültige Auswahl";
          //
          break;    
      }
      console.debug("End NewUserCtrl.initSelectMenu");
                  
      return true;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".initSelectMenu() failed: " + e.toString(), e, -1);
      return false;
    }     
  },
  initAsSubDialog: function(onStart) {
    var local = this.localScope;
    if (onStart) {
      local.btnFindRole.setShowing(false);
      local.btnAddRole.setShowing(false);
      local.btnFindTenant.setShowing(false);
      local.btnAddTenant.setShowing(false);
      local.btnFindPerson.setShowing(false);
      local.btnAddPerson.setShowing(false);
    } else {
      local.btnFindRole.setShowing(true);
      local.btnAddRole.setShowing(true);
      local.btnFindTenant.setShowing(true);
      local.btnAddTenant.setShowing(true);
      local.btnFindPerson.setShowing(true);
      local.btnAddPerson.setShowing(true);    
    }
  },  
  setByQuickSetup: function(target, doRequire, doClear) {
    var local = this.localScope;
    var ret = false;    
    try {
      switch (target) {
        case "User":  
          local.edtUser.quickSetup(true, local.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);       
          local.edtPassword.quickSetup(true, local.getDictionaryItem("REG_EXPR_PASSWORD"), doClear);
          local.edtRepeatPass.quickSetup(false, local.getDictionaryItem("REG_EXPR_PASSWORD"), doClear, true);
          local.edtFirstname.quickSetup(true, local.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
          local.edtName.quickSetup(true, local.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
          local.edtEmail.quickSetup(true, local.getDictionaryItem("REG_EXPR_EMAIL"), doClear);
          //
          ret = true;          
          break;
        case "Related":
          //
          ret = true;
          break;
        case "Admin":
          //
          ret = true;          
          break;
        default:
          throw "NewUserCtrl.setQuickSetup: keine gültige Auswahl";
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
  loadPersonLookupData: function() {
    var local = this.localScope;
    var success = 0;
    try {
      if (local.personLookupVar.canUpdate()) {
          local.personLookupVar.update();
          success = 1;
      } else {
        success = 0;
      }             
            
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".loadPersonLookupData() failed: " + e.toString(), e, -1);      
      return false;      
    }  
  },
  loadTenantLookupData: function() {
    var local = this.localScope;
    var success = 0;
    try {
      if (local.tenantLookupVar.canUpdate()) {
          local.tenantLookupVar.update();
          success = 1;
      } else {
        success = 0;
      }
      
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".loadTenantLookupData() failed: " + e.toString(), e, -1);      
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
      success = this.loadTenantLookupData();
      /*
      if (local.tenantLookupVar.canUpdate()) {
          local.tenantLookupVar.update();
          success = 1;
      } else {
        success = 0;
      } 
      */            
      
      success = this.loadRoleLookupData();
      /*
      if (local.roleLookupVar.canUpdate()) {
          local.roleLookupVar.update();
          success = 1;
      } else {
        success = 0;
      } 
      */            

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
        case "User":
          local.layUser.clearData();                   
          //          
          ret = true;          
          break;
        case "Related":
          local.layRelated.clearData();
          //
          ret = true;
          break;
        case "Admin":
          local.layAdmin.clearData();
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
          throw "NewUserCtrl.clearData: keine gültige Auswahl";
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
      if (!this.setByQuickSetup("User", false, true)) {
        throw "Fehler beim Einrichten vom Anmeldedaten!";
      }
      if (!this.setByQuickSetup("Related", false, true)) {
        throw "Fehler beim Einrichten von Verkn&uuml;pfungen!";
      }      
      if (!this.setByQuickSetup("Admin", false, true)) {
        throw "Fehler beim Einrichten von Administrationsinformationen!";
      }        
      //
      if (!this.clearData("User")) {
        throw "Fehler beim Zurücksetzen von Anmeldedaten!";
      }
      if (!this.clearData("Related")) {
        throw "Fehler beim Zurücksetzen von Verkn&uuml;pfungen!";
      }
      if (!this.clearData("Admin")) {
        throw "Fehler beim Zurücksetzen von Administrationsinformationen!";
      }
      if (!this.clearData("SummeryInfo")) {
        throw "Fehler beim Zurücksetzen der Zusammenfassung!";
      }
      //
      this.selectLayerByIdx(layIdx);
      //
      if (!this.initSelectMenu()) {
        global.toastWarning(this.getDictionaryItem("ERROR_MSG_BY_INIT_SELECTMENU"));
      }
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
        case "User":
          var username = global.utils.setDefaultStr(local.edtUser.getDataValue());
          var fristname = global.utils.setDefaultStr(local.edtFirstname.getDataValue());
          var name = global.utils.setDefaultStr(local.edtName.getDataValue());
          var email = global.utils.setDefaultStr(local.edtEmail.getDataValue());
          var password = global.utils.setDefaultStr(local.edtPassword.getDataValue());
          var repeatPassword = global.utils.setDefaultStr(local.edtRepeatPass.getDataValue());
          
          checked = (repeatPassword == password);
          if (checked) {
            checked = ((username.trim() !== "") && (fristname.trim() !== "") && (name.trim() !== "") && (email.trim() !== "") && (password.trim() !== ""));
          }  
          //          
          break;
        case "Related":
          var role = global.utils.setDefaultStr(local.edtRole.getDisplayValue());
          var tenant = global.utils.setDefaultStr(local.edtTenant.getDisplayValue());
           
          checked = ((role.trim() !== "") && (tenant.trim() !== ""));
          //          
          break;
        case "Admin":
          checked = true;
          //          
          break;
        case "Summary":
          checked = true;
          break;  
        default:
          throw "NewUserCtrl.checkData: keine gültige Auswahl";
          //
          checked = flase;          
          break;
      }
      return checked;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".checkData() failed: " + e.toString(), e, -1);      
      return false;
    }
  },  
  onWizNewUserCanChange: function(inSender, inChangeInfo) {
    var global = this.globalScope;
    var local = this.localScope;  
    var doChange = false;
    var errorMsg = "";
    var previousIndex = inSender.layerIndex - 1; 
    try {
      switch (inSender.layerIndex) {
      case 0:
        doChange = this.checkData("User");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_USER_DATA");
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
          doChange = this.checkData("Admin");
          if (!doChange) {
            errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_ADMIN_DATA");
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
      case "User":
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
      case "Related":
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
      case "Admin":
        var allow_login = local.getDictionaryItem("CAPTION_ALLOW_LOGIN") + ": " + global.utils.setDefaultStr(local.cbxAllowLogin.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO")); 
        //
        local.lblSumInfoAllowLogin.setCaption(allow_login);      
        //
        ret = true;  
        break;  
      default:
        throw "NewUserCtrl.setSummery: keine gültige Auswahl";
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
            local.navCallUser.update();
            //
            break;
          case 1:
            local.navCallRelated.update();
            //
            break;
          case 2:
            local.navCallAdmin.update();
            //
            break;
          case 3:
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

