dojo.declare("SearchPage", wm.Page, {
    "i18n": true,
    "preferredDevice": "desktop",
    onResultByNewRedording: function() {},
    onSuccessByNewRecording: function(success) {},
    start: function() {
        try {
            console.debug('SearchPage.start: start');

           

            this.controller = new SearchPageCtrl(app, this);

            console.debug('SearchPage.start: end');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".start() failed: " + e.toString(), e);
        }
    },
    onShow: function() {
        try {
            console.debug('SearchPage.onShow: start');

            app.dlgLoading.setParameter(app.dummyServiceVar, this.lbxMain);
            
            if (!this.controller) {
                app.alert(this.getDictionaryItem("ERROR_MSG_BY_UNKNOWN_CONTROLLER"));
            } else {
                app.dummyServiceVar.doRequest();

                if (!this.controller.loadLookupData()) {
                    throw this.getDictionaryItem("ERROR_MSG_BY_CONTROLLER_LOOUPDATA");
                }
                app.dummyServiceVar.doResult();
            }

            console.debug('SearchPage.onShow: end');
        } catch (e) {
            app.dummyServiceVar.doResult();
            this.controller.handleExceptionByCtrl(this.name + ".onShow() failed: " + e.toString(), e, 1);
            app.closeSearchPage(this.controller);
        }
    },
    onStart: function(inPage) {
        try {
            console.debug('SearchPage.onStart: Begin');
            console.debug('SearchPage.onStart: End');
        } catch (e) {
            this.controller.handleExceptionByCtrl(this.name + ".onStart() failed: " + e.toString(), e);
        }
    },
    _end: 0
});