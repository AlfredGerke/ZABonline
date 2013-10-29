NewTenant.widgets = {
	navCallTenant: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layTenant","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallRelated: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layRelated","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallSession: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"laySession","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallSummery: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"laySummery","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	addTenant: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"addTenantData","service":"ZABonlineAdminService"}, {"onError":"addTenantError","onResult":"addTenantResult","onSuccess":"addTenantSuccess"}, {
		input: ["wm.ServiceInput", {"type":"addTenantDataInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"edtTenantCaption.dataValue","targetProperty":"aCaption"}, {}],
				wire1: ["wm.Wire", {"expression":undefined,"source":"edtTenantDesc.dataValue","targetProperty":"aDescription"}, {}],
				wire6: ["wm.Wire", {"expression":undefined,"source":"edtSessionIdleTime.dataValue","targetProperty":"aSessionIdletime"}, {}],
				wire7: ["wm.Wire", {"expression":undefined,"source":"edtSessionLifetime.dataValue","targetProperty":"aSessionLifetime"}, {}],
				wire8: ["wm.Wire", {"expression":undefined,"source":"app.countryLookupData.id","targetProperty":"aCountryCodeId"}, {}]
			}]
		}]
	}],
	varResultByInsert: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"addTenant","targetProperty":"dataSet"}, {}]
		}]
	}],
	varTenantId: ["wm.Variable", {"type":"NumberData"}, {}],
	lbxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top","width":"1427px"}, {}, {
		wizNewTenant: ["wm.WizardLayers", {}, {"onCancelClick":"wizNewTenantCancelClick","onDoneClick":"wizNewTenantDoneClick","oncanchange":"wizNewTenantCanchange","onchange":"wizNewTenantChange"}, {
			layTenant: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Mandant","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlTenantLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlTenantData: ["wm.FancyPanel", {"title":"Mandant"}, {}, {
						edtTenantCaption: ["wm.Text", {"caption":"Manadant","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtTenantDesc: ["wm.Text", {"caption":"Beschreibung","dataValue":undefined,"displayValue":"","width":"640px"}, {}]
					}]
				}]
			}],
			layRelated: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Zugehörig","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlRelatedLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlRelatedData: ["wm.FancyPanel", {"title":"Verknüpfungen"}, {}, {
						cboFactoryDatasheetPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboFactoryDatasheet: ["wm.SelectMenu", {"caption":"Betriebsdaten","dataValue":undefined,"displayValue":""}, {}],
							btnFindFactoryDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindFactoryDatasheetClick"}],
							btnAddFactoryDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddFactoryDatasheetClick"}]
						}],
						cboPersonDatasheetPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboPersonDatasheet: ["wm.SelectMenu", {"caption":"Personendaten","dataValue":undefined,"displayValue":""}, {}],
							btnFindPersonDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindPersonDatasheetClick"}],
							btnAddPersonDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddPersonDatasheetClick"}]
						}],
						cboContactDatasheetPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboContactDatasheet: ["wm.SelectMenu", {"caption":"Kontaktdaten","dataValue":undefined,"displayValue":""}, {}],
							btnFindContactDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindContactDatasheetClick"}],
							btnAddContactDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddContactDatasheetClick"}]
						}],
						cboAddressDatasheetPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboAddressDatasheet: ["wm.SelectMenu", {"caption":"Adressdaten","dataValue":undefined,"displayValue":""}, {}],
							btnFindAddressDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindAddressDatasheetClick"}],
							btnAddAddressDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddAddressDatasheetClick"}]
						}]
					}]
				}]
			}],
			laySession: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Eigenschaften","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlSessionLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlSessionData: ["wm.FancyPanel", {"title":"Sitzung"}, {}, {
						cboAreaCodePanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboAreaCode: ["wm.SelectMenu", {"allowNone":true,"caption":"Ländercode","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupCountryRtnType","displayField":"countryCode","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire1: ["wm.Wire", {"expression":undefined,"source":"app.countryLookupData","targetProperty":"dataValue"}, {}],
									wire: ["wm.Wire", {"expression":undefined,"source":"app.countryLookupData","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindAreaCodeClick"}],
							btnAddAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddAreaCodeClick"}]
						}],
						edtSessionIdleTime: ["wm.Number", {"caption":"Ruhezeit","dataValue":undefined,"displayValue":"","helpText":"Ruhezeit in Minuten","required":true}, {}],
						edtSessionLifetime: ["wm.Number", {"caption":"Lebenszeit","dataValue":undefined,"displayValue":"","helpText":"Lebenszeit in Tagen","required":true}, {}]
					}]
				}]
			}],
			laySummery: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Zusammenfassung","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlSummery: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlSummeryDetailTop: ["wm.Panel", {"height":"90%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
						pnlSummeryDetailMandant: ["wm.FancyPanel", {"title":"Mandant","width":"33%"}, {}, {
							btnGotoMandant: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallTenant"}],
							lblSumInfoMandant: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoDesc: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}],
						pnlSummeryDetailRelated: ["wm.FancyPanel", {"title":"Zugehörigkeit","width":"34%"}, {}, {
							btnGotoRelated: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallRelated"}],
							lblSumInfoFactoryDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoPersonDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoContactDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoAddressDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}],
						pnlSummeryDetailSession: ["wm.FancyPanel", {"title":"Sitzung","width":"33%"}, {}, {
							btnGotoSitzung: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallSession"}],
							lblSumInfoAreaCode: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoIdleTime: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoLifetime: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}]
					}],
					pnlSummeryDetailBottom: ["wm.Panel", {"height":"10%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
						btnAddData: ["wm.Button", {"caption":"Daten aufnehmen","margin":"4","width":"100%"}, {"onclick":"btnAddDataClick"}]
					}]
				}]
			}]
		}]
	}]
}