dojo.provide("wm.packages.zabonline.mod.NewAddressCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("NewAddressCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewAddressCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewAddressCtrl.constructor');
  },  
  onInitSalutation: function() {
    this.initSelectMenu("Salutation");
  },
  onInitTitel: function() {
    this.initSelectMenu("Titel");
  },
  onInitAddressType: function() {
    this.initSelectMenu("AddressType");
  },
  onInitContactType: function() {
    this.initSelectMenu("ContactType");
  },
  initAsSubDialog: function(onStart) {
    var local = this.localScope;
    if (onStart) {
      local.btnFindSalutation.setShowing(false);
      local.btnAddSalutation.setShowing(false);
      local.btnFindTitel.setShowing(false);
      local.btnAddTitel.setShowing(false);
      local.btnFindPerson.setShowing(false);
      local.btnAddPerson.setShowing(false);
      local.btnFindAddressType.setShowing(false);
      local.btnAddAddressType.setShowing(false);
      local.btnFindContactType.setShowing(false);
      local.btnAddContactType.setShowing(false);
      local.btnFindAreaCode.setShowing(false);
      local.btnAddAreaCode.setShowing(false);
    } else {
      local.btnFindSalutation.setShowing(true);
      local.btnAddSalutation.setShowing(true);
      local.btnFindTitel.setShowing(true);
      local.btnAddTitel.setShowing(true);
      local.btnFindPerson.setShowing(true);
      local.btnAddPerson.setShowing(true);
      local.btnFindAddressType.setShowing(true);
      local.btnAddAddressType.setShowing(true);
      local.btnFindContactType.setShowing(true);
      local.btnAddContactType.setShowing(true);
      local.btnFindAreaCode.setShowing(true);
      local.btnAddAreaCode.setShowing(true);      
    }
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope;
  
    local.connect(global.salutationLookupData, "onSuccess", this, "onInitSalutation");
    local.connect(global.titelLookupData, "onSuccess", this, "onInitTitel");
    local.connect(global.addressTypeLookupData, "onSuccess", this, "onInitAddressType");
    local.connect(global.contactTypeLookupData, "onSuccess", this, "onInitContactType");
  },
  initSelectMenu: function(target, idx) {  
    var global = this.globalScope;
    var local = this.localScope;
    var doBreak = true;    
    try {
      console.debug("Start NewAddressCtrl.initSelectMenu");
      
      if (!target) {
        target = "Salutation";
        doBreak = false; 
      }
      
      if (!idx) {
        idx = 0;
      }
      
      switch (target) {
        case "Salutation":
          var initSalutationValue = global.salutationLookup.getCaption(idx, "");
          local.cboSalutation.setDisplayValue(initSalutationValue);
          //
          if (doBreak) {            
            break;
          }
        case "Titel":
          var initTitelValue = global.titelLookup.getCaption(idx, "");
          local.cboTitel.setDisplayValue(initTitelValue);
          //
          if (doBreak) {            
            break;
          }
        case "AddressType":        
          var initAddressValue = global.addressTypeLookup.getCaption(idx, "");
          local.cboAddressType.setDisplayValue(initAddressValue);
          //
          if (doBreak) {            
            break;
          }
        case "ContactType":
          var initContactValue = global.contactTypeLookup.getCaption(idx, "");
           local.cboContactType.setDisplayValue(initContactValue);    
          //
          break;
        default:
          throw "NewAddressCtrl.initSelectMenu: keine gültige Auswahl";
          //
          break;    
      }
      console.debug("End NewAddressCtrl.initSelectMenu");
                  
      return true;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".initSelectMenu() failed: " + e.toString(), e, -1);
      return false;
    }     
  },
  setByQuickSetup: function(target, doRequire, doClear) {
    var ret = false;    
    try {
      switch (target) {
        case "Person":
          this.localScope.edtMarrigePartnerName.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
          //
          ret = true;          
          break;
        case "Address":
          this.localScope.edtZIPCode.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_ZIP_CODE"), doClear);
          this.localScope.edtCity.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
          this.localScope.edtStreet.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);
          this.localScope.edtStreetAddressFrom.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_STREET_ADDRESS"), doClear);
          //ist zu keiner Zeit ein Muss-Feld
          this.localScope.edtStreetAddressTo.quickSetup(false, this.localScope.getDictionaryItem("REG_EXPR_STREET_ADDRESS"), doClear, doRequire);
          //
          ret = true;
          break;
        case "BankInfo":
          this.localScope.edtDepositor.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_ALPHANUM"), doClear);
          this.localScope.edtKTO.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_KTO"), doClear);
          this.localScope.edtBLZ.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_BLZ"), doClear);
          //ist zu keiner Zeit ein Muss-Feld
          this.localScope.edtIBAN.quickSetup(false, this.localScope.getDictionaryItem("REG_EXPR_IBAN"), doClear, doRequire);
          //ist zu keiner Zeit ein Muss-Feld
          this.localScope.edtBIC.quickSetup(false, this.localScope.getDictionaryItem("REG_EXPR_BIC"), doClear, doRequire);
          //
          ret = true;          
          break;
        case "Contact":
          //ist zu keiner Zeit ein Muss-Feld
          this.localScope.edtTel.quickSetup(false, this.localScope.getDictionaryItem("REG_EXPR_TEL"), doClear, doRequire);
          //ist zu keiner Zeit ein Muss-Feld
          this.localScope.edtFax.quickSetup(false, this.localScope.getDictionaryItem("REG_EXPR_FAX"), doClear, doRequire);
          //ist zu keiner Zeit ein Muss-Feld
          this.localScope.edtWWW.quickSetup(false, this.localScope.getDictionaryItem("REG_EXPR_WWW"), doClear, doRequire);
          //ist zu keiner Zeit ein Muss-Feld
          this.localScope.edtEmail.quickSetup(false, this.localScope.getDictionaryItem("REG_EXPR_EMAIL"), doClear, doRequire);
          //
          ret = true;          
          break;
        default:
          throw "NewAddressCtrl.setQuickSetup: keine gültige Auswahl";
          //
          ret = flase;          
          break;
      }
      return ret;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".setByQuickSetup() failed: " + e.toString(), e, -1);
      return false;
    }
  },
  onRefreshLookup: function(lookup, force) {
    var local = this.localScope;
    var succes = 0;
    
    try {
      if (lookup) {
        if (lookup.refresh(force) > 0) {
          success = 1;
        } else {
          success = 0;
        }
      } else {
        success = 0;
      }
      
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(local.name + ".onRefreshLookup() failed: " + e.toString(), e, -1);      
      return false;      
    }
  },    
  onRefreshLookupByTarget: function(target, force) {
    var global = this.globalScope;
    var success = 0;
    
    switch (target) {
      case "SALUTATION":
        success =  this.onRefreshLookup(global.salutationLookup, force);
        //
        break;
      case "TITEL":
        success =  this.onRefreshLookup(this.globalScope.titelLookup, force);
        //
        break;  
      case "ADDRESS_TYPE":
        success =  this.onRefreshLookup(this.globalScope.addressTypeLookup, force);
        //
        break;        
      case "CONTACT_TYPE":
        success =  this.onRefreshLookup(this.globalScope.contactTypeLookup, force);
        //
        break;  
      default:
          success = 0;
          //
        break;
    }
    
    return success;
  },
  loadLookupData: function() {
    var success = 0;
    try {                                           
      if (this.globalScope.salutationLookup.refresh() > 0) {
        success = 1;
      } else {
        success = 0;
      }
      //
      if (success == 1) {
        if (this.globalScope.titelLookup.refresh() > 0) {
          success = 1;
        } else {
          success = 0;
        }
      }
      //
      if (success == 1) {
        if (this.globalScope.addressTypeLookup.refresh() > 0) {
          success = 1;
        } else {
          success = 0;
        }
      }
      //
      if (success == 1) {
        if (this.globalScope.contactTypeLookup.refresh() > 0) {
          success = 1;
        } else {
          success = 0;
        }
      }
      //
      if (success == 1) {
        if (this.globalScope.areaCodeLookup.refresh() > 0) {
          success = 1;
        } else {
          success = 0;
        }
      }
      //
      if (success == 1) {
        this.globalScope.globalData.tenantId(this.localScope.varTenantId);
      }
      return success;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".loadLookupData() failed: " + e.toString(), e, -1);      
      return false;      
    }
  },
  enableContainer: function(check, con, trgt) {
    var countArgs = arguments.length;
    con.setDisabled(check);
    if (countArgs == 3) {
      if (!check) {
        trgt.focus();
      }
    }
  },    
  clearData: function(target) {
    var global = this.globalScope;
    var local = this.localScope;    
    var initSalutationValue = global.salutationLookup.getCaption(1, "");
  
    var ret = false;
    try {
      switch (target) {
        case "Person":
          local.layPerson.clearData();          
          local.cbxIsMarried.setChecked(false);
          this.enableContainer(true, local.pnlMarriagePartnerData);          
          //          
          ret = true;          
          break;
        case "Address":
          local.layAddress.clearData();
          local.cbxNoAddressData.setChecked(true);
          this.enableContainer(local.cbxNoAddressData.getChecked(), local.pnlAddressLayout);
          //
          ret = true;
          break;
        case "BankInfo":
          local.layBank.clearData();
          local.cbxNoBankInfo.setChecked(true);
          this.enableContainer(local.cbxNoBankInfo.getChecked(), local.pnlBankLayout);
          //        
          ret = true;          
          break;
        case "Contact":
          local.layContact.clearData();
          local.cbxNoContactData.setChecked(true);
          this.enableContainer(local.cbxNoContactData.getChecked(), local.pnlContactLayout);
          //          
          ret = true;          
          break;
        case "Info": 
          local.layInfo.clearData();
          local.cbxNoInfo.setChecked(true);
          this.enableContainer(local.cbxNoInfo.getChecked(), local.pnlInfoLayout);
          //        
          ret = true;
          break;
        case "Photo":
          local.layPhoto.clearData();
          local.cbxNoPhoto.setChecked(true);
          this.enableContainer(local.cbxNoPhoto.getChecked(), local.pnlPhotoLayout);
          local.fileUpload.reset();
          local.fileUpload.setShowing(false);
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
          throw "NewAddressCtrl.clearData: keine gültige Auswahl";
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
      if (!this.setByQuickSetup("Person", this.localScope.cbxIsMarried.getChecked(), false)) {
        throw "Fehler beim Einrichten von Person!";
      }
      if (!this.setByQuickSetup("Address", !this.localScope.cbxNoAddressData.getChecked(), true)) {
        throw "Fehler beim Einrichten von Adresse!";
      }
      if (!this.setByQuickSetup("BankInfo", !this.localScope.cbxNoBankInfo.getChecked(), true)) {
        throw "Fehler beim Einrichten von Bankinformationen!";
      }
      if (!this.setByQuickSetup("Contact", !this.localScope.cbxNoAddressData.getChecked(), true)) {
        throw "Fehler beim Einrichten von Kontaktdaten!";
      }
      //
      if (!this.clearData("Person")) {
        throw "Fehler beim Zurücksetzen von Person!";
      }
      if (!this.clearData("Address")) {
        throw "Fehler beim Zurücksetzen von Adresse!";
      }
      if (!this.clearData("Contact")) {
        throw "Fehler beim Zurücksetzen von Kontaktinformationen!";
      }
      if (!this.clearData("BankInfo")) {
        throw "Fehler beim Zurücksetzen von Bankinformationen!";
      }
      if (!this.clearData("Info")) {
        throw "Fehler beim Zurücksetzen von Informationen!";
      }
      if (!this.clearData("Photo")) {
        throw "Fehler beim Zurücksetzen vom Foto!";
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
        case "Person":
          if (local.cbxIsMarried.getChecked()) {
              var partnerName = global.utils.setDefaultStr(local.edtMarrigePartnerName.getDataValue());
              checked = (partnerName.trim() !== "");
          } else {
              checked = true;
          }
          //          
          break;
        case "Address":
          if (local.cbxNoAddressData.getChecked()) {
              checked = true;
          } else {
              var zipCode = global.utils.setDefaultStr(local.edtZIPCode.getDataValue());
              var city = global.utils.setDefaultStr(local.edtCity.getDataValue());
              var street = global.utils.setDefaultStr(local.edtStreet.getDataValue());
              var streetAddressFrom = global.utils.setDefaultStr(local.edtStreetAddressFrom.getDataValue());
              //
              checked = ((zipCode.trim() !== "") && (city.trim() !== "") && (street.trim() !== "") && (streetAddressFrom.trim() !== ""));
          }
          //
          break;
        case "BankInfo":
          if (local.cbxNoBankInfo.getChecked()) {
              checked = true;
          } else {
              var depositor = global.utils.setDefaultStr(local.edtDepositor.getDataValue());
              var kto = global.utils.setDefaultStr(local.edtKTO.getDataValue());
              var blz = global.utils.setDefaultStr(local.edtBLZ.getDataValue());
              //
              checked = ((depositor.trim() !== "") && (kto.trim() !== "") && (blz.trim() !== ""));
          }
          //          
          break;
        case "Contact":
          if (local.cbxNoContactData.getChecked()) {
              checked = true;
          } else {
              var contactType = local.cboContactType.getDataValue();
              var tel = global.utils.setDefaultStr(local.edtTel.getDataValue());
              var fax = global.utils.setDefaultStr(local.edtFax.getDataValue());
              var www = global.utils.setDefaultStr(local.edtWWW.getDataValue());
              var email = global.utils.setDefaultStr(local.edtEmail.getDataValue());
              var skype = global.utils.setDefaultStr(local.edtSkype.getDataValue());
              var messanger = global.utils.setDefaultStr(local.edtMessanger.getDataValue());
              //
              checked = ((contactType !== null) && ((tel.trim() !== "") || (fax.trim() !== "") || (www.trim() !== "") || (email.trim() !== "") || (skype.trim() !== "") || (messanger.trim() !== "")));
          }
          //          
          break;
        case "Info": 
          if (local.cbxNoInfo.getChecked()) {
              checked = true;
          } else {
              var info = global.utils.setDefaultStr(local.edtDescription.getDataValue());
              //
              checked = (info.trim() !== "");
          }
          //                  
          break;
        case "Photo":
          if (local.cbxNoPhoto.getChecked()) {
              checked = true;
          } else {
              checked = true;
          }
          //
          break;    
        case "Summary":
          checked = true;
          break;  
        default:
          throw "NewAddressCtrl.checkData: keine gültige Auswahl";
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
  onWizNewAddressCanChange: function(inSender, inChangeInfo) {
    var global = this.globalScope;
    var local = this.localScope;  
    var doChange = false;
    var errorMsg = "";
    try {
      switch (inSender.layerIndex) {
      case 0:
        doChange = this.checkData("Person");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_PERSON_DATA");
        }
        //
        break;
      case 1:
        doChange = this.checkData("Address");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_ADDRESS_DATA");
        }
        //
        break;
      case 2:
        doChange = this.checkData("Contact");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_CONTACT_DATA");
        }
        //
        break;
      case 3:
        doChange = this.checkData("BankInfo");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_BANK_DATA");
        }
        //
        break;
      case 4:
        doChange = this.checkData("Info");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_INFORMATION");
        }
        //
        break;
      case 5:
        doChange = this.checkData("Photo");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_PHOTO");
        }
        //
        break;
      case 6:
        doChange = this.checkData("Summary");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_SUMMARY_DATA");
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
      this.handleExceptionByCtrl(this.localScope.name + ".wizNewAddressCanchange() failed: " + e.toString(), e);      
      return inChangeInfo.canChange;
    } 
  },
  setSummery: function(target) {
    var global = this.globalScope;
    var local = this.localScope;
    var ret = false;
    try {
      switch (target) {
      case "Person":
        var salutation = local.getDictionaryItem("CAPTION_SALUTATION") + ": " + global.utils.setDefaultStr(local.cboSalutation.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var altSalutation = local.getDictionaryItem("CAPTION_ALTSALUTATION") + ": " + global.utils.setDefaultStr(local.edtAltSalutation.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var titel = local.getDictionaryItem("CAPTION_TITEL") + ": " + global.utils.setDefaultStr(local.cboTitel.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var first_name = local.getDictionaryItem("CAPTION_FIRSTNAME") + ": " + global.utils.setDefaultStr(local.edtFirstName.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var name = local.getDictionaryItem("CAPTION_NAME") + ": " + global.utils.setDefaultStr(local.edtName1.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var name2 = local.getDictionaryItem("CAPTION_NAME2") + ": " + global.utils.setDefaultStr(local.edtName2.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var birthday = local.getDictionaryItem("CAPTION_BIRTHDAY_SHORT") + ": " + global.utils.setDefaultStr(local.edtBirthday.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var is_private = local.getDictionaryItem("CAPTION_PERSION_PRIVATE") + ": " + global.utils.setDefaultStr(local.cbxIsPrivate.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var is_married = local.getDictionaryItem("CAPTION_MARRIED") + ": " + global.utils.setDefaultStr(local.cbxIsMarried.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var married_since = local.getDictionaryItem("CAPTION_MARRIED_SINCE") + ": " + global.utils.setDefaultStr(local.edtMarriedSince.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var partner_firstname = local.getDictionaryItem("CAPTION_MARRIGE_PARTNER_FIRSTNAME") + ": " + global.utils.setDefaultStr(local.edtMarrigePartnerFirstName.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var partner_name = local.getDictionaryItem("CAPTION_MARRIGE_PARTNER_NAME") + ": " + global.utils.setDefaultStr(local.edtMarrigePartnerName.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));

        local.lblSumInfoSalutation.setCaption(salutation);
        local.lblSumInfoAltSalutation.setCaption(altSalutation);
        local.lblSumInfoTitel.setCaption(titel);
        local.lblSumInfoFirstName.setCaption(first_name);
        local.lblSumInfoName.setCaption(name);
        local.lblSumInfoName2.setCaption(name2);
        local.lblSumInfoBirthday.setCaption(birthday);
        local.lblSumInfoIsPrivat.setCaption(is_private);
        local.lblSumInfoIsMarried.setCaption(is_married);
        local.lblSumInfoMarriedSince.setCaption(married_since);
        local.lblSumInfoPartnerFirstName.setCaption(partner_firstname);
        local.lblSumInfoPartnerName.setCaption(partner_name);

        //!: folgende Kommentare kommen aus dem Quellcode von Wavemaker, es muss überprüft werden ob local (localScope) verwendet werden muss
        //        
        //Im folgenden werden Bindings für die Caption der lblSumInfo-Labels angegeben
        //Solange nicht geklärt ist wie man dieses Expressions lokalisieren kann werden direkt Bindings nicht für die Zusammenfassung verwendet
        //${cboSalutation.dataValue} ? "Anrede: " + ${cboSalutation.displayValue} : "Keine Angabe..."
        //${edtAltSalutation.dataValue} ? "Anrede: " + ${edtAltSalutation.displayValue} : "Keine Angabe..."
        //${cboTitel.dataValue} ? "Titel: " + ${cboTitel.displayValue} : "Keine Angabe..."
        //${edtFirstName.dataValue} ? "Vorname: " + ${edtFirstName.displayValue}  : "Keine Angabe..."
        //${edtName1.dataValue} ? "Name: " + ${edtName1.displayValue} : "Keine Angabe..."
        //${edtBirthday.dataValue} ? "Geb.: " + ${edtBirthday.displayValue} : "Keine Angabe..."
        //${cbxIsPrivate.dataValue} ? "Privat: " + ${cbxIsPrivate.displayValue} : "Keine Angabe..."
        //${cbxIsMarried.dataValue} ? "Verheiratet: " + ${cbxIsMarried.displayValue} : "Keine Angabe..."
        //${edtMarriedSince.dataValue} ? "Seit: " + ${edtMarriedSince.displayValue} : "Keine Angabe..."
        //${edtMarrigePartnerFirstName.dataValue} ? "Vorname: " + ${edtMarrigePartnerFirstName.displayValue} : "Keine Angabe..."
        //${edtMarrigePartnerName.dataValue} ? "Name: " + ${edtMarrigePartnerName.displayValue} : "Keine Angabe..."
        
        ret = true;  
        break;  	
      case "Address":
        var addressType = local.getDictionaryItem("CAPTION_ADDRESS_TYPE") + ": " + global.utils.setDefaultStr(local.cboAddressType.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var district = local.getDictionaryItem("CAPTION_DISTRICT") + ": " + global.utils.setDefaultStr(local.edtDistrict.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var zipCode = local.getDictionaryItem("CAPTION_ZIPCODE") + ": " + global.utils.setDefaultStr(local.edtZIPCode.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var city = local.getDictionaryItem("CAPTION_CITY") + ": " + global.utils.setDefaultStr(local.edtCity.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var postOffice = local.getDictionaryItem("CAPTION_POSTOFFICE") + ": " + global.utils.setDefaultStr(local.edtPostOffice.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var street = local.getDictionaryItem("CAPTION_STREET") + ": " + global.utils.setDefaultStr(local.edtStreet.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var from = local.getDictionaryItem("CAPTION_ADDRESS_FROM") + ": " + global.utils.setDefaultStr(local.edtStreetAddressFrom.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var to = local.getDictionaryItem("CAPTION_ADDRESS_TO") + ": " + global.utils.setDefaultStr(local.edtStreetAddressTo.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var isPostOfficeAddress = local.getDictionaryItem("CAPTION_IS_POSTADDRESS") + ": " + global.utils.setDefaultStr(local.cbxIsPostOfficeAddress.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var isPrivateAddress = local.getDictionaryItem("CAPTION_IS_PRIVATEADDRESS") + ": " + global.utils.setDefaultStr(local.cbxIsPrivateAddress.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));

        local.lblSumInfoAddressType.setCaption(addressType);
        local.lblSumInfoDistrict.setCaption(district);
        local.lblSumInfoZIPCode.setCaption(zipCode);
        local.lblSumInfoCity.setCaption(city);
        local.lblSumInfoPostOffice.setCaption(postOffice);
        local.lblSumInfoStreet.setCaption(street);
        local.lblSumInfoStreetAddressFrom.setCaption(from);
        local.lblSumInfoStreetAddressTo.setCaption(to);
        local.lblSumInfoIsPostOfficeAddress.setCaption(isPostOfficeAddress);
        local.lblSumInfosPrivateAddress.setCaption(isPrivateAddress);

        //!: folgende Kommentare kommen aus dem Quellcode von Wavemaker, es muss überprüft werden ob local (localScope) verwendet werden muss
        //    
        //Im folgenden werden Bindings für die Caption der lblSumInfo-Labels angegeben
        //Solange nicht geklärt ist wie man dieses Expressions lokalisieren kann werden direkt Bindings nicht für die Zusammenfassung verwendet
        //${cboAddressType.dataValue} ? "Typ: " + ${cboAddressType.displayValue} : "Keine Angabe..."
        //${edtDistrict.dataValue} ? "Stadt: " + ${edtDistrict.displayValue} : "Keine Angabe..."
        //${edtZIPCode.dataValue} ? "PLZ: " + ${edtZIPCode.displayValue} : "Keine Angabe..."
        //${edtCity.dataValue} ? "Stadt: " + ${edtCity.displayValue} : "Keine Angabe..."
        //${edtPostOffice.dataValue} ? "Postfach: " + ${edtPostOffice.displayValue} : "Keine Angabe..."
        //${edtStreet.dataValue} ? "Straße: " + ${edtStreet.displayValue} : "Keine Angabe..."
        //${edtStreetAddressFrom.dataValue} ? "von: " + ${edtStreetAddressFrom.displayValue} : "Keine Angabe..."
        //${edtStreetAddressTo.dataValue} ? "bis: " + ${edtStreetAddressTo.displayValue} : "Keine Angabe..."
        //${cbxIsPostOfficeAddress.dataValue} ? "Postanschrift: " + ${cbxIsPostOfficeAddress.displayValue} : "Keine Angabe..."
        //${cbxIsPrivateAddress.dataValue} ? "Privat: " + ${cbxIsPrivateAddress.displayValue} : "Keine Angabe..."  	  
        
        ret = true;  
    	  break;
      case "Contact":
        var contactType = local.getDictionaryItem("CAPTION_CONTACT_TYP") + ": " + global.utils.setDefaultStr(local.cboContactType.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var areaCode = local.getDictionaryItem("CAPTION_AREACODE") + ": " + global.utils.setDefaultStr(local.cboAreaCode.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var tel = local.getDictionaryItem("CAPTION_TELEPHON_SHORT") + ": " + global.utils.setDefaultStr(local.edtTel.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var fax = local.getDictionaryItem("CAPTION_FAX") + ": " + global.utils.setDefaultStr(local.edtFax.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var www = local.getDictionaryItem("CAPTION_WWW") + ": " + global.utils.setDefaultStr(local.edtWWW.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var email = local.getDictionaryItem("CAPTION_EMAIL") + ": " + global.utils.setDefaultStr(local.edtEmail.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var skype = local.getDictionaryItem("CAPTION_SKYPE") + ": " + global.utils.setDefaultStr(local.edtSkype.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var messanger = local.getDictionaryItem("CAPTION_MESSANGER") + ": " + global.utils.setDefaultStr(local.edtMessanger.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));

        local.lblSumInfoContactType.setCaption(contactType);
        local.lblSumInfoAreaCode.setCaption(areaCode);
        local.lblSumInfoTel.setCaption(tel);
        local.lblSumInfoFax.setCaption(fax);
        local.lblSumInfoWWW.setCaption(www);
        local.lblSumInfoEmail.setCaption(email);
        local.lblSumInfoSkype.setCaption(skype);
        local.lblSumInfoMessanger.setCaption(messanger);

        //!: folgende Kommentare kommen aus dem Quellcode von Wavemaker, es muss überprüft werden ob local (localScope) verwendet werden muss
        //            
        //Im folgenden werden Bindings für die Caption der lblSumInfo-Labels angegeben
        //Solange nicht geklärt ist wie man dieses Expressions lokalisieren kann werden direkt Bindings nicht für die Zusammenfassung verwendet
        //${cboContactType.dataValue} ? "Typ: " + ${cboContactType.displayValue} : "Keine Angabe..."
        //${cboAreaCode.dataValue} ? "Code: " + ${cboAreaCode.displayValue} : "Keine Angabe..."
        //${edtTel.dataValue} ? "Tel.: " + ${edtTel.displayValue} : "Keine Angabe..."
        //${edtFax.dataValue} ? "Fax: " + ${edtFax.displayValue} : "Keine Angabe..."
        //${edtWWW.dataValue} ? "WWW: " + ${edtWWW.displayValue} : "Keine Angabe..."
        //${edtEmail.dataValue} ? "eMail: " + ${edtEmail.displayValue} : "Keine Angabe..."
        //${edtSkype.dataValue} ? "Skype: " + ${edtSkype.displayValue} : "Keine Angabe..."
        //${edtMessanger.dataValue} ? "Messanger: " + ${edtMessanger.displayValue} : "Keine Angabe..."    	  
        
      	ret = true;  
      	break;
      case "BankInfo":
        var depositor = local.getDictionaryItem("CAPTION_DEPOSITOR") + ": " + global.utils.setDefaultStr(local.edtDepositor.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var kto = local.getDictionaryItem("CAPTION_KTO") + ": " + global.utils.setDefaultStr(local.edtKTO.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var blz = local.getDictionaryItem("CAPTION_BLZ") + ": " + global.utils.setDefaultStr(local.edtBLZ.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var iban = local.getDictionaryItem("CAPTION_IBAN") + ": " + global.utils.setDefaultStr(local.edtIBAN.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));
        var bic = local.getDictionaryItem("CAPTION_BIC") + ": " + global.utils.setDefaultStr(local.edtBIC.getDisplayValue(), local.getDictionaryItem("CAPTION_NO_INFO"));

        local.lblSumInfoDepositor.setCaption(depositor);
        local.lblSumInfoKTO.setCaption(kto);
        local.lblSumInfoBLZ.setCaption(blz);
        local.lblSumInfoIBAN.setCaption(iban);
        local.lblSumInfoBIC.setCaption(bic);

        //!: folgende Kommentare kommen aus dem Quellcode von Wavemaker, es muss überprüft werden ob local (localScope) verwendet werden muss
        //        
        //Im folgenden werden Bindings für die Caption der lblSumInfo-Labels angegeben
        //Solange nicht geklärt ist wie man dieses Expressions lokalisieren kann werden direkt Bindings nicht für die Zusammenfassung verwendet
        //${edtDepositor.dataValue} ? "Inhanber: " + ${edtDepositor.displayValue} : "Keine Angabe..."
        //${edtKTO.dataValue} ? "Konto: " + ${edtKTO.displayValue} : "Keine Angabe..."
        //${edtBLZ.dataValue} ? "BLZ: " + ${edtBLZ.displayValue} : "Keine Angabe..."
        //${edtIBAN.dataValue} ? "IBAN: " + ${edtIBAN.displayValue} : "Keine Angabe..."
        //${edtBIC.dataValue} ? "BIC: " + ${edtBIC.displayValue} : "Keine Angabe..."        
        
      	ret = true;  
       	break;  
      default:
        throw "NewAddressCtrl.setSummery: keine gültige Auswahl";
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
    this.setSummery("Person");
    this.setSummery("Address");
    this.setSummery("Contact");
    this.setSummery("BankInfo");
  },
  getActiveLayer: function() {
    var local = this.localScope;
    
    return  local.wizNewAddress.getActiveLayer();
  },
  selectLayerByIdx: function(idx) {
    var local = this.localScope;
    if ((!(idx) && (idx === 0)) || (idx)) {      
      var  currentLayer = this.getActiveLayer();
      if (currentLayer.getIndex() !== idx) {
        switch (idx) {
          case 0:
            local.navCallPerson.update();
            //
            break;
          case 1:
            local.navCallAddress.update();
            //
            break;
          case 2:
            local.navCallContact.update();
            //
            break;
          case 3:
            local.navCallBank.update();
            //
            break;
          case 4:
            local.navCallInfo.update();
            //
            break;
          case 5:
            local.navCallPhoto.update();
            //
            break;
          case 6:
            local.navCallSummery.update();
            //
            break;
          default:
            local.navCallPerson.update();
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
    
    dojo.subscribe('init-address-as-subdialog', this, "initAsSubDialog");
    
    this.handleSubscribeByResData("ADD_ADDRESSBOOKITEM_SUCCEEDED");   
    this.handleSubscribeByResData("NO_MANDATORY_SALUTATION_ID");
    this.handleSubscribeByResData("NO_MANDATORY_TITEL_ID");    
    this.handleSubscribeByResData("NO_MANDATORY_PERSON_NAME");
    this.handleSubscribeByResData("NO_VALID_MARRIAGE_DATA_FLAG");
    this.handleSubscribeByResData("NO_MANDATORY_MARRIAGE_PARTNER_NAME");
    this.handleSubscribeByResData("NO_MANDATORY_ADDRESS_DATA_FLAG");
    this.handleSubscribeByResData("NO_VALID_ADDRESS_DATA_FLAG");
    this.handleSubscribeByResData("NO_MANDATORY_ADDRESS_TYPE_ID");
    this.handleSubscribeByResData("NO_MANDATORY_ZIPCODE");
    this.handleSubscribeByResData("NO_MANDATORY_CITY");
    this.handleSubscribeByResData("NO_MANDATORY_STREET");
    this.handleSubscribeByResData("NO_MANDATORY_STREET_ADDRESS_FROM");
    this.handleSubscribeByResData("NO_MANDATORY_CONTACT_DATA_FLAG");
    this.handleSubscribeByResData("NO_VALID_CONTACT_DATA_FLAG");
    this.handleSubscribeByResData("NO_MANDATORY_CONTACT_TYPE_ID");
    this.handleSubscribeByResData("NO_MANDATORY_CONTACT_DATA");
    this.handleSubscribeByResData("NO_MANDATORY_BANK_DATA_FLAG");
    this.handleSubscribeByResData("NO_VALID_BANK_DATA_FLAG");
    this.handleSubscribeByResData("NO_MANDATORY_DEPOSITOR");
    this.handleSubscribeByResData("NO_MANDATORY_BLZ_FMT");
    this.handleSubscribeByResData("NO_MANDATORY_KTO_FMT");
    this.handleSubscribeByResData("NO_MANDATORY_INFO_DATA_FLAG");
    this.handleSubscribeByResData("NO_MANDATORY_INFO_DATA");
    this.handleSubscribeByResData("NO_MANDATORY_PHOTO_DATA_FLAG");
    this.handleSubscribeByResData("NO_MANDATORY_PHOTO_UNIQUE_NAME");   
    this.handleSubscribeByResData("NO_MANDATORY_PHOTO_REAL_NAME");    
    this.handleSubscribeByResData("INSERT_BY_PERSON_FAILD");
    this.handleSubscribeByResData("INSERT_BY_ADDRESS_FAILD");
    this.handleSubscribeByResData("INSERT_BY_CONTACT_FAILD");    
    this.handleSubscribeByResData("INSERT_BY_BANK_FAILD");    
    this.handleSubscribeByResData("INSERT_BY_DOCUMENT_FAILD");
    
    /*
     * Stand 2013-03-17: wird nicht vom Server gesendet
     *          
    this.handleSubscribeByResData("NO_VALID_PERSON_ID");    
    this.handleSubscribeByResData("NO_VALID_ADDRESS_ID");
    this.handleSubscribeByResData("NO_VALID_CONTACT_ID");
    this.handleSubscribeByResData("NO_VALID_BANK_ID");
    this.handleSubscribeByResData("NO_VALID_DOCUMENT_ID");
    *
    *    
    */

    this.handleSubscribeByResData("NO_VALID_MANDANT_ID");    
    this.handleSubscribeByResData("FAILD_BY_OBSCURE_PROCESSING");
    /* this.handleSubscribeByResData("FAILD_BY_UNKNOWN_REASON"); */
    
    console.debug('End Controller.subscribeForChannels.SubClass');    
  },
  infoByUnhandledCode: function(success) {
    var global = this.globalScope;
    var local = this.localScope;
    
    if (success) {
        global.toastSuccess(local.getDictionaryItem("ADD_ADDRESSBOOKITEM_SUCCEEDED"));
    } else {
        global.toastWarning(local.getDictionaryItem("WARNING_BY_OBSCURE_PROCESSING"));
    }  
  },
  handleExceptionByCtrl: function(msg, e, code) {
    this.inherited (arguments);    
  },
  showSearch: function(sender, searchParameter, title) {
    this.inherited (arguments);
  },
  showCatalogItem: function(sender, catalogParameter, callback, title) {
    this.inherited (arguments);
  }      
});