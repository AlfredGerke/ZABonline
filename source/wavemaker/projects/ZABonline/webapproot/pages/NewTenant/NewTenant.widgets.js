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
				wire8: ["wm.Wire", {"expression":undefined,"source":"app.countryLookupData.id","targetProperty":"aCountryCodeId"}, {}],
				wire2: ["wm.Wire", {"expression":undefined,"source":"edtSessionLifetime.dataValue","targetProperty":"aSessionLifetime"}, {}],
				wire3: ["wm.Wire", {"expression":undefined,"source":"edtMaxAttempt.dataValue","targetProperty":"aMaxAttempt"}, {}],
				wire4: ["wm.Wire", {"expression":undefined,"source":"cboAddressDatasheet.dataValue","targetProperty":"aAddressDataSheetId"}, {}],
				wire5: ["wm.Wire", {"expression":undefined,"source":"cboContactDatasheet.dataValue","targetProperty":"aContactDataSheetId"}, {}],
				wire7: ["wm.Wire", {"expression":undefined,"source":"cboPersonDatasheet.dataValue","targetProperty":"aPersonDataSheetId"}, {}],
				wire9: ["wm.Wire", {"expression":undefined,"source":"cboFactoryDatasheet.dataValue","targetProperty":"aFactoryDataSheetId"}, {}]
			}]
		}]
	}],
	varResultByInsert: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"addTenant","targetProperty":"dataSet"}, {}]
		}]
	}],
	varTenantId: ["wm.Variable", {"type":"NumberData"}, {}],
	tsLookupFactoryData: ["wm.ServiceVariable", {"autoUpdate":true,"inFlightBehavior":"executeLast","operation":"getLookupDataSheetByLabel","service":"ZABonlineDB"}, {"onSuccess":"tsLookupFactoryDataSuccess"}, {
		input: ["wm.ServiceInput", {"type":"getLookupDataSheetByLabelInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":"\"FACTORY_DATA\"","targetProperty":"label"}, {}]
			}]
		}]
	}],
	tsLookupPersonData: ["wm.ServiceVariable", {"autoUpdate":true,"inFlightBehavior":"executeLast","operation":"getLookupDataSheetByLabel","service":"ZABonlineDB"}, {"onSuccess":"tsLookupPersonDataSuccess"}, {
		input: ["wm.ServiceInput", {"type":"getLookupDataSheetByLabelInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":"\"PERSON_DATA\"","targetProperty":"label"}, {}]
			}]
		}]
	}],
	tsLookupContactData: ["wm.ServiceVariable", {"autoUpdate":true,"inFlightBehavior":"executeLast","operation":"getLookupDataSheetByLabel","service":"ZABonlineDB"}, {"onSuccess":"tsLookupContactDataSuccess"}, {
		input: ["wm.ServiceInput", {"type":"getLookupDataSheetByLabelInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":"\"CONTACT_DATA\"","targetProperty":"label"}, {}]
			}]
		}]
	}],
	tsLookupAddressData: ["wm.ServiceVariable", {"autoUpdate":true,"inFlightBehavior":"executeLast","operation":"getLookupDataSheetByLabel","service":"ZABonlineDB"}, {"onSuccess":"tsLookupAddressDataSuccess"}, {
		input: ["wm.ServiceInput", {"type":"getLookupDataSheetByLabelInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":"\"ADDRESS_DATA\"","targetProperty":"label"}, {}]
			}]
		}]
	}],
	varDSContactData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"tsLookupContactData","targetProperty":"dataSet"}, {}]
		}]
	}],
	varDSAddressData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"tsLookupAddressData","targetProperty":"dataSet"}, {}]
		}]
	}],
	varDSPersonData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"tsLookupPersonData","targetProperty":"dataSet"}, {}]
		}]
	}],
	varDSFactoryData: ["wm.Variable", {"isList":true,"type":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"tsLookupFactoryData","targetProperty":"dataSet"}, {}]
		}]
	}],
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
							cboFactoryDatasheet: ["wm.SelectMenu", {"allowNone":true,"caption":"Betriebsdaten","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType","dataValue":undefined,"displayField":"caption","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"varDSFactoryData","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindFactoryDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindFactoryDatasheetClick"}],
							btnAddFactoryDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddFactoryDatasheetClick"}]
						}],
						cboPersonDatasheetPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboPersonDatasheet: ["wm.SelectMenu", {"allowNone":true,"caption":"Personendaten","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType","dataValue":undefined,"displayField":"caption","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"varDSPersonData","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindPersonDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindPersonDatasheetClick"}],
							btnAddPersonDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddPersonDatasheetClick"}]
						}],
						cboContactDatasheetPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboContactDatasheet: ["wm.SelectMenu", {"allowNone":true,"caption":"Kontaktdaten","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType","dataValue":undefined,"displayField":"caption","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"varDSContactData","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindContactDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindContactDatasheetClick"}],
							btnAddContactDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddContactDatasheetClick"}]
						}],
						cboAddressDatasheetPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboAddressDatasheet: ["wm.SelectMenu", {"allowNone":true,"caption":"Adressdaten","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupDataSheetByLabelRtnType","dataValue":undefined,"displayField":"caption","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"varDSAddressData","targetProperty":"dataSet"}, {}]
								}]
							}],
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
							cboAreaCode: ["wm.SelectMenu", {"allowNone":true,"caption":"Länderkennung","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupCountryRtnType","dataValue":undefined,"displayField":"countryCode","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"app.countryCodeData","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindAreaCodeClick"}],
							btnAddAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddAreaCodeClick"}]
						}],
						edtSessionIdleTime: ["wm.Number", {"caption":"Ruhezeit","dataValue":undefined,"displayValue":"","helpText":"Ruhezeit in Minuten","required":true}, {}],
						edtSessionLifetime: ["wm.Number", {"caption":"Lebenszeit","dataValue":undefined,"displayValue":"","helpText":"Lebenszeit in Tagen","required":true}, {}],
						edtMaxAttempt: ["wm.Number", {"caption":"Vorschläge","dataValue":undefined,"displayValue":"","helpText":"max. Anzahl Suchwortvorschläge","required":true}, {}]
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
							lblSumInfoLifetime: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoMaxAttempt: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
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