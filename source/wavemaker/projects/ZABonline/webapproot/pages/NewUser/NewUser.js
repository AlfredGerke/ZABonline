dojo.declare("NewUser", wm.Page, {
    "i18n": true,
    "preferredDevice": "desktop",
    onResultByNewRedording: function() {},
    onSuccessByNewRecording: function(success) {},
    createSHA512OnRequireReady: function() {
        console.debug('createSHA512OnRequireReady: start');

        this.sha512 = new SHA512(0, "=");

        console.debug('createSHA512OnRequireReady: end');
    },
    start: function() {
        try {
            console.debug('start: start');

            app.dlgLoading.setParameter(app.dummyServiceVar, this.wizNewUser);

            wm.require("zabonline.crypt.SHA512", true);

            this.controller = new NewUserCtrl(app, this);

            dojo.ready(this, "createSHA512OnRequireReady");

            console.debug('start: end');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
        }
    },
    wizNewUserCancelClick: function(inSender) {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewUserCancelClick() failed: " + e.toString(), e);
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
    wizNewUserCanchange: function(inSender, inChangeInfo) {
        var success = this.controller.onWizNewUserCanChange(inSender, inChangeInfo);
    },
    onEscapeKey: function() {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onEscapeKey() failed: " + e.toString(), e);
        }
    },
    wizNewUserChange: function(inSender, inIndex) {
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
            this.controller.handleExceptionByCtrl(this.name + ".wizNewUserChange() failed: " + e.toString(), e);
        }
    },
    wizNewUserDoneClick: function(inSender) {
        try {
            app.closeWizard(this.getDictionaryItem("CONFIRMATION_DO_CLOSE_ADD_USER"), this.getDictionaryItem("CONFIRMATION_DLG_TITLE_FOR_CLOSE_ADDUSER"));
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewUserDoneClick() failed: " + e.toString(), e);
        }
    },
    refreshPerson: function() {
        this.controller.loadPersonLookupData();
    },
    refreshTenant: function() {
        this.controller.loadTenantLookupData();
    },
    refreshRole: function() {
        this.controller.loadRoleLookupData();
    },
    btnAddPersonClick: function(inSender) {
        try {
            app.controller.showWizard("NewAddress", "Neuaufnahme Adresse", true, this, "refreshPerson", "init-address-as-subdialog");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddPersonClick() failed: " + e.toString(), e);
        }
    },
    btnFindPersonClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'person', callback: 'onGetResultBySearch'}");
    },
    btnAddMandantClick: function(inSender) {
        try {
            app.controller.showWizard("NewTenant", "Neuaufnahme Mandant", true, this, "refreshTenant", "init-tenant-as-subdialog");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddMandantClick() failed: " + e.toString(), e);
        }
    },
    btnAddRoleClick: function(inSender) {
        try {
            app.controller.showWizard("NewRole", "Neuaufnahme Rolle", true, this, "refreshRole", "init-role-as-subdialog");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddRoleClick() failed: " + e.toString(), e);
        }
    },
    btnAddPerson3Click: function(inSender) {
        //code kommt noch
    },
    btnFindMandantClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'tenant', callback: 'onGetResultBySearch'}");
    },
    btnFindRoleClick: function(inSender) {
        this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'role', callback: 'onGetResultBySearch'}");
    },
    btnAddDataClick: function(inSender) {
        try {
            console.debug('Start btnAddDataClick');

            var pass = this.sha512.hex_sha512(this.edtRepeatPass.getDataValue());

            app.dlgLoading.setParameter(this.addUser, this.wizNewUser);

            this.addUser.input.setValue('aPassword', pass);

            if (this.addUser.canUpdate()) {
                this.addUser.update();
            } else {
                app.toastError(this.getDictionaryItem("ERROR_MSG_ADD_USER_NO_SUCCESS_BY_EXECUTE"));
            }

            console.debug('End btnAddDataClick');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddDataClick() failed: " + e.toString(), e);
        }
    },
    addUserResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start addUserResult');

            console.debug('End addUserResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addUserResult() failed: " + e.toString(), e);
        }
    },
    addUserError: function(inSender, inError) {
        try {
            console.debug('Start addUserError');

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADDUSER") + inError.message;

            app.toastError(errMsg);

            console.debug('End addUserError');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addUserError() failed: " + e.toString(), e);
        }
    },
    refreshOnAddUserSuccess: function() {
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
            this.controller.handleExceptionByCtrl(this.name + ".refreshOnAddUserSuccess() failed: " + e.toString(), e, -1);
            app.dummyServiceVar.doResult();
            return false;
        }
    },
    addUserSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start addUserSuccess');

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

                            if (!this.refreshOnAddUserSuccess()) {
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

            console.debug('End addUserSuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addUserSuccess() failed: " + e.toString(), e);
        }
    },
    _end: 0
});