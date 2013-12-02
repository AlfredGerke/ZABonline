dojo.declare("NewCountry", wm.Page, {
    "i18n": true,
    "preferredDevice": "desktop",
    start: function() {
        try {
            console.debug('NewCountryCodeCtrl.start: start');

            this.controller = new NewCountryCodeCtrl(app, this);

            console.debug('NewCountryCodeCtrl.start: end');
        } catch (e) {
            if (this.controller) {
                this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
            } else {
                console.error(this.name + ".start() failed: " + e.toString());
            }
        }
    },
    addCountryCodesError: function(inSender, inError) {
        try {
            console.debug('Start addCountryCodesError');

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADD_COUNTRYCODES") + inError.message;

            app.toastError(errMsg);

            console.debug('End addCountryCodesError');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addCountryCodesError() failed: " + e.toString(), e);
        }
    },
    addCountryCodesResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start addCountryCodesResult');

            console.debug('End addCountryCodesResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addCountryCodesResult() failed: " + e.toString(), e);
        }
    },
    refreshOnAddCountryCodesSuccess: function() {
        try {
            app.dummyServiceVar.doRequest();

            if (!this.controller.clearWizard(0)) {
                throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
            }

            app.dummyServiceVar.doResult();
            return true;
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".refreshOnAddCountryCodesSuccess() failed: " + e.toString(), e, -1);
            app.dummyServiceVar.doResult();
            return false;
        }
    },
    addCountryCodesSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start addCountryCodesSuccess');

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

                            if (!this.refreshOnAddCountryCodesSuccess()) {
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

            console.debug('End addCountryCodesSuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addCountryCodesSuccess() failed: " + e.toString(), e);
        }
    },
    onShow: function() {
        try {
            console.debug('NewCountryCodeCtrl.onShow: start');

            app.dlgLoading.setParameter(app.dummyServiceVar, this.lbxMain);
            if (!this.controller) {
                app.alert(this.getDictionaryItem("ERROR_MSG_BY_UNKNOWN_CONTROLLER"));
            } else {
                if (!this.controller.checkGrantAdminAddCountry()) {
                    throw this.getDictionaryItem("NO_GRANT_FOR_ADD_COUNTRYCODES");
                }
            }

            console.debug('NewCountryCodeCtrl.onShow: end');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onShow() failed: " + e.toString(), e);
            app.closeCataloItem(this.controller);
        }
    },
    onStart: function(inPage) {
        try {
            console.debug('NewCountry.onStart: Begin');

            console.debug('NewCountry.onStart: End');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onStart() failed: " + e.toString(), e);
        }
    },
    btnAddCatalogItemClick: function(inSender) {
        try {
            console.debug('Start btnAddCatalogItemClick');

            app.dlgLoading.setParameter(this.addCatalogItem, this.pnlCatalogTitle);

            if (this.addCountryCodes.canUpdate()) {
                this.addCountryCodes.update();
            } else {
                app.toastError(this.getDictionaryItem("ERROR_MSG_ADD_COUNTRYCODES_NO_SUCCESS_BY_EXECUTE"));
            }

            console.debug('End btnAddCatalogItemClick');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddCatalogItemClick() failed: " + e.toString(), e);
        }
    },
    checkGrantAdminError: function(inSender, inError) {
        try {
            console.debug('Start checkGrantAdminError');

            throw this.getDictionaryItem("NO_GRANT_FOR_ADD_COUNTRYCODES");
        } catch (e) {
            this.controller.handleExceptionByCtrl(e.toString(), e);
            app.closeCountryCodes(this.controller);
        }
    },
    checkGrantAdminResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start checkGrantAdminResult');

            console.debug('End checkGrantAdminResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".checkGrantAdminResult() failed: " + e.toString(), e);
        }
    },
    checkGrantAdminSuccess: function(inSender, inDeprecated) {
        var by_check_grant = 0;
        var success = 0;
        var msg = "";

        try {
            console.debug('Start checkGrantAdminSuccess');

            success = this.varResultByCheckGrantAdmin.getValue('success');

            if (success == 1) {
                app.dummyServiceVar.doRequest();

                if (!this.controller.clearWizard()) {
                    throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
                }

                if (!this.controller.loadLookupData()) {
                    throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_LOOUPDATA");
                }

                this.controller.onInitControls();

                app.dummyServiceVar.doResult();
            } else {
                by_check_grant = 1;
                throw this.getDictionaryItem("NO_GRANT_FOR_ADD_COUNTRYCODES");
            }
            console.debug('End checkGrantAdminSuccess');
        } catch (e) {
            app.dummyServiceVar.doResult();
            if (by_check_grant === 0) {
                msg = this.name + ".checkGrantAdminSuccess() failed: " + e.toString();
            } else {
                msg = e.toString();
            }
            this.controller.handleExceptionByCtrl(msg, e);
            app.closeCountryCodes(this.controller);
        }
    },
    _end: 0
});