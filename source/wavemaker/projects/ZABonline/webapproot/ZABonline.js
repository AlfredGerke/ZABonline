dojo.declare("ZABonline", wm.Application, {
	"dialogAnimationTime": 350, 
	"disableDirtyEditorTracking": false, 
	"eventDelay": 0, 
	"hintDelay": 1500, 
	"i18n": true, 
	"isLoginPageEnabled": true, 
	"isSSLUsed": false, 
	"isSecurityEnabled": true, 
	"main": "Main", 
	"manageHistory": true, 
	"manageURL": false, 
	"name": "", 
	"phoneGapLoginPage": "Login", 
	"phoneMain": "", 
	"projectSubVersion": "Alpha1", 
	"projectVersion": 1, 
	"promptChromeFrame": "chromeframe.html", 
	"sessionExpirationHandler": "nothing", 
	"studioVersion": "6.7.0.RELEASE", 
	"tabletMain": "", 
	"theme": "common.themes.sae_wireframe_1", 
	"toastPosition": "br", 
	"touchToClickDelay": 500, 
	"touchToRightClickDelay": 1500,
	"widgets": {
		silkIconList: ["wm.ImageList", {"colCount":39,"height":16,"iconCount":90,"url":"lib/images/silkIcons/silk.png","width":16}, {}], 
		addressTypeData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupAddressTypeByCountryRtnType"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.addressTypeLookupData","targetProperty":"dataSet"}, {}]
			}]
		}], 
		addressTypeLookupData: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"getLookupAddressTypeByCountry","service":"ZABonlineDB"}, {}, {
			input: ["wm.ServiceInput", {"type":"getLookupAddressTypeByCountryInputs"}, {}]
		}], 
		areaCodeData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupAreaCodeByCountryRtnType"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.areaCodeLookupData","targetProperty":"dataSet"}, {}]
			}]
		}], 
		areaCodeLookupData: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"getLookupAreaCodeByCountry","service":"ZABonlineDB"}, {}, {
			input: ["wm.ServiceInput", {"type":"getLookupAreaCodeByCountryInputs"}, {}]
		}], 
		checkGrant: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"checkGrant","service":"ZABonlineGrantsService"}, {"onError":"checkGrantError","onSuccess":"checkGrantSuccess"}, {
			input: ["wm.ServiceInput", {"type":"checkGrantInputs"}, {}, {
				binding: ["wm.Binding", {}, {}, {
					wire: ["wm.Wire", {"expression":undefined,"source":"app.grantToCheck.dataValue","targetProperty":"aGrant"}, {}]
				}]
			}]
		}], 
		checkGrantAdmin: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"checkGrantAdmin","service":"ZABonlineGrantsService"}, {"onError":"checkGrantAdminError","onSuccess":"checkGrantAdminSuccess"}, {
			input: ["wm.ServiceInput", {"type":"checkGrantAdminInputs"}, {}]
		}], 
		contactTypeData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupContactTypeByCountryRtnType"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.contactTypeLookupData","targetProperty":"dataSet"}, {}]
			}]
		}], 
		contactTypeLookupData: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"getLookupContactTypeByCountry","service":"ZABonlineDB"}, {}, {
			input: ["wm.ServiceInput", {"type":"getLookupContactTypeByCountryInputs"}, {}]
		}], 
		countryCodeData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupCountryRtnType"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.countryLookupData","targetProperty":"dataSet"}, {}]
			}]
		}], 
		countryLookupData: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"getLookupCountry","service":"ZABonlineDB"}, {}, {
			input: ["wm.ServiceInput", {"type":"getLookupCountryInputs"}, {}]
		}], 
		dlgCatalogItem: ["wm.PageDialog", {"desktopHeight":"300px","height":"300px","pageName":"NewCatalogItem","title":"Katalog erweitern","width":"420px"}, {}], 
		dlgConfirmDlg: ["wm.GenericDialog", {"button1Caption":"Ja","button1Close":true,"button2Caption":"Abbrechen","button2Close":true,"desktopHeight":"65px","height":"106px","title":"Titel","userPrompt":"asdfasdf"}, {"onButton1Click":"dlgConfirmDlgButton1Click"}], 
		dlgCountryCodes: ["wm.PageDialog", {"desktopHeight":"350px","height":"350px","pageName":"NewCountry","title":"Länderkennungen","width":"420px"}, {}], 
		dlgLoading: ["wm.LoadingDialog", {}, {}], 
		dlgSearchPage: ["wm.PageDialog", {"desktopHeight":"550px","height":"550px","pageName":"SearchPage","title":"Suchen","titlebarButtons":undefined,"width":"800px"}, {}], 
		grantToCheck: ["wm.Variable", {"type":"StringData"}, {}], 
		initData: ["wm.Variable", {"isList":true,"json":"[{\"name\":\"\",\"dataValue\":\"\"}]","type":"EntryData"}, {}], 
		resultByCheckGrant: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.SuccessInfo"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.checkGrant","targetProperty":"dataSet"}, {}]
			}]
		}], 
		resultByCheckGrantAdmin: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.SuccessInfo"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.checkGrantAdmin","targetProperty":"dataSet"}, {}]
			}]
		}], 
		salutationData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupSalutationByCountryRtnType"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.salutationLookupData","targetProperty":"dataSet"}, {}]
			}]
		}], 
		salutationLookupData: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"getLookupSalutationByCountry","service":"ZABonlineDB"}, {}, {
			input: ["wm.ServiceInput", {"type":"getLookupSalutationByCountryInputs"}, {}]
		}], 
		selectMenu: ["wm.Variable", {"type":"StringData"}, {}], 
		titelData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupTitelByCountryRtnType"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"app.titelLookupData","targetProperty":"dataSet"}, {}]
			}]
		}], 
		titelLookupData: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"getLookupTitelByCountry","service":"ZABonlineDB"}, {}, {
			input: ["wm.ServiceInput", {"type":"getLookupTitelByCountryInputs"}, {}]
		}], 
		userData: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"getInfoByUserName","service":"ZABonlineDB"}, {}, {
			input: ["wm.ServiceInput", {"type":"getInfoByUserNameInputs"}, {}]
		}], 
		wizDialog: ["wm.PageDialog", {"desktopHeight":"550px","height":"550px","hideControls":true,"title":"PageDialog","width":"800px"}, {}], 
		wizSubDialog: ["wm.PageDialog", {"desktopHeight":"550px","height":"550px","hideControls":true,"title":"PageDialog","width":"800px"}, {}]
	},
	_end: 0
});

new ZabExtender();
//
ZABonline.extend({
    start: function() {
        console.debug('Start app.start');

        this.controller = new ZabonlineCtrl(this);
        this.dummyServiceVar = new DummyServiceVariable();
        this.utils = new Utils();

        console.debug('End app.start');
    },    
    createLookupsOnRequireReady: function() {

        this.controller.createLookups();

    },
    createGlobalDataOnRequireReady: function(usr) {

        this.controller.createGlobalData(usr, "onInitLookupData");

    },
    onInitLookupData: function() {
        console.debug('Start app.onInitLookupData');

        this.controller.requireLookups();

        dojo.ready(this, "createLookupsOnRequireReady");

        console.debug('End app.onInitLookupData');
    },
    initGlobalData: function(usr) {

        this.controller.requireGlobalData(usr);

    },
    reInitWizard: function() {

        this.controller.reInitWizard();

    },
    closeWizard: function(askFor, title) {

        this.controller.closeWizard(askFor, title);

    },
    dlgConfirmDlgButton1Click: function(inSender, inButton, inText) {

        dojo.publish("close-wizard", []);

    },
    checkGrantError: function(inSender, inError) {
        console.debug('Start app.checkGrantVarError');

        this.controller.handleErrorByCtrl(this.getDictionaryItem("ERROR_MSG_EROOR_BY_CHECKGRANT_SERVICE"), inError);

        console.debug('End app.checkGrantError');
    },
    checkGrantAdminError: function(inSender, inError) {
        console.debug('Start app.checkGrantAdminError');

        this.controller.handleErrorByCtrl(this.getDictionaryItem("ERROR_MSG_EROOR_BY_CHECKGRANT_SERVICE"), inError);

        console.debug('End app.checkGrantAdminError');
    },
    checkGrantSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start app.checkGrantVarSuccess');

            var success = app.resultByCheckGrant.getValue('success');
            var selectMnu = app.selectMenu.getValue("dataValue");

            if (success == 1) {
                this.controller.executeByGrant(selectMnu);
            } else {
                throw this.getDictionaryItem("ERROR_MSG_EROOR_BY_CHECKGRANT_SERVICE");
            }

            console.debug('End Main.checkGrantVarSuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(e.toString());
        }
    },
    checkGrantAdminSuccess: function(inSender, inDeprecated) {
        try {
            console.debug('Start app.checkGrantAdminSuccess');

            var success = app.resultByCheckGrantAdmin.getValue('success');
            var selectMnu = app.selectMenu.getValue("dataValue");

            if (success == 1) {
                this.controller.executeByGrantAdmin(selectMnu);
            } else {
                throw this.getDictionaryItem("ERROR_MSG_EROOR_BY_CHECKGRANT_SERVICE");
            }

            console.debug('End Main.checkGrantVarSuccess');
        } catch (e) {
            this.controller.handleExceptionByCtrl(e.toString());
        }
    },
    closeSearchPage: function(controller){
        app.dlgSearchPage.hide();
    },
    closeCataloItem: function(controller){
        app.dlgCatalogItem.hide();
    },
    closeCountryCodes: function(controller){
        app.dlgCountryCodes.hide();        
    }
});