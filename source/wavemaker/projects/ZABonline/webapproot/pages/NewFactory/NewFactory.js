dojo.declare("NewFactory", wm.Page, {
    "i18n": true,
    "preferredDevice": "desktop",
    start: function() {
        try {
            console.debug('start: start');
            app.dlgLoading.setParameter(app.dummyServiceVar, this.wizNewFactory);

            this.controller = new NewFactoryCtrl(app, this);
            console.debug('start: end');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
        }
    },
    onShow: function() {
        try {
            console.debug('onShow: start');

            if (!this.controller) {
                app.alert(this.getDictionaryItem("ERROR_MSG_BY_UNKNOWN_CONTROLLER"));
                app.closeWizard();
            } else {
                app.dummyServiceVar.doRequest();
                if (!this.controller.clearWizard(0)) {
                    throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
                }

                if (!this.controller.loadLookupData()) {
                    throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_LOOUPDATA");
                }
                app.dummyServiceVar.doResult();
            }

            console.debug('onShow: end');
        } catch (e) {
            app.dummyServiceVar.doResult();
            this.controller.handleExceptionByCtrl(this.name + ".onShow() failed: " + e.toString(), e, 1);
            app.closeWizard();
        }
    },
    wizNewFactoryCancelClick: function(inSender) {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewFactoryCancelClick() failed: " + e.toString(), e);
        }
    },
    wizNewFactoryChange: function(inSender, inIndex) {
        try {
            switch (inIndex) {
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                break;
            case 5:
                break;
            case 6:
                break;
            case 7:
                this.controller.setSummeryInfo();
                break;
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewAddressChange() failed: " + e.toString(), e);
        }
    },
    wizNewFactoryDoneClick: function(inSender) {
        try {

            app.closeWizard(this.getDictionaryItem("CONFIRMATION_DO_CLOSE_ADD_FACTORYITEM"), this.getDictionaryItem("CONFIRMATION_DLG_TITLE_FOR_CLOSE_FACTORYITEM"));

        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewFactoryDoneClick() failed: " + e.toString(), e);
        }
    },
    onStart: function(inPage) {
        try {
            console.debug('onStart: Begin');

            console.debug('onStart: End');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onStart() failed: " + e.toString(), e);
        }
    },
    wizNewFactoryCanchange: function(inSender, inChangeInfo) {
        var success = this.controller.onWizNewFactoryCanChange(inSender, inChangeInfo);
    },
    onEscapeKey: function() {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onEscapeKey() failed: " + e.toString(), e);
        }
    },
    cbxNoInfoChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            this.controller.enableContainer(inSender.getChecked(), this.pnlInfoLayout, this.edtDescription);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoInfoChange() failed: " + e.toString(), e);
        }
    },
    cbxNoAddressDataChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            this.controller.setByQuickSetup("Address", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlAddressLayout, this.cboAddressType);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoAddressDataChange() failed: " + e.toString(), e);
        }
    },
    cbxNoContactDataChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            this.controller.setByQuickSetup("Contact", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlContactLayout, this.cboContactType);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoContactDataChange() failed: " + e.toString(), e);
        }
    },
    cbxNoBankInfoChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            this.controller.setByQuickSetup("BankInfo", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlBankLayout, this.edtDepositor);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoBankInfoChange() failed: " + e.toString(), e);
        }
    },
    cbxNoPhotoChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            this.controller.enableContainer(inSender.getChecked(), this.pnlPhotoLayout);
            if (inSender.getChecked()) {
                this.setDefaultStateByPhotoLayout();
            }
            else {
                this.fileUpload.setShowing(true);
            }

        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoPhotoChange() failed: " + e.toString(), e);
        }
    },
    setDefaultStateByPhotoLayout: function() {
        this.picPhoto.setSource('resources/images/logos/symbol_questionmark.png');
        this.varUploadPhoto.clearData();
        this.varUploadPhotoResponse.clearData();
        this.fileUpload.reset();
        this.fileUpload.setShowing(false);
        this.varFilename.clearData();
        this.varUniqueFilename.clearData();
    },
    fileUploadSuccess: function(inSender, fileList) {
        try {
            var relFilename = this.varUploadPhoto.getValue('path');
            var filename = app.utils.extractFilename(relFilename);

            this.varFilename.setValue("dataValue", filename);
            this.varUniqueFilename.setValue("dataValue", filename); /* Stand 2013-03-22: der Eindeutige Dateiname wird serverseitig ermittelt; an dieser Stelle wird der reale Name übergeben */

            console.debug('path: ' + this.varUploadPhoto.getValue('path'));
            console.debug('filename: ' + filename);

            this.picPhoto.setSource(this.varUploadPhoto.getValue('path'));
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".fileUploadSuccess() failed: " + e.toString(), e);
        }
    },
    cboContactPartnerIdChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            var data = inSender.selectedItem.getData();
            if (data) {
                var firstName = app.utils.getPropertyValue(data, "firstName");
                if (firstName !== null) {
                    this.edtContactPersonFirstname.setDataValue(firstName);
                }
                //
                var name1 = app.utils.getPropertyValue(data, "name1");
                if (name1 !== null) {
                    this.edtContactPersonName.setDataValue(name1);
                }
                //
                var phoneFmt = app.utils.getPropertyValue(data, "phoneFmt");
                if (phoneFmt !== null) {
                    this.edtContactPersonPhone.setDataValue(phoneFmt);
                }
                //
                var email = app.utils.getPropertyValue(data, "email");
                if (email !== null) {
                    this.edtContactPersonMail.setDataValue(email);
                }
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cboContactPartnerIdChange() failed: " + e.toString(), e);
        }
    },
    cbxNoContactPartnerChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            this.controller.setByQuickSetup("ContactPartner", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlContactPerson, this.cboContactPartnerId);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoContactPartnerChange() failed: " + e.toString(), e);
        }
    },
    cbxNoDatasheetChange: function(inSender, inDisplayValue, inDataValue, inSetByCode) {
        try {
            this.controller.setByQuickSetup("FactoryData", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlDatasheetLayout, this.cboDatasheetId);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoDatasheetChange() failed: " + e.toString(), e);
        }
    },
    addFactoryError: function(inSender, inError) {
        try {
            console.debug('Start addFactoryError');

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADD_DATA") + inError.message;

            app.toastError(errMsg);

            console.debug('End addFactoryError');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addFactoryError() failed: " + e.toString(), e);
        }
    },
    addFactoryResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start addFactoryResult');

            console.debug('End addFactoryResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addFactoryResult() failed: " + e.toString(), e);
        }
    },
    refreshOnAddServiceSuccess: function() {
        try {
            app.dummyServiceVar.doRequest();

            this.navCallFactory.update();

            if (!this.controller.clearWizard(0)) {
                throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
            }

/* 
            Wenn Ergebnismengen nach dem erfolgreichen Einfügen von Servicedaten aktualisiert werden sollen dann hier durchführen
            
            if (this.<serviceVariable>.canUpdate()) {
                this.<serviceVariable>.update();
            } else {
                throw this.getDictionaryItem("ERROR_MSG_BY_REFRESH_<serviceVariable-description>");
            }
            */

            app.dummyServiceVar.doResult();
            return true;
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".refreshOnAddServiceSuccess() failed: " + e.toString(), e, -1);
            app.dummyServiceVar.doResult();
            return false;
        }
    },
    addFactorySuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start addFactorySuccess');

            /* varResultByInsert muss von dem Aufruf der Testprocedure auf den AddFactory-Service umgelegt werden */
            console.debug('Success: ' + this.varResultByInsert.getValue('success'));
            console.debug('Code: ' + this.varResultByInsert.getValue('code'));
            console.debug('Info: ' + this.varResultByInsert.getValue('info'));

            var code = this.varResultByInsert.getValue('code');
            var success = this.varResultByInsert.getValue('success');

            if (!code) {
                this.controller.infoByUnhandledCode(success);
            } else {
                var codeStr = this.varResultByInsert.getValue('info');

                if (!codeStr) {
                    this.controller.infoByUnhandledCode(success);
                } else {
                    var kindFound = codeStr.search(/kind/);

                    if (kindFound != -1) {
                        var codeObj = dojo.fromJson(codeStr);

                        switch (codeObj.kind) {
                        case 1:
                            /* Fehler mit einfacher Fehlermeldung */
                            dojo.publish(codeObj.publish, [codeObj]);
                            //
                            break;
                        case 2:
                            /* Fehler mit erweiterter Fehlermeldung */
                            dojo.publish(codeObj.publish, [codeObj]);
                            //
                            break;
                        case 4:
                            // case 4 und case 3 sollen den selben Code durchlaufen, daher kein code und kein break
                        case 3:
                            /* Daten erfolgreich übernommen */
                            dojo.publish(codeObj.publish, [codeObj]);

                            if (!this.refreshOnAddServiceSuccess()) {
                                throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_REFRESHWIZARD");
                            }
                            //
                            break;
                        default:
                            //
                            break;
                        }
                        console.debug('Kind: ' + codeObj.kind + ' - Publish: ' + codeObj.publish + ' - Message: ' + codeObj.message);
                    } else {
                        this.controller.infoByUnhandledCode(success);
                    }
                }
            }

            console.debug('End addFactorySuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addFactorySuccess() failed: " + e.toString(), e);
        }
    },
    btnAddPersonClick: function(inSender) {
        //code kommt noch
    },
    btnFindPersonClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'person', callback: 'onGetResultBySearch'}");
    },
    btnFindDataSheetClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'datasheet', callback: 'onGetResultBySearch'}");
    },
    btnAddDatasheetClick: function(inSender) {
        //code kommt noch
    },
    refreshByAddCatalogItem: function() {
        return function(scope, catalog) {
            scope.controller.onRefreshLookupByTarget(catalog, 1);
        };
    },
    btnAddAddressTypeClick: function(inSender) {
        this.controller.showCatalogItem(this, "{kind: 1001, mode: 0, page: 'NewCatalogItem', catalog: 'ADDRESS_TYPE'}", this.refreshByAddCatalogItem(), app.getDictionaryItem("CAPTION_ADDCATALOG_TITLE_ADDRESS_TYPE"));
    },
    btnFindAddresstypeClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'addressType', callback: 'onGetResultBySearch'}");
    },
    btnFindContactTypeClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'areaCode', callback: 'onGetResultBySearch'}");
    },
    btnFindAreaCodeClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'areaCode', callback: 'onGetResultBySearch'}");
    },
    btnAddContactTypeClick: function(inSender) {
        this.controller.showCatalogItem(this, "{kind: 1001, mode: 0, page: 'NewCatalogItem', catalog: 'CONTACT_TYPE'}", this.refreshByAddCatalogItem(), app.getDictionaryItem("CAPTION_ADDCATALOG_TITLE_CONTACT_TYPE"));
    },
    btnAddAreaCodeClick: function(inSender) {
        this.controller.showCatalogItem(this, "{kind: 1001, mode: 1, page: 'NewCatalogItem', catalog: 'AREA_CODE'}", this.refreshByAddCatalogItem(), app.getDictionaryItem("CAPTION_ADDCATALOG_TITLE_AREA_CODE"));
    },
    _end: 0
});