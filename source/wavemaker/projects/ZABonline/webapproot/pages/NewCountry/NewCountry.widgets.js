NewCountry.widgets = {
	lbxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		pnlCatalogTitle: ["wm.FancyPanel", {"title":"Länderkennung"}, {}, {
			pnlClient: ["wm.Panel", {"height":"100%","horizontalAlign":"left","margin":"5","padding":"5","verticalAlign":"top","width":"100%"}, {}, {
				pnlDetail: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					edtCountryCode: ["wm.Text", {"caption":"Landkürzel","captionSize":"110px","dataValue":undefined,"displayValue":"","helpText":"Kürzel nach ISO 3166","maxChars":"3","required":true,"width":"185px"}, {}],
					edtCountryDesc: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}],
					edtCurrencyCode: ["wm.Text", {"caption":"Währungskürzel","captionSize":"110px","dataValue":undefined,"displayValue":"","helpText":"Kürzel nach ISO 4217","maxChars":"3","required":true,"width":"185px"}, {}],
					edtCurrencyDesc: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}],
					edtAreaCode: ["wm.Number", {"caption":"Ländervorwahl","captionSize":"110px","dataValue":undefined,"displayValue":"","required":true,"width":"185px"}, {}],
					cbxDoNotDelete: ["wm.Checkbox", {"caption":"Löschen sperren","captionSize":"110px","displayValue":false,"helpText":"Wenn ausgewählt kann der Eintrag nicht mehr gelöscht werden","width":"150px"}, {}],
					edtDescription: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":"","maxChars":"2000","required":true}, {}]
				}],
				pnlBottom: ["wm.Panel", {"height":"33px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"bottom","width":"100%"}, {}, {
					btnAddCatalogItem: ["wm.Button", {"caption":"Eintrag aufnehmen","margin":"4","width":"100%"}, {}]
				}]
			}]
		}]
	}]
}