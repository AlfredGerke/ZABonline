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
    onGetResultBySearch: function() {
    },
    btnFindCountryClick: function(inSender) {
       this.controller.showSearch(this, "{kind: 1000,  mode: 0, find: 'countryCode', callback: 'onGetResultBySearch'}");		
	},
	_end: 0
});