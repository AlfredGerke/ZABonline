dojo.declare("NewAddress", wm.Page, {
    "preferredDevice": "desktop",
    "i18n": true,
    onResultByNewRedording: function() {},
    onSuccessByNewRecording: function(success) {},
    setDefaultStateByPhotoLayout: function() {
        this.picPhoto.setSource('resources/images/logos/symbol_questionmark.png');
        this.varUploadPhoto.clearData();
        this.varUploadPhotoResponse.clearData();
        this.fileUpload.reset();
        this.fileUpload.setShowing(false);
        this.varFilename.clearData();
        this.varUniqueFilename.clearData();
    },
    start: function() {
        try {
            console.debug('start: start');
            app.dlgLoading.setParameter(app.dummyServiceVar, this.wizNewAddress);

            this.controller = new NewAddressCtrl(app, this);
            console.debug('start: end');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
        }
    },
    wizNewAddressCancelClick: function(inSender) {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewAddressCancelClick() failed: " + e.toString(), e);
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
    wizNewAddressCanchange: function(inSender, inChangeInfo) {
        var success = this.controller.onWizNewAddressCanChange(inSender, inChangeInfo);
    },
    onEscapeKey: function() {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onEscapeKey() failed: " + e.toString(), e);
        }
    },
    cbxNoInfoChange: function(inSender) {
        try {
            this.controller.enableContainer(inSender.getChecked(), this.pnlInfoLayout, this.edtDescription);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoInfoChange() failed: " + e.toString(), e);
        }
    },
    cbxNoAddressDataChange: function(inSender) {
        try {
            this.controller.setByQuickSetup("Address", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlAddressLayout, this.cboAddressType);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoAddressDataChange() failed: " + e.toString(), e);
        }
    },
    cbxNoContactDataChange: function(inSender) {
        try {
            this.controller.setByQuickSetup("Contact", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlContactLayout, this.cboContactType);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoContactDataChange() failed: " + e.toString(), e);
        }
    },
    cbxNoBankInfoChange: function(inSender) {
        try {
            this.controller.setByQuickSetup("BankInfo", !inSender.getChecked(), true);
            //
            this.controller.enableContainer(inSender.getChecked(), this.pnlBankLayout, this.edtDepositor);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxNoBankInfoChange() failed: " + e.toString(), e);
        }
    },
    cbxNoPhotoChange: function(inSender) {
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
    cboSalutationChange: function(inSender) {
        try {
            var desc = app.utils.getPropertyValue(inSender.selectedItem.getData(), "description");
            if (desc !== null) {
                this.edtAltSalutation.setDataValue(desc);
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cboSalutationChange() failed: " + e.toString(), e);
        }
    },
    cboMarrigePartnerIdChange: function(inSender) {
        try {
            var data = inSender.selectedItem.getData();
            if (data) {
                var firstName = app.utils.getPropertyValue(data, "firstname");
                if (firstName !== null) {
                    this.edtMarrigePartnerFirstName.setDataValue(firstName);
                }
                //
                var name1 = app.utils.getPropertyValue(data, "name1");
                if (name1 !== null) {
                    this.edtMarrigePartnerName.setDataValue(name1);
                }
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cboMarrigePartnerIdChange() failed: " + e.toString(), e);
        }
    },
    cbxIsMarriedChange: function(inSender) {
        try {
            this.controller.setByQuickSetup("Person", inSender.getChecked(), true);
            //
            this.pnlMarriagePartnerData.setDisabled(!inSender.getChecked());
            if (!inSender.getChecked()) {
                this.pnlMarriagePartnerData.clearData();
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".cbxIsMarriedChange() failed: " + e.toString(), e);
        }
    },
    marriagePartnerLookupDataSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('marriagePartnerLookupData.getPageCount: ' + this.marriagePartnerLookupData.getPageCount());
            console.debug('marriagePartnerLookupData.getTotal: ' + this.marriagePartnerLookupData.getTotal());
            console.debug('marriagePartnerLookupData.getCount: ' + this.marriagePartnerLookupData.getCount());
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".marriagePartnerLookupDataSuccess() failed: " + e.toString(), e);
        }
    },
    startTestProcVar: function(inSender) {
        try {
            app.dlgLoading.setParameter(this.testProcVar, this.wizNewAddress);
            //this.testProcVar.input.setValue('aDate', null);
            this.testProcVar.input.setValue('aInteger', 1808);
            this.testProcVar.input.setValue('aSmallInt', 254);
            this.testProcVar.input.setValue('aTenantId', app.globalData.tenantId());
            this.testProcVar.input.setValue('aVarchar254', "absdef");
            this.testProcVar.input.setValue('aVarchar2000', "absdefghijklmnopqrstuvw");
            if (this.testProcVar.canUpdate()) {
                this.testProcVar.update();
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".startTestProcVar() failed: " + e.toString(), e);
        }
    },
    testProcVarError: function(inSender, inError) {
        try {
            console.debug(inSender);
            console.debug(inError);

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADD_ADDERSSBOOKITEM") + inError.message;

            app.toastError(errMsg);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".testProcVarError() failed: " + e.toString(), e);
        }
    },
    testProcVarSuccess: function(inSender, inDeprecated) {
        try {
            console.debug(inSender);
            console.debug(inDeprecated);
            console.debug('SessionId: ' + app.getSessionId());
            console.debug('Success: ' + this.varResultByInsert.getValue('success'));
            console.debug('Code: ' + this.varResultByInsert.getValue('code'));
            console.debug('Info: ' + this.varResultByInsert.getValue('info'));

            var codeStr = this.varResultByInsert.getValue('info');
            var codeObj = dojo.fromJson(codeStr);
            console.debug('Name: ' + codeObj[0].name + ' - Vorname: ' + codeObj[0].vorname + ' - Id: ' + codeObj[0].id);
            console.debug('Name: ' + codeObj[1].name + ' - Vorname: ' + codeObj[1].vorname + ' - Id: ' + codeObj[1].id);
            console.debug('Name: ' + codeObj[2].name + ' - Vorname: ' + codeObj[2].vorname + ' - Id: ' + codeObj[2].id);

            this.varCodeByResult.setJson("[{name: 'five', dataValue: 5}, {name: 'three', dataValue: 3}]");
            console.debug(this.varCodeByResult.getData());
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".testProcVarSuccess() failed: " + e.toString(), e);
        }
    },
    testProcVarResult: function(inSender, inDeprecated) {
        try {
            console.debug(inSender.getData());
            console.debug('success: ' + inDeprecated.success);
            console.debug('code: ' + inDeprecated.code);
            console.debug('info: ' + inDeprecated.info);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".testProcVarResult() failed: " + e.toString(), e);
        }
    },
    wizNewAddressChange: function(inSender, inIndex) {
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
                this.controller.setSummeryInfo();
                break;
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewAddressChange() failed: " + e.toString(), e);
        }
    },
    btnAddAddressBookItemClick: function(inSender) {
        try {
            console.debug('Start btnAddAddressBookItemClick');

            app.dlgLoading.setParameter(this.addAddressBookItem, this.wizNewAddress);

            if (this.addAddressBookItem.canUpdate()) {
                this.addAddressBookItem.update();
            } else {
                app.toastError(this.getDictionaryItem("ERROR_MSG_ADD_ADDRESSBOOKITEM_NO_SUCCESS_BY_EXECUTE"));
            }

            console.debug('End btnAddAddressBookItemClick');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddAddressBookItemClick() failed: " + e.toString(), e);
        }
    },
    addAddressBookItemResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start addAddressBookItemResult');

            console.debug('End addAddressBookItemResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addAddressBookItemResult() failed: " + e.toString(), e);
        }
    },
    refreshOnAddAddressBookItemSuccess: function() {
        try {
            app.dummyServiceVar.doRequest();

            //NavCall wird in clearWizard in selectByLayerIdx ausgeführt
            //this.navCallPerson.update();
            if (!this.controller.clearWizard(0)) {
                throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
            }

            if (this.marriagePartnerLookupData.canUpdate()) {
                this.marriagePartnerLookupData.update();
            } else {
                throw this.getDictionaryItem("ERROR_MSG_BY_REFRESH_MARRIAGEPARTNER_LOOKUP_DATA");
            }

            app.dummyServiceVar.doResult();
            return true;
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".refreshOnAddAddressBookItemSuccess() failed: " + e.toString(), e, -1);
            app.dummyServiceVar.doResult();
            return false;
        }
    },
    addAddressBookItemSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start addAddressBookItemSuccess');

            /* varResultByInsert muss von dem Aufruf der Testprocedure auf den AddAddressBoolItem-Service umgelegt werden */
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

                            if (!this.refreshOnAddAddressBookItemSuccess()) {
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

            console.debug('End addAddressBookItemSuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addAddressBookItemSuccess() failed: " + e.toString(), e);
        }
    },
    addAddressBookItemError: function(inSender, inError) {
        try {
            console.debug('Start addAddressBookItemError');

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADD_ADDERSSBOOKITEM") + inError.message;

            app.toastError(errMsg);

            console.debug('End addAddressBookItemError');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addAddressBookItemError() failed: " + e.toString(), e);
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
    wizNewAddressDoneClick: function(inSender) {
        try {
            app.closeWizard(this.getDictionaryItem("CONFIRMATION_DO_CLOSE_ADD_ADDRESBOOKITEM"), this.getDictionaryItem("CONFIRMATION_DLG_TITLE_FOR_CLOSE_ADDRESBOOKITEM"));
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewAddressDoneClick() failed: " + e.toString(), e);
        }
    },
    btnFindSalutationClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000, mode: 0, find: 'salutation', callback: 'onGetResultBySearch'}");
    },
    refreshBySalutationCatalog: function() {},
    btnAddSalutationClick: function(inSender) {
        this.controller.showCatalogItem(this, "{kind: 1001, mode: 0, page: 'NewCatalogItem', catalog: 'SALUTATION', callback: 'refreshBySalutationCatalog'}", app.getDictionaryItem("CAPTION_ADDCATALOG_TITLE_SALUTATION"));
    },
    btnFindTitelClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'titel', callback: 'onGetResultBySearch'}");
    },
    refreshByTitleCatalog: function() {},
    btnAddTitelClick: function(inSender) {
        this.controller.showCatalogItem(this, "{kind: 1001, mode: 0, page: 'NewCatalogItem', catalog: 'TITEL', callback: 'refreshByTitleCatalog'}", app.getDictionaryItem("CAPTION_ADDCATALOG_TITLE_TITLE"));
    },
    btnFindPersonClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'person', callback: 'onGetResultBySearch'}");
    },
    btnAddPersonClick: function(inSender) {
        //code kommt noch
    },
    btnFindAddressTypeClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'addressType', callback: 'onGetResultBySearch'}");
    },
    refreshByAddressTypeCatalog: function() {},
    btnAddAddressTypeClick: function(inSender) {
        this.controller.showCatalogItem(this, "{kind: 1001, mode: 0, page: 'NewCatalogItem', catalog: 'ADDRESS_TYPE', callback: 'refreshByAddressTypeCatalog'}", app.getDictionaryItem("CAPTION_ADDCATALOG_TITLE_ADDRESS_TYPE"));
    },
    btnFindContactTypeClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'contactType', callback: 'onGetResultBySearch'}");
    },
    refreshByContactTypeCatalog: function() {},
    btnAddContactTypeClick: function(inSender) {
        this.controller.showCatalogItem(this, "{kind: 1001, mode: 0, page: 'NewCatalogItem', catalog: 'CONTACT_TYPE', callback: 'refreshByContactTypeCatalog'}", app.getDictionaryItem("CAPTION_ADDCATALOG_TITLE_CONTACT_TYPE"));
    },
    btnFindAreaCodeClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'areaCode', callback: 'onGetResultBySearch'}");
    },
    btnAddAreadCodeClick: function(inSender) {
        //code kommt noch
    },
    _end: 0
});