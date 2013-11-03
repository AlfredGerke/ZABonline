SearchPage.widgets = {
	startSearchByDB: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"startSearchByDb","service":"Miscellaneous"}, {}, {
		input: ["wm.ServiceInput", {"type":"startSearchByDbInputs"}, {}]
	}],
	varResultBySearch: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"startSearchByDB","targetProperty":"dataSet"}, {}]
		}]
	}],
	varTenantId: ["wm.Variable", {"type":"NumberData"}, {}],
	lbxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		pnlTop: ["wm.Panel", {"height":"48px","horizontalAlign":"left","verticalAlign":"middle","width":"100%"}, {}, {
			edtExpression: ["wm.Text", {"caption":"Suchen","dataValue":undefined,"displayValue":"","helpText":"Suche starten","placeHolder":"Suchwort eingeben","width":"300%"}, {}]
		}],
		pnlDetail: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
			gridResult: ["wm.DojoGrid", {"height":"100%","localizationStructure":{},"minDesktopHeight":60,"singleClickEdit":true}, {}]
		}],
		pnlBottum: ["wm.Panel", {"height":"36px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
			navResult: ["wm.DataNavigator", {"border":"0","height":"33px","width":"100%"}, {}]
		}]
	}]
}