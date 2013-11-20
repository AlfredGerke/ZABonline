NewCatalogItem.widgets = {
	varTenantVar: ["wm.Variable", {"type":"NumberData"}, {}],
	addCatalogItem: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"addCatalogItem","service":"CatalogService"}, {"onError":"addCatalogItemError","onResult":"addCatalogItemResult","onSuccess":"addCatalogItemSuccess"}, {
		input: ["wm.ServiceInput", {"type":"addCatalogItemInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"varTenantVar.dataValue","targetProperty":"aTenantId"}, {}],
				wire1: ["wm.Wire", {"expression":undefined,"source":"edtContryCode.dataValue","targetProperty":"aCountryId"}, {}],
				wire2: ["wm.Wire", {"expression":undefined,"source":"edtCaption.dataValue","targetProperty":"aCaption"}, {}],
				wire3: ["wm.Wire", {"expression":undefined,"source":"edtDescription.dataValue","targetProperty":"aDesc"}, {}],
				wire4: ["wm.Wire", {"expression":undefined,"source":"varCatalog.dataValue","targetProperty":"catalog"}, {}],
				wire5: ["wm.Wire", {"expression":undefined,"source":"cbxDoNotDelete.dataValue","targetProperty":"aDoNotDelete"}, {}]
			}]
		}]
	}],
	varResultByInsert: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"addCatalogItem","targetProperty":"dataSet"}, {}]
		}]
	}],
	varCatalog: ["wm.Variable", {"type":"StringData"}, {}],
	lbxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		pnlCatalogTitel: ["wm.FancyPanel", {"title":"Katalog"}, {}, {
			pnlClient: ["wm.Panel", {"height":"100%","horizontalAlign":"left","margin":"5","padding":"5","verticalAlign":"top","width":"100%"}, {}, {
				pnlDetail: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					selectMenu1Panel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"373px"}, {}, {
						edtContryCode: ["wm.SelectMenu", {"caption":"Länderkennung","captionSize":"110px","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupCountryRtnType","dataValue":undefined,"displayField":"countryCode","displayValue":"","helpText":undefined,"required":true}, {}, {
							binding: ["wm.Binding", {}, {}, {
								wire: ["wm.Wire", {"expression":undefined,"source":"app.countryCodeData","targetProperty":"dataSet"}, {}]
							}]
						}],
						btnFindCountry: ["wm.Button", {"caption":undefined,"height":"100%","hint":"Sprachkennung suchen","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","width":"35px"}, {"onclick":"btnFindCountryClick"}],
						btnAddCountryCode: ["wm.Button", {"caption":undefined,"height":"100%","hint":"Länderkennung einfügen","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","width":"35px"}, {}]
					}],
					cbxDoNotDelete: ["wm.Checkbox", {"caption":"Löschen sperren","captionSize":"110px","displayValue":false,"helpText":"Wenn ausgewählt kann der Eintrag nicht mehr gelöscht werden","width":"150px"}, {}],
					edtCaption: ["wm.Text", {"caption":"Bezeichnung","captionSize":"110px","dataValue":undefined,"displayValue":"","maxChars":"254","required":true}, {}],
					edtDescription: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":"","maxChars":"2000","required":true}, {}]
				}],
				pnlBottom: ["wm.Panel", {"height":"60px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"bottom","width":"100%"}, {}, {
					btnAddCatalogItem: ["wm.Button", {"caption":"Eintrag aufnehmen","margin":"4","width":"100%"}, {"onclick":"btnAddCatalogItemClick"}]
				}]
			}]
		}]
	}]
}