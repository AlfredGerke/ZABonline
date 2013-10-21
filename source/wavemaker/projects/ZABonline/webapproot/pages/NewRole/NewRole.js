dojo.declare("NewRole", wm.Page, {
	"i18n": true,
	start: function() {
		
	},
	"preferredDevice": "desktop",
    onResultByNewRedording: function() {},
    onSuccessByNewRecording: function(success) {},
    start: function() {
        try {
            console.debug('start: start');

            app.dlgLoading.setParameter(app.dummyServiceVar, this.wizNewRole);

            this.controller = new NewRoleCtrl(app, this);

            console.debug('start: end');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
        }
    },
	wizNewRoleCancelClick: function(inSender) {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewRoleCancelClick() failed: " + e.toString(), e);
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

                app.dummyServiceVar.doResult();
            }

            console.debug('onShow: end');
        } catch (e) {
            app.dummyServiceVar.doResult();
            this.controller.handleExceptionByCtrl(this.name + ".onShow() failed: " + e.toString(), e, 1);
            app.closeWizard();
        }		
	},
	onStart: function( inPage) {
        try {
            console.debug('onStart: Begin');

            console.debug('onStart: End');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onStart() failed: " + e.toString(), e);
        }		
	},
	wizNewRoleCanchange: function(inSender, inChangeInfo) {
        var success = this.controller.onWizNewRoleCanChange(inSender, inChangeInfo);		
	},
	onEscapeKey: function() {
        try {
            app.closeWizard();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onEscapeKey() failed: " + e.toString(), e);
        }		
	},
	wizNewRoleChange: function(inSender, inIndex) {
        try {
            switch (inIndex) {
            case 1:
                break;
            case 2:
                this.controller.setSummeryInfo();
                break;
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewRoleChange() failed: " + e.toString(), e);
        }		
	},
	wizNewRoleDoneClick: function(inSender) {
        try {
            app.closeWizard(this.getDictionaryItem("CONFIRMATION_DO_CLOSE_ADD_ROLE"), this.getDictionaryItem("CONFIRMATION_DLG_TITLE_FOR_CLOSE_ADDUSER"));
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".wizNewRoleDoneClick() failed: " + e.toString(), e);
        }		
	},
	btnAddDataClick: function(inSender) {
        try {
            console.debug('Start btnAddDataClick');

            app.dlgLoading.setParameter(this.addRole, this.wizNewRole);

            if (this.addRole.canUpdate()) {
                this.addRole.update();
            } else {
                app.toastError(this.getDictionaryItem("ERROR_MSG_ADD_ROLE_NO_SUCCESS_BY_EXECUTE"));
            }

            console.debug('End btnAddDataClick');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".btnAddDataClick() failed: " + e.toString(), e);
        }		
	},
	addRoleResult: function(inSender, inDeprecated) {
        try {
            console.debug('Start addRoleResult');

            console.debug('End addRoleResult');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addRoleResult() failed: " + e.toString(), e);
        }		
	},
	addRoleError: function(inSender, inError) {
        try {
            console.debug('Start addRoleError');

            var errMsg = this.getDictionaryItem("ERROR_MSG_ERROR_BY_ADDROLE") + inError.message;

            app.toastError(errMsg);

            console.debug('End addRoleError');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".addRoleError() failed: " + e.toString(), e);
        }		
	},
    refreshOnAddRoleSuccess: function() {
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
            this.controller.handleExceptionByCtrl(this.name + ".refreshOnAddRoleSuccess() failed: " + e.toString(), e, -1);
            app.dummyServiceVar.doResult();
            return false;
        }
    },    
	addRoleSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start addRoleSuccess');

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

                            if (!this.refreshOnAddRoleSuccess()) {
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
            this.controller.handleExceptionByCtrl(this.name + ".addRoleSuccess() failed: " + e.toString(), e);
        }		
	},
	_end: 0
});