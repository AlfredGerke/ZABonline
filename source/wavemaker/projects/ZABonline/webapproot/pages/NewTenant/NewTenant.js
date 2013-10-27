dojo.declare("NewTenant", wm.Page, {
    "preferredDevice": "desktop",
    onResultByNewRedording: function() {},
    onSuccessByNewRecording: function(success) {},    
    start: function() {

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
		
	},
	onShow: function() {
		
	},
	onStart: function( inPage) {
		
	},
	wizNewTenantCanchange: function(inSender, inChangeInfo) {
		
	},
	wizNewTenantDoneClick: function(inSender) {
		
	},
	btnAddDataClick: function(inSender) {
		
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
	_end: 0
});