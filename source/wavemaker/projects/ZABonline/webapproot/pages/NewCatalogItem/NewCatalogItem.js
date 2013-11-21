dojo.declare("NewCatalogItem", wm.Page, {
    "i18n": true,
    "preferredDevice": "desktop",
    start: function() {
        try {
            console.debug('NewCatalogItem.start: start');

            this.controller = new NewCatalogItemCtrl(app, this);

            console.debug('NewCatalogItem.start: end');
        } catch (e) {
            if (this.controller) {
                this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
            } else {
                console.error(this.name + ".start() failed: " + e.toString());
            }
        }
    },
    onShow: function() {
        try {
            console.debug('NewCatalogItem.onShow: start');

            app.dlgLoading.setParameter(app.dummyServiceVar, this.lbxMain);
            if (!this.controller) {
                app.alert(this.getDictionaryItem("ERROR_MSG_BY_UNKNOWN_CONTROLLER"));
            } else {
                app.dummyServiceVar.doRequest();

                if (!this.controller.clearWizard()) {
                    throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
                }

                if (!this.controller.loadLookupData()) {
                    throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_LOOUPDATA");
                }

                this.controller.onInitControls();

                app.dummyServiceVar.doResult();
            }

            console.debug('NewCatalogItem.onShow: end');
        } catch (e) {
            app.dummyServiceVar.doResult();
            this.controller.handleExceptionByCtrl(this.name + ".onShow() failed: " + e.toString(), e, 1);
            app.closeCataloItem(this.controller);
        }
    },
    onStart: function(inPage) {
        try {
            console.debug('NewCatalogItem.onStart: Begin');

            console.debug('NewCatalogItem.onStart: End');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onStart() failed: " + e.toString(), e);
        }
    },
    onGetResultBySearch: function() {},
    btnFindCountryClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'countryCode', callback: 'onGetResultBySearch'}");
    },
    addCatalogItemError: function(inSender, inError) {
        try {
            console.debug('Start addCatalogItemError');

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADD_CATALOGITEM") + inError.message;

            app.toastError(errMsg);

            console.debug('End addCatalogItemError');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addCatalogItemError() failed: " + e.toString(), e);
        }
    },
    addCatalogItemResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start addCatalogItemResult');

            console.debug('End addCatalogItemResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addCatalogItemResult() failed: " + e.toString(), e);
        }
    },
    refreshOnAddCatalogItemSuccess: function() {
        try {
            app.dummyServiceVar.doRequest();

            if (!this.controller.clearWizard(0)) {
                throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_CLEARWIZARD");
            }

            app.dummyServiceVar.doResult();
            return true;
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".refreshOnAddCatalogItemSuccess() failed: " + e.toString(), e, -1);
            app.dummyServiceVar.doResult();
            return false;
        }
    },
    addCatalogItemSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start addCatalogItemSuccess');

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

                            if (!this.refreshOnAddCatalogItemSuccess()) {
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

            console.debug('End addCatalogItemSuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addCatalogItemSuccess() failed: " + e.toString(), e);
        }
    },
    btnAddCatalogItemClick: function(inSender) {
        try {
            console.debug('Start btnAddCatalogItemClick');

            app.dlgLoading.setParameter(this.addCatalogItem, this.pnlCatalogTitle);

            if (this.addCatalogItem.canUpdate()) {
                this.addCatalogItem.update();
            } else {
                app.toastError(this.getDictionaryItem("ERROR_MSG_ADD_CATALOGITEM_NO_SUCCESS_BY_EXECUTE"));
            }

            console.debug('End btnAddCatalogItemClick');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddCatalogItemClick() failed: " + e.toString(), e);
        }
    },
    _end: 0
});