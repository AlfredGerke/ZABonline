NewFactory.widgets = {
	navCallFactory: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layFactory","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallFactoryData: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layDatasheet","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallAddress: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layAddress","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallContact: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layContact","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallBank: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layBank","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallInfo: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layInfo","targetProperty":"layer"}, {}]
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
	navCallPhoto: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layPhoto","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	varTenantId: ["wm.Variable", {"type":"NumberData"}, {}],
	srvVarContactPartnerLookUp: ["wm.ServiceVariable", {"autoUpdate":true,"inFlightBehavior":"dontExecute","loadingDialog":"","operation":"getLookupContactPartnerByTenant","service":"ZABonlineDB"}, {}, {
		input: ["wm.ServiceInput", {"type":"getLookupContactPartnerByTenantInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"varTenantId.dataValue","targetProperty":"TenantId"}, {}]
			}]
		}]
	}],
	varCodeByResult: ["wm.Variable", {"isList":true,"json":"[\n\t{\n\t\t\"name\": \"Gerke\", \n\t\t\"dataValue\": \"Alfred\"\n\t}, \n\t{\n\t\t\"name\": \"Gerke2\", \n\t\t\"dataValue\": \"Alfred2\"\n\t}, \n\t{\n\t\t\"name\": \"Gerke3\", \n\t\t\"dataValue\": \"Alfred3\"\n\t}\n]","type":"EntryData"}, {}],
	varFilename: ["wm.Variable", {"type":"StringData"}, {}],
	varResultByInsert: ["wm.Variable", {"dataSet":"","isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}],
	varUniqueFilename: ["wm.Variable", {"type":"StringData"}, {}],
	varUploadPhoto: ["wm.Variable", {"type":"FileUploadDownload.WMFile"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"fileUpload.variable.name","targetProperty":"name"}, {}],
			wire1: ["wm.Wire", {"expression":undefined,"source":"fileUpload.variable.path","targetProperty":"path"}, {}]
		}]
	}],
	varUploadPhotoResponse: ["wm.Variable", {"type":"com.wavemaker.runtime.server.FileUploadResponse"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"fileUpload.variable.error","targetProperty":"error"}, {}]
		}]
	}],
	addFactory: ["wm.ServiceVariable", {"inFlightBehavior":"dontExecute","loadingDialog":"","operation":"sampleJavaOperation","service":"FactoryService"}, {"onError":"addFactoryError","onResult":"addFactoryResult","onSuccess":"addFactorySuccess"}, {
		input: ["wm.ServiceInput", {"type":"sampleJavaOperationInputs"}, {}]
	}],
	lbxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		wizNewFactory: ["wm.WizardLayers", {"defaultLayer":0}, {"onCancelClick":"wizNewFactoryCancelClick","onDoneClick":"wizNewFactoryDoneClick","oncanchange":"wizNewFactoryCanchange","onchange":"wizNewFactoryChange"}, {
			layFactory: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Betrieb","horizontalAlign":"left","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlFactoryLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlFactoryBasicData: ["wm.FancyPanel", {"height":"156px","title":"Betrieb"}, {}, {
						pnlIdentBasisData: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
							edtFactoryNumber: ["wm.Text", {"caption":"Betriebsnummer","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}],
							edtFactory: ["wm.Text", {"caption":"Betrieb","captionSize":"110px","dataValue":undefined,"displayValue":"","required":true,"width":"400px"}, {}],
							edtDescription1: ["wm.Text", {"caption":"Beschreibung","captionSize":"110px","dataValue":undefined,"displayValue":"","width":"640px"}, {}],
							edtDescription2: ["wm.Text", {"caption":" ","captionSize":"110px","dataValue":undefined,"displayValue":"","width":"640px"}, {}],
							edtDescription3: ["wm.Text", {"caption":" ","captionSize":"110px","dataValue":undefined,"displayValue":"","width":"640px"}, {}]
						}]
					}],
					pnlNoContactPartner: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
						cbxNoContactPartner: ["wm.Checkbox", {"caption":"kein Ansprechpartner","captionAlign":"left","captionPosition":"right","captionSize":"150px","displayValue":false,"emptyValue":"false","height":"100%","width":"160px"}, {"onchange":"cbxNoContactPartnerChange"}]
					}],
					pnlContactPerson: ["wm.FancyPanel", {"freeze":false,"title":"Ansprechpartner"}, {}, {
						pnlBasisContactPersonData: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
							cboContactPartnerIdPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
								cboContactPartnerId: ["wm.SelectMenu", {"allowNone":true,"caption":"Ansprechpartner","captionSize":"110px","dataField":"c0","dataType":"com.zabonlinedb.data.output.GetLookupContactPartnerByTenantRtnType","displayField":"contactPartner","displayValue":"","emptyValue":"null"}, {"onchange":"cboContactPartnerIdChange"}, {
									binding: ["wm.Binding", {}, {}, {
										wire: ["wm.Wire", {"expression":undefined,"source":"srvVarContactPartnerLookUp","targetProperty":"dataSet"}, {}]
									}]
								}],
								btnFindPerson: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindPersonClick"}],
								btnAddPerson: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddPersonClick"}]
							}],
							edtContactPersonFirstname: ["wm.Text", {"caption":"Vorname","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}],
							edtContactPersonName: ["wm.Text", {"caption":"Name","captionSize":"110px","dataValue":undefined,"displayValue":"","required":true}, {}],
							edtContactPersonPhone: ["wm.Text", {"caption":"Telefon","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}],
							edtContactPersonMail: ["wm.Text", {"caption":"eMail","captionSize":"110px","dataValue":undefined,"displayValue":""}, {}]
						}]
					}]
				}]
			}],
			layDatasheet: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Betriebsdaten","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoDatasheet: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoDatasheet: ["wm.Checkbox", {"caption":"kein Datenblatt","captionAlign":"left","captionPosition":"right","captionSize":"150px","displayValue":false,"emptyValue":"false","height":"100%","width":"150px"}, {"onchange":"cbxNoDatasheetChange"}]
				}],
				pnlDatasheetLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlFactoryDatasheet: ["wm.FancyPanel", {"freeze":false,"height":"107px","title":"Datenblatt"}, {}, {
						pnlFactoryDataIdentDetail: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
							cboDatasheetIdPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
								cboDatasheetId: ["wm.SelectMenu", {"allowNone":true,"caption":"Datenblatt","dataSet":"","dataType":"com.zabonlinedb.data.output.GetLookupPersonByMarriageRtnType","displayValue":"","emptyValue":"null"}, {"onchange":"cboDatasheetIdChange"}],
								btnFindDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindDataSheetClick"}],
								btnAddDatasheet: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddDatasheetClick"}]
							}],
							edtDatasheetShortDesc: ["wm.Text", {"caption":"Name","dataValue":undefined,"displayValue":""}, {}],
							edtDatasheetLongDesc: ["wm.Text", {"caption":"Beschreibung","dataValue":undefined,"displayValue":"","width":"640px"}, {}]
						}]
					}],
					pnlFactoryDetailData: ["wm.FancyPanel", {"title":"Betriebsdaten"}, {}]
				}]
			}],
			layAddress: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Adressdaten","horizontalAlign":"left","margin":"5","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoAddressData: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoAddressData: ["wm.Checkbox", {"caption":"keine Adressdaten","captionAlign":"left","captionPosition":"right","captionSize":"150px","displayValue":false,"emptyValue":"false","height":"100%","width":"150px"}, {"onchange":"cbxNoAddressDataChange"}]
				}],
				pnlAddressLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlBasicAddressData: ["wm.FancyPanel", {"freeze":false,"title":"Adresse"}, {}, {
						cboAddressTypePanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"405px"}, {}, {
							cboAddressType: ["wm.SelectMenu", {"caption":"Addresstyp","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupAddressTypeByCountryRtnType","displayField":"caption","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"app.addressTypeData","targetProperty":"dataSet"}, {}],
									wire1: ["wm.Wire", {"expression":undefined,"source":"app.addressTypeData.id","targetProperty":"dataValue"}, {}]
								}]
							}],
							btnFindAddressType: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindAddresstypeClick"}],
							btnAddAddressType: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddAddressTypeClick"}]
						}],
						edtDistrict: ["wm.Text", {"caption":"Ortsteil","dataValue":undefined,"displayValue":""}, {}],
						pnlFmtCityData: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
							edtZIPCode: ["wm.Text", {"caption":"PLZ","dataValue":undefined,"displayValue":"","regExp":"","required":true,"width":"178px"}, {}],
							edtCity: ["wm.Text", {"caption":"Stadt","captionSize":"50px","dataValue":undefined,"displayValue":"","required":true,"width":"221px"}, {}]
						}],
						edtPostOffice: ["wm.Text", {"caption":"Postfach","dataValue":undefined,"displayValue":""}, {}],
						pnlFmtStreetData: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
							edtStreet: ["wm.Text", {"caption":"Straße","dataValue":undefined,"displayValue":"","required":true}, {}],
							edtStreetAddressFrom: ["wm.Text", {"caption":"von","captionSize":"50px","dataValue":undefined,"displayValue":"","required":true,"width":"100px"}, {}],
							edtStreetAddressTo: ["wm.Text", {"caption":"bis","captionSize":"50px","dataValue":undefined,"displayValue":"","width":"100px"}, {}]
						}],
						cbxIsPostOfficeAddress: ["wm.Checkbox", {"caption":"Postanschrift","displayValue":false,"emptyValue":"false"}, {}],
						cbxIsPrivateAddress: ["wm.Checkbox", {"caption":"Privat","displayValue":false,"emptyValue":"false"}, {}]
					}]
				}]
			}],
			layContact: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Kontaktdaten","horizontalAlign":"left","margin":"5","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoContactData: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoContactData: ["wm.Checkbox", {"caption":"keine Kontaktdaten","captionAlign":"left","captionPosition":"right","captionSize":"150px","displayValue":false,"emptyValue":"false","height":"100%","width":"150px"}, {"onchange":"cbxNoContactDataChange"}]
				}],
				pnlContactLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlBasicContactData: ["wm.FancyPanel", {"title":"Kontakt"}, {}, {
						cboContactTypePanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboContactType: ["wm.SelectMenu", {"caption":"Kontakttyp","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupContactTypeByCountryRtnType","displayField":"caption","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"app.contactTypeData","targetProperty":"dataSet"}, {}],
									wire1: ["wm.Wire", {"expression":undefined,"source":"app.contactTypeData.id","targetProperty":"dataValue"}, {}]
								}]
							}],
							btnFindContactType: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindContactTypeClick"}],
							btnAddContactType: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddContactTypeClick"}]
						}],
						cboAreaCodePanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboAreaCode: ["wm.SelectMenu", {"allowNone":true,"caption":"Gebietscode","dataField":"areacode","dataType":"com.zabonlinedb.data.output.GetLookupAreaCodeRtnType","displayField":"areacode","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"app.areaCodeData","targetProperty":"dataSet"}, {}],
									wire1: ["wm.Wire", {"expression":undefined,"source":"app.areaCodeData.areacode","targetProperty":"dataValue"}, {}]
								}]
							}],
							btnFindAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindAreaCodeClick"}],
							btnAddAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddAreaCodeClick"}]
						}],
						edtTel: ["wm.Text", {"caption":"Telefon","dataValue":undefined,"displayValue":""}, {}],
						edtFax: ["wm.Text", {"caption":"Fax","dataValue":undefined,"displayValue":""}, {}],
						edtWWW: ["wm.Text", {"caption":"www","dataValue":undefined,"displayValue":""}, {}],
						edtEmail: ["wm.Text", {"caption":"eMail","dataValue":undefined,"displayValue":""}, {}],
						edtSkype: ["wm.Text", {"caption":"Skype","dataValue":undefined,"displayValue":""}, {}],
						edtMessanger: ["wm.Text", {"caption":"Messanger","dataValue":undefined,"displayValue":""}, {}]
					}]
				}]
			}],
			layBank: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Bankinformationen","horizontalAlign":"left","margin":"5","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoBankInfo: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoBankInfo: ["wm.Checkbox", {"caption":"keine Bankinformationen","captionAlign":"left","captionPosition":"right","captionSize":"170px","displayValue":false,"emptyValue":"false","height":"100%","width":"170px"}, {"onchange":"cbxNoBankInfoChange"}]
				}],
				pnlBankLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlBasicBankData: ["wm.FancyPanel", {"title":"Bank"}, {}, {
						edtDepositor: ["wm.Text", {"caption":"Kontoinhaber","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtKTO: ["wm.Text", {"caption":"Kontonummer","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtBLZ: ["wm.Text", {"caption":"Bankleitzahl","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtIBAN: ["wm.Text", {"caption":"IBAN","dataValue":undefined,"displayValue":""}, {}],
						edtBIC: ["wm.Text", {"caption":"BIC","dataValue":undefined,"displayValue":""}, {}]
					}]
				}]
			}],
			layInfo: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Information","horizontalAlign":"left","margin":"5","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoInfo: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoInfo: ["wm.Checkbox", {"caption":"keine Informationen","captionAlign":"left","captionPosition":"right","captionSize":"170px","displayValue":false,"emptyValue":"false","height":"100%","width":"170px"}, {"onchange":"cbxNoInfoChange"}]
				}],
				pnlInfoLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlFreeText: ["wm.FancyPanel", {"title":"Freitext"}, {}, {
						edtDescription: ["wm.RichText", {"height":"100%"}, {}]
					}]
				}]
			}],
			layPhoto: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Bildmaterial","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoPhoto: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoPhoto: ["wm.Checkbox", {"caption":"kein Bildmaterial","captionAlign":"left","captionPosition":"right","captionSize":"170px","displayValue":false,"emptyValue":"false","height":"100%","width":"170px"}, {"onchange":"cbxNoPhotoChange"}]
				}],
				pnlPhotoLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlChoosePhoto: ["wm.FancyPanel", {"innerHorizontalAlign":"center","title":"Datei auswählen"}, {}, {
						picPhoto: ["wm.Picture", {"aspect":"v","height":"213px","margin":"5,0,0,0","source":"resources/images/logos/symbol_questionmark.png","width":"165px"}, {}],
						fileUpload: ["wm.DojoFileUpload", {"buttonCaption":"Laden...","height":"30px","layoutKind":"top-to-bottom","padding":"5,0,0,0","useList":false,"width":"159px"}, {"onSuccess":"fileUploadSuccess"}, {
							input: ["wm.ServiceInput", {"type":"uploadFileInputs"}, {}]
						}],
						lblPhotoName: ["wm.Label", {"margin":"5,0,0,0","padding":"4","width":"159px"}, {}, {
							format: ["wm.DataFormatter", {}, {}],
							binding: ["wm.Binding", {}, {}, {
								wire: ["wm.Wire", {"expression":"\"Datei: \" + ${varFilename.dataValue}","targetProperty":"caption"}, {}]
							}]
						}],
						lblResponseInfo: ["wm.Label", {"_classes":{"domNode":["wm_FontColor_BrightRed"]},"height":"84px","padding":"4","singleLine":false,"width":"159px"}, {}, {
							binding: ["wm.Binding", {}, {}, {
								wire: ["wm.Wire", {"expression":undefined,"source":"varUploadPhotoResponse.error","targetProperty":"caption"}, {}]
							}]
						}]
					}]
				}]
			}],
			laySummery: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Zusammenfassen","horizontalAlign":"left","margin":"5","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlSummery: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlSummeryDetailTop: ["wm.Panel", {"height":"90%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
						pnlFactorySumAll: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"25%"}, {}, {
							pnlSummeryDetailFactory: ["wm.FancyPanel", {"title":"Betrieb"}, {}, {
								btnGotoFactory: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallFactory"}],
								lblSumInfoFactoryNumber: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoFactory: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoDescription1: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}, {
									format: ["wm.DataFormatter", {}, {}]
								}],
								lblSumInfoDescription2: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoDescription3: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoContactPartner: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoCPFirstname: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoCPName: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoCPTel: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoCPEmail: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
							}],
							pnlSummeryDetailFactoryData: ["wm.FancyPanel", {"title":"Betriebsdaten"}, {}, {
								btnGotoFactoryData: ["wm.Button", {"caption":"Ändern","margin":"4","mobileHeight":"32%","width":"100%"}, {"onclick":"navCallFactoryData"}],
								lblSumInfoDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoDatasheetName: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
								lblSumInfoDatasheetDesc: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
							}]
						}],
						pnlSummeryDetailAddress: ["wm.FancyPanel", {"title":"Adresse","width":"25%"}, {}, {
							btnGotoAddress: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallAddress"}],
							lblSumInfoAddressType: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoDistrict: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoZIPCode: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoCity: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoPostOffice: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoStreet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoStreetAddressFrom: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoStreetAddressTo: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoIsPostOfficeAddress: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfosPrivateAddress: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}],
						pnlSummeryDetailContact: ["wm.FancyPanel", {"title":"Kontakt","width":"25%"}, {}, {
							btnGotoContact: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallContact"}],
							lblSumInfoContactType: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoAreaCode: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoTel: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoFax: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoWWW: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoEmail: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoSkype: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoMessanger: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}],
						pnlSummeryDetailBank: ["wm.FancyPanel", {"title":"Bank","width":"25%"}, {}, {
							btnGotoBank: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallBank"}],
							lblSumInfoDepositor: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoKTO: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoBLZ: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoIBAN: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoBIC: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}]
					}],
					pnlSummeryDetailBottom: ["wm.Panel", {"height":"10%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
						btnAddAddressBookItem: ["wm.Button", {"caption":"Daten aufnehmen","margin":"4","width":"100%"}, {"onclick":"btnAddAddressBookItemClick"}]
					}]
				}]
			}]
		}]
	}]
}