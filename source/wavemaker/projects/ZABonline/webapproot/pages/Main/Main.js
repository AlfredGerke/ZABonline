dojo.declare("Main", wm.Page, {
    "preferredDevice": "desktop",
    "i18n": true,
    onCloseSessionByDBCall: function(inError, inMessage) {
        console.debug('Start Main.onCloseSessionByDBCall');
        console.debug('inMessage: ' + inMessage);

        this.controller.showWarningOnConnect(this.getDictionaryItem(inMessage));

        console.debug('End Main.onCloseSessionByDBCall');
    },
    onCloseSession: function() {
        console.debug('Start Main.onCloseSession');

        this.controller.showWarningOnConnect(this.getDictionaryItem("ERROR_MSG_REGISTER_SESSION_FAILD"));

        console.debug('End Main.onCloseSession');
    },
    onCloseWarningOnStart: function() {
        if (app.globalData.globalDataFound()) {
            this.dlgWarningOnStart.hide();
            this.disconnect(this.conIdByOnCloseWarningOnStart);
        }
    },
    onEnableGUI: function() {
        try {
            console.debug('Start Main.onEnableGUI');

            if (!this.controller.enableGUI()) {
                throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_ENABLEGUI");
            }

            console.debug('End Main.onEnableGUI');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onEnableGUI() failed: " + e.toString(), e);
            this.templateLogoutVar.update();
        }
    },
    setGlobalData: function() {
        var loginUsername = this.templateUsernameVar.getValue("dataValue");

        app.initGlobalData(loginUsername);
    },
    start: function() {
        try {
            console.debug('Start Main.start');

            app.dlgLoading.setParameter(this.registerSessionVar, this.lbxMain);

            this.controller = new MainCtrl(app, this);

            console.debug('End Main.start');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
        }
    },
    onStart: function(inPage) {
        try {
            console.debug('Start Main.onStart');

            console.debug('End Main.onStart');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onStart() failed: " + e.toString(), e);
        }
    },
    onShow: function() {
        try {
            console.debug('Start Main.onShow');

            if (!this.controller) {
                dojo.publish("session-expiration");
            } else {}

            console.debug('End Main.onShow');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onShow() failed: " + e.toString(), e);
        }
    },
    templateUsernameVarSuccess: function(inSender, inDeprecated) {
        try {
            app.initGlobalData(inDeprecated);
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".templateUsernameVarSuccess() failed: " + e.toString(), e);
        }
    },
    navCallNewAddressBeforeUpdate: function(inSender, ioInput) {
        try {
            if (!app.globalData.globalDataFound()) {
                this.setGlobalData();
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".navCallNewAddressBeforeUpdate() failed: " + e.toString(), e);
        }
    },
    dlgWarningOnStartClose: function(inSender, inWhy) {
        try {
            if (!app.globalData.globalDataFound()) {
                this.lbxMain.setDisabled(false);
                this.templateLogoutVar.update();
            }
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".dlgWarningOnStartClose() failed: " + e.toString(), e);
        }
    },
    dlgWarningOnStartButton2Click: function(inSender, inButton, inText) {
        try {
            if (!this.conIdByOnCloseWarningOnStart) {
                this.conIdByOnCloseWarningOnStart = this.connect(this, "onEnableGUI", this, "onCloseWarningOnStart");
            }
            this.templateUsernameVar.update();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".dlgWarningOnStartButton2Click() failed: " + e.toString(), e);
        }
    },
    dlgWarningOnConnectClose: function(inSender, inWhy) {
        try {
            this.templateLogoutVar.update();
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".dlgWarningOnConnectClose() failed: " + e.toString(), e);
        }
    },
    mnuMainAdresseClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("NewAddress", "Neuaufnahme Adresse");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainAdresseClick() failed: " + e.toString(), e);
        }
    },
    mnuMainBetriebClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("NewFactory", "Neuaufnahme Betrieb");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainAdresseClick() failed: " + e.toString(), e);
        }
    },
    mnuMainMitgliedClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("NewMember", "Neuaufnahme Mitglied");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainAdresseClick() failed: " + e.toString(), e);
        }
    },
    /* nach diesem Aufruf wird ein weiteres OnClick-Ereignis ausgelöst, welches die SerciceVariabel für den CheckGrant-Service startet (s. Propertyeditor) */
    mnuMainFelderClick: function(inSender /*,args*/ ) {
        app.controller.startAdminGrantedModuleByChannel("main-add-field");
    },
    /* nach diesem Aufruf wird ein weiteres OnClick-Ereignis ausgelöst, welches die SerciceVariabel für den CheckGrant-Service startet (s. Propertyeditor) */
    mnuMainTabelleClick: function(inSender /*,args*/ ) {
        app.controller.startAdminGrantedModuleByChannel("main-add-table");
    },
    /* nach diesem Aufruf wird ein weiteres OnClick-Ereignis ausgelöst, welches die SerciceVariabel für den CheckGrant-Service startet (s. Propertyeditor) */
    mnuMainStrukturClick: function(inSender /*,args*/ ) {
        app.controller.startAdminGrantedModuleByChannel("main-add-schema");
    },
    closeSessionVarError: function(inSender, inError) {
        this.controller.startErrOnCloseDlg(inError, this.getDictionaryItem("ERROR_MSG_ERROR_CLOSE_SESSION"));
    },
    templateLogoutVarError: function(inSender, inError) {
        console.debug('Start Main.templateLogoutVarError');

        this.controller.handleErrorByCtrl(this.getDictionaryItem("ERROR_MSG_ERROR_ON_LOGOUT"), inError);

        console.debug('End Main.templateLogoutVarError');
    },
    invalidateSessionVarError: function(inSender, inError) {
        console.debug('Start Main.invalidateSessionVarError');

        console.warning('Fehler beim schließen einer Sitzung!');

        console.debug('End Main.invalidateSessionVarError');
    },
    /* nach diesem Aufruf wird ein weiteres OnClick-Ereignis ausgelöst, welches die SerciceVariabel für den CheckGrant-Service startet (s. Propertyeditor) */
    mnuMainMandantClick: function(inSender /*,args*/ ) {
        app.controller.startAdminGrantedModuleByChannel("main-add-tenant");
    },
    /* nach diesem Aufruf wird ein weiteres OnClick-Ereignis ausgelöst, welches die SerciceVariabel für den CheckGrant-Service startet (s. Propertyeditor) */
    mnuMainBenutzerClick: function(inSender /*,args*/ ) {
        app.controller.startAdminGrantedModuleByChannel("main-add-user");
    },
    mnuMainBenutzerrolleClick: function(inSender /*,args*/ ) {
        app.controller.startAdminGrantedModuleByChannel("main-add-role");
    },
    mnuMainAkteClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("NewDossier", "Neuaufnahme Akte");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainAkteClick() failed: " + e.toString(), e);
        }
    },
    mnuMainNotizenClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("NewTicket", "Neuaufnahme Notiz");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainNotizenClick() failed: " + e.toString(), e);
        }
    },
    mnuMainVorgangClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("NewProcess", "Neuaufnahme Vorgang");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainVorgangClick() failed: " + e.toString(), e);
        }
    },
    mnuMainImpressumClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("ShowImpressum", "Impressum und Datenschutzerkärung");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainImpressumClick() failed: " + e.toString(), e);
        }
    },
    mnuMainKontaktClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("ShowContact", "Kontakt");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainKontaktClick() failed: " + e.toString(), e);
        }
    },
    mnuMainUeber_die_AnwendungClick: function(inSender /*,args*/ ) {
        try {
            app.controller.showWizard("ShowAbout", "&Uuml;ber die Anwendung");
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".mnuMainUeber_die_AnwendungClick() failed: " + e.toString(), e);
        }
    },
    _end: 0
});