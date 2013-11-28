dojo.provide("wm.packages.zabonline.mod.NewFactoryCtrl");
//
wm.require("zabonline.mod.Controller", true);
//
dojo.declare("NewFactoryCtrl", Controller, {
  constructor: function(globalScope, localScope) {
    console.debug('Start NewFactoryCtrl.constructor');
    
    this.initStart();
    
    console.debug('End NewFactoryCtrl.constructor');
  },
  initStart: function() {
    var global = this.globalScope;
    var local = this.localScope; 

    local.connect(global.addressTypeLookupData, "onSuccess", this, "onInitAddressType");
    local.connect(global.contactTypeLookupData, "onSuccess", this, "onInitContactType");
  },    
  initSelectMenu: function(target, idx) {  
    var global = this.globalScope;
    var local = this.localScope;
    var doBreak = true;    
    try {
      console.debug("Start NewFactoryCtrl.initSelectMenu");
      
      if (!target) {
        target = "Factory";
        doBreak = false; 
      }
      
      if (!idx) {
        idx = 0;
      }
      
      switch (target) {
        case "Factory":
          //
          if (doBreak) {            
            break;
          }
        case "FactoryData":
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
          throw "NewFactoryCtrl.initSelectMenu: keine gültige Auswahl";
          //
          break;    
      }
      console.debug("End NewFactoryCtrl.initSelectMenu");
                  
      return true;
    } catch (e) {
      this.handleExceptionByCtrl(this.localScope.name + ".initSelectMenu() failed: " + e.toString(), e, -1);
      return false;
    }     
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
      local.btnFindPerson.setShowing(false);
      local.btnAddPerson.setShowing(false);
      local.btnFindDatasheet.setShowing(false);
      local.btnAddDatasheet.setShowing(false);
      local.btnFindAddressType.setShowing(false);
      local.btnAddAddressType.setShowing(false);
      local.btnFindContactType.setShowing(false);
      local.btnAddContactType.setShowing(false);
      local.btnFindAreaCode.setShowing(false);
      local.btnAddAreaCode.setShowing(false);
    } else {
      local.btnFindPerson.setShowing(true);
      local.btnAddPerson.setShowing(true);
      local.btnFindDatasheet.setShowing(true);
      local.btnAddDatasheet.setShowing(true);
      local.btnFindAddressType.setShowing(true);
      local.btnAddAddressType.setShowing(true);
      local.btnFindContactType.setShowing(true);
      local.btnAddContactType.setShowing(true);
      local.btnFindAreaCode.setShowing(true);
      local.btnAddAreaCode.setShowing(true);    
    }
  },  
  setByQuickSetup: function(target, doRequire, doClear) {
    var ret = false;    
    try {
      switch (target) {
        case "Factory":
          this.localScope.edtFactory.quickSetup(true, this.localScope.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);          
          //
          ret = true;
          break;
        case "ContactPartner":
          this.localScope.edtContactPersonName.quickSetup(doRequire, this.localScope.getDictionaryItem("REG_EXPR_NO_EXPR"), doClear);        
          //
          ret = true;
          break;  
        case "FactoryData":
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
          throw "NewFactoryCtrl.setQuickSetup: keine gültige Auswahl";
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
  loadLookupData: function() {
    var success = 0;
    try {                                               
      if (this.globalScope.addressTypeLookup.refresh() > 0) {
        success = 1;
      } else {
        success = 0;
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
        case "Factory":
          local.layFactory.clearData();
          local.cbxNoContactPartner.setChecked(true);
          this.enableContainer(local.cbxNoContactPartner.getChecked(), local.pnlContactPerson)
          //
          ret = true;
          break;
        case "FactoryData":
          local.layDatasheet.clearData();
          local.cbxNoDatasheet.setChecked(true);
          this.enableContainer(local.cbxNoDatasheet.getChecked(), local.pnlDatasheetLayout);         
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
          throw "NewFactoryCtrl.clearData: keine gültige Auswahl";
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
      if (!this.setByQuickSetup("Factory", false, true)) {
        throw "Fehler beim Einrichten vom Betrieb!";
      }
      if (!this.setByQuickSetup("ContactPartner", false, true)) {
        throw "Fehler beim Einrichten von Ansprechpartnern!";
      }      
      if (!this.setByQuickSetup("FactoryData", false, true)) {
        throw "Fehler beim Einrichten vom Datenblatt!";
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
      if (!this.clearData("Factory")) {
        throw "Fehler beim Zurücksetzen von Betrieben!";
      }
      if (!this.clearData("FactoryData")) {
        throw "Fehler beim Zurücksetzen von Betriebsdaten!";
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
        throw "Fehler beim Zurücksetzen vom Bildmaterial!";
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
        case "Factory":
          var factory = global.utils.setDefaultStr(local.edtFactory.getDataValue());

          checked = (factory.trim() !== "");  
                          
          if (checked) {                
            if (!local.cbxNoContactPartner.getChecked()) {
              checked = false;
              var contactPersonName = global.utils.setDefaultStr(local.edtContactPersonName.getDataValue());
              checked = (contactPersonName.trim() !== "");
            }
          }
          //
          break
        case "FactoryData":
          if (local.cbxNoDatasheet.getChecked()) {
            checked = true;
          } else {
            var datasheetShortDesc = global.utils.setDefaultStr(local.edtDatasheetShortDesc.getDataValue());
            //
            checked = (datasheetShortDesc.trim() !== "");
          }
          //          
          break          
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
          throw "NewFactoryCtrl.checkData: keine gültige Auswahl";
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
  onWizNewFactoryCanChange: function(inSender, inChangeInfo) {
    var global = this.globalScope;
    var local = this.localScope;  
    var doChange = false;
    var errorMsg = "";
    try {
      switch (inSender.layerIndex) {
      case 0:
        doChange = this.checkData("Factory");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_FACTORY");
        }      
        //
        break;
      case 1:
        doChange = this.checkData("FactoryData");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_FACTORY_DATA");
        }      
        //  
        break;
      case 2:
        doChange = this.checkData("Address");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_ADDRESS_DATA");
        }
        //
        break;
      case 3:
        doChange = this.checkData("Contact");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_CONTACT_DATA");
        }
        //
        break;
      case 4:
        doChange = this.checkData("BankInfo");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_BANK_DATA");
        }
        //
        break;
      case 5:
        doChange = this.checkData("Info");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_INFORMATION");
        }
        //
        break;
      case 6:
        doChange = this.checkData("Photo");
        if (!doChange) {
          errorMsg = local.getDictionaryItem("ERROR_MSG_NO_VALID_PHOTO");
        }
        //
        break;        
      case 7:
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
      this.handleExceptionByCtrl(this.localScope.name + ".WizNewFactoryCanchange() failed: " + e.toString(), e);      
      return inChangeInfo.canChange;
    } 
  },
  setSummery: function(target) {
    var global = this.globalScope;
    var local = this.localScope;
    var ret = false;
    try {
      switch (target) {
      case "Factory":
        //
        ret = true;
        break;
      case "FactoryData":
        //
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
        throw "NewFactoryCtrl.setSummery: keine gültige Auswahl";
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
    this.setSummery("Factory");
    this.setSummery("FactoryData");  
    this.setSummery("Address");
    this.setSummery("Contact");
    this.setSummery("BankInfo");
  },
  getActiveLayer: function() {
    var local = this.localScope;
    
    return  local.wizNewFactory.getActiveLayer();                  
  },
  selectLayerByIdx: function(idx) {
    var local = this.localScope;
    if ((!(idx) && (idx === 0)) || (idx)) {      
      var  currentLayer = this.getActiveLayer();
      if (currentLayer.getIndex() !== idx) {
        switch (idx) {
          case 0:
            local.navCallFactory.update();
            //
            break;
          case 1:
            local.navCallFactoryData.update();
            //
            break;  
          case 2:
            local.navCallAddress.update();
            //
            break;
          case 3:
            local.navCallContact.update();
            //
            break;
          case 4:
            local.navCallBank.update();
            //
            break;
          case 5:
            local.navCallInfo.update();
            //
            break;
          case 6:
            local.navCallPhoto.update();
            //
            break;  
          case 7:
            local.navCallSummery.update();
            //
            break;
          default:
            local.navCallFactory.update();
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
    
    dojo.subscribe('init-factory-as-subdialog', this, "initAsSubDialog");
    
    this.handleSubscribeByResData("ADD_FACTORYITEM_SUCCEEDED");   
    
    console.debug('End Controller.subscribeForChannels.SubClass');    
  },
  infoByUnhandledCode: function(success) {
    var global = this.globalScope;
    var local = this.localScope;
    
    if (success) {
        global.toastSuccess(local.getDictionaryItem("ADD_FACTORYITEM_SUCCEEDED"));
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