dojo.declare("NewTenant", wm.Page, {
    "preferredDevice": "desktop",
    onResultByNewRedording: function() {},
    onSuccessByNewRecording: function(success) {},
    start: function() {
        try {
            console.debug('start: start');

            app.dlgLoading.setParameter(app.dummyServiceVar, this.wizNewTenant);

            this.controller = new NewTenantCtrl(app, this);

            console.debug('start: end');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
        }
    },
    btnFindFactoryDatasheetClick: function(inSender) {
        //code kommt noch
    },
    btnFindPersonDatasheetClick: function(inSender) {
        //code kommt noch		
    },
    btnFindContactDatasheetClick: function(inSender) {
        //code kommt noch		
    },
    btnFindAddressDatasheetClick: function(inSender) {
        //code kommt noch		
    },
    btnFindAreaCodeClick: function(inSender) {
        //code kommt noch		
    },
    btnAddAreaCodeClick: function(inSender) {
        //code kommt noch		
    },
    btnAddFactoryDatasheetClick: function(inSender) {
        //code kommt noch		
    },
    btnAddPersonDatasheetClick: function(inSender) {
        //code kommt noch		
    },
    btnAddContactDatasheetClick: function(inSender) {
        //code kommt noch		
    },
    btnAddAddressDatasheetClick: function(inSender) {
        //code kommt noch		
    },
    wizNewTenantCancelClick: function(inSender) {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewTenantCancelClick() failed: " + e.toString(), e);
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
    onStart: function(inPage) {
        try {
            console.debug('onStart: Begin');

            console.debug('onStart: End');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onStart() failed: " + e.toString(), e);
        }
    },
    wizNewTenantCanchange: function(inSender, inChangeInfo) {
        var success = this.controller.onWizNewTenantCanChange(inSender, inChangeInfo);
    },
    wizNewTenantDoneClick: function(inSender) {
        try {
            app.closeWizard(this.getDictionaryItem("CONFIRMATION_DO_CLOSE_ADD"), this.getDictionaryItem("CONFIRMATION_DLG_TITLE_FOR_CLOSE_ADD"));
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewTenantDoneClick() failed: " + e.toString(), e);
        }
    },
    btnAddDataClick: function(inSender) {
        try {
            console.debug('Start btnAddDataClick');

            app.dlgLoading.setParameter(this.addTenant, this.wizNewTenant);

            if (this.addTenant.canUpdate()) {
                this.addTenant.update();
            } else {
                app.toastError(this.getDictionaryItem("ERROR_MSG_ADD_TENANT_NO_SUCCESS_BY_EXECUTE"));
            }

            console.debug('End btnAddDataClick');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddDataClick() failed: " + e.toString(), e);
        }
    },
    refreshOnaddTenantSuccess: function() {
        try {
            app.dummyServiceVar.doRequest();

            //NavCall wird in clearWizard in selectByLayerIdx ausgeführt
            //this.navCallPerson.update();
            if (!this.controller.clearWizard(0)) {
                throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
            }

            app.dummyServiceVar.doResult();
            return true;
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".refreshOnAddTenantSuccess() failed: " + e.toString(), e, -1);
            app.dummyServiceVar.doResult();
            return false;
        }
    },
    addTenantError: function(inSender, inError) {
        try {
            console.debug('Start addTenantError');

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADDTENANT") + inError.message;

            app.toastError(errMsg);

            console.debug('End addTenantError');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addTenantError() failed: " + e.toString(), e);
        }
    },
    addTenantResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start addTenantResult');

            console.debug('End addTenantResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addTenantResult() failed: " + e.toString(), e);
        }
    },
    addTenantSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start addTenantSuccess');

            /* varResultByInsert muss von dem Aufruf des Serverice gefüllt werden */
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

                            if (!this.refreshOnaddTenantSuccess()) {
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

            console.debug('End addTenantSuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addTenantSuccess() failed: " + e.toString(), e);
        }
    },
    onEscapeKey: function() {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onEscapeKey() failed: " + e.toString(), e);
        }
    },
    wizNewTenantChange: function(inSender, inIndex) {
        try {
            switch (inIndex) {
            case 1:
                break;
            case 2:
                break;
            case 3:
                this.controller.setSummeryInfo();
                break;
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewTenantChange() failed: " + e.toString(), e);
        }
    },
    _end: 0
});