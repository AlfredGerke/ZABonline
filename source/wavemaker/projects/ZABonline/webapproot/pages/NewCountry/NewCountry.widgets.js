NewCountry.widgets = {
	addCountryCodes: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"addCountryCodes","service":"CatalogService"}, {}, {
		input: ["wm.ServiceInput", {"type":"addCountryCodesInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"varTenantId.dataValue","targetProperty":"aTenantId"}, {}],
				wire1: ["wm.Wire", {"expression":undefined,"source":"edtCountryCode.dataValue","targetProperty":"aCountryCode"}, {}],
				wire2: ["wm.Wire", {"expression":undefined,"source":"edtCountryDesc.dataValue","targetProperty":"aCountryDesc"}, {}],
				wire3: ["wm.Wire", {"expression":undefined,"source":"edtCurrencyCode.dataValue","targetProperty":"aCurrencyCode"}, {}],
				wire4: ["wm.Wire", {"expression":undefined,"source":"edtCurrencyDesc.dataValue","targetProperty":"aCurrencyDesc"}, {}],
				wire5: ["wm.Wire", {"expression":undefined,"source":"edtAreaCode.dataValue","targetProperty":"aAreaCode"}, {}],
				wire6: ["wm.Wire", {"expression":undefined,"source":"edtDescription.dataValue","targetProperty":"aDesc"}, {}],
				wire7: ["wm.Wire", {"expression":undefined,"source":"cbxDoNotDelete.dataValue","targetProperty":"aDoNotDelete"}, {}]
			}]
		}]
	}],
	varTenantId: ["wm.Variable", {"type":"NumberData"}, {}],
	varResultByInsert: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"addCountryCodes","targetProperty":"dataSet"}, {}]
		}]
	}],
	checkGrantAdmin: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"checkGrantAdmin","service":"ZABonlineGrantsService"}, {}, {
		input: ["wm.ServiceInput", {"type":"checkGrantAdminInputs"}, {}]
	}],
	varResultByCheckGrandAdmin: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.SuccessInfo"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"app.checkGrantAdmin","targetProperty":"dataSet"}, {}]
		}]
	}],
	lbxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		pnlCatalogTitle: ["wm.FancyPanel", {"title":"Länderkennung"}, {}, {
			pnlClient: ["wm.Panel", {"height":"100%","horizontalAlign":"left","margin":"5","padding":"5","verticalAlign":"top","width":"100%"}, {}, {
				pnlDetail: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					edtCountryCode: ["wm.Text", {"caption":"Landkürzel","captionSize":"110px","dataValue":undefined,"displayValue":"","helpText":"Kürzel nach ISO 3166","maxChars":"3","required":true,"width":"185px"}, {}],
					edtCountryDesc: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}],
					edtCurrencyCode: ["wm.Text", {"caption":"Währungskürzel","captionSize":"110px","dataValue":undefined,"displayValue":"","helpText":"Kürzel nach ISO 4217","maxChars":"3","required":true,"width":"185px"}, {}],
					edtCurrencyDesc: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}],
					edtAreaCode: ["wm.Number", {"caption":"Ländervorwahl","captionSize":"110px","dataValue":undefined,"displayValue":"","required":true,"width":"185px"}, {}],
					edtDescription: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":"","maxChars":"2000","required":true}, {}],
					cbxDoNotDelete: ["wm.Checkbox", {"caption":"Löschen sperren","captionSize":"110px","displayValue":false,"helpText":"Wenn ausgewählt kann der Eintrag nicht mehr gelöscht werden","width":"150px"}, {}]
				}],
				pnlBottom: ["wm.Panel", {"height":"33px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"bottom","width":"100%"}, {}, {
					btnAddCatalogItem: ["wm.Button", {"caption":"Eintrag aufnehmen","margin":"4","width":"100%"}, {}]
				}]
			}]
		}]
	}]
}