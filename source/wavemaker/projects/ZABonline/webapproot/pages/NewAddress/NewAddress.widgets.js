NewAddress.widgets = {
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
	marriagePartnerLookupData: ["wm.ServiceVariable", {"autoUpdate":true,"inFlightBehavior":"dontExecute","loadingDialog":"","operation":"getLookupPersonByMarriage","service":"ZABonlineDB"}, {"onSuccess":"marriagePartnerLookupDataSuccess"}, {
		input: ["wm.ServiceInput", {"type":"getLookupPersonByMarriageInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":"1","targetProperty":"married"}, {}],
				wire1: ["wm.Wire", {"expression":undefined,"source":"varTenantId.dataValue","targetProperty":"TenantId"}, {}]
			}]
		}]
	}],
	varTenantId: ["wm.Variable", {"type":"NumberData"}, {}],
	testProcVar: ["wm.ServiceVariable", {"inFlightBehavior":"dontExecute","operation":"testProc","service":"addressBookService"}, {"onError":"testProcVarError","onResult":"testProcVarResult","onSuccess":"testProcVarSuccess"}, {
		input: ["wm.ServiceInput", {"type":"testProcInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"edtBirthday.dataValue","targetProperty":"aDate"}, {}]
			}]
		}]
	}],
	varResultByInsert: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"addAddressBookItem","targetProperty":"dataSet"}, {}]
		}]
	}],
	varCodeByResult: ["wm.Variable", {"isList":true,"json":"[\n\t{\n\t\t\"name\": \"Gerke\", \n\t\t\"dataValue\": \"Alfred\"\n\t}, \n\t{\n\t\t\"name\": \"Gerke2\", \n\t\t\"dataValue\": \"Alfred2\"\n\t}, \n\t{\n\t\t\"name\": \"Gerke3\", \n\t\t\"dataValue\": \"Alfred3\"\n\t}\n]","type":"EntryData"}, {}],
	navCallPerson: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"source":"layPerson","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallAddress: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"source":"layAddress","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallContact: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"source":"layContact","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallBank: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"source":"layBank","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	addAddressBookItem: ["wm.ServiceVariable", {"inFlightBehavior":"dontExecute","operation":"addAddressBookItem","service":"addressBookService"}, {"onError":"addAddressBookItemError","onResult":"addAddressBookItemResult","onSuccess":"addAddressBookItemSuccess"}, {
		input: ["wm.ServiceInput", {"type":"addAddressBookItemInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"edtBirthday.dataValue","targetProperty":"aDayOfBirth"}, {}],
				wire1: ["wm.Wire", {"expression":undefined,"source":"edtMarriedSince.dataValue","targetProperty":"aMarriedSince"}, {}],
				wire2: ["wm.Wire", {"expression":"!${cbxNoAddressData.dataValue}","source":false,"targetProperty":"aAddressDataPresent"}, {}],
				wire3: ["wm.Wire", {"expression":undefined,"source":"cboAddressType.dataValue","targetProperty":"aAddressTypeId"}, {}],
				wire4: ["wm.Wire", {"expression":undefined,"source":"edtAltSalutation.dataValue","targetProperty":"aAltsalutation"}, {}],
				wire5: ["wm.Wire", {"expression":undefined,"source":"cboAreaCode.dataValue","targetProperty":"aAreaCode"}, {}],
				wire6: ["wm.Wire", {"expression":undefined,"source":"edtBIC.dataValue","targetProperty":"aBIC"}, {}],
				wire7: ["wm.Wire", {"expression":"!${cbxNoBankInfo.dataValue}","source":false,"targetProperty":"aBankDataPresent"}, {}],
				wire8: ["wm.Wire", {"expression":undefined,"source":"edtBLZ.dataValue","targetProperty":"aBlzFmt"}, {}],
				wire9: ["wm.Wire", {"expression":undefined,"source":"edtCity.dataValue","targetProperty":"aCity"}, {}],
				wire10: ["wm.Wire", {"expression":"!${cbxNoContactData.dataValue}","source":false,"targetProperty":"aContactDataPresent"}, {}],
				wire11: ["wm.Wire", {"expression":undefined,"source":"cboContactType.dataValue","targetProperty":"aContactTypeId"}, {}],
				wire12: ["wm.Wire", {"expression":undefined,"source":"edtDepositor.dataValue","targetProperty":"aDepositor"}, {}],
				wire13: ["wm.Wire", {"expression":undefined,"source":"edtDistrict.dataValue","targetProperty":"aDistrict"}, {}],
				wire14: ["wm.Wire", {"expression":undefined,"source":"edtEmail.dataValue","targetProperty":"aEmail"}, {}],
				wire15: ["wm.Wire", {"expression":undefined,"source":"edtFax.dataValue","targetProperty":"aFaxFmt"}, {}],
				wire16: ["wm.Wire", {"expression":undefined,"source":"edtFirstName.dataValue","targetProperty":"aFirstName"}, {}],
				wire17: ["wm.Wire", {"expression":undefined,"source":"edtIBAN.dataValue","targetProperty":"aIBAN"}, {}],
				wire18: ["wm.Wire", {"expression":undefined,"source":"edtDescription.dataValue","targetProperty":"aInfo"}, {}],
				wire19: ["wm.Wire", {"expression":"!${cbxNoInfo.dataValue}","source":false,"targetProperty":"aInfoDataPresent"}, {}],
				wire20: ["wm.Wire", {"expression":undefined,"source":"cbxIsMarried.dataValue","targetProperty":"aIsMarried"}, {}],
				wire21: ["wm.Wire", {"expression":undefined,"source":"cbxIsPostOfficeAddress.dataValue","targetProperty":"aIsPostAddress"}, {}],
				wire22: ["wm.Wire", {"expression":undefined,"source":"cbxIsPrivateAddress.dataValue","targetProperty":"aIsPrivateAddress"}, {}],
				wire23: ["wm.Wire", {"expression":undefined,"source":"cbxIsPrivate.dataValue","targetProperty":"aIsPrivatePerson"}, {}],
				wire24: ["wm.Wire", {"expression":undefined,"source":"edtKTO.dataValue","targetProperty":"aKtoFmt"}, {}],
				wire25: ["wm.Wire", {"expression":undefined,"source":"edtMarrigePartnerFirstName.dataValue","targetProperty":"aMarriagePartnerFirstName"}, {}],
				wire26: ["wm.Wire", {"expression":undefined,"source":"edtMarrigePartnerName.dataValue","targetProperty":"aMarriagePartnerName1"}, {}],
				wire27: ["wm.Wire", {"expression":undefined,"source":"cboMarrigePartnerId.dataValue","targetProperty":"aMarriedToId"}, {}],
				wire28: ["wm.Wire", {"expression":undefined,"source":"edtMessanger.dataValue","targetProperty":"aMessangerName"}, {}],
				wire29: ["wm.Wire", {"expression":undefined,"source":"edtName1.dataValue","targetProperty":"aName"}, {}],
				wire30: ["wm.Wire", {"expression":undefined,"source":"edtName2.dataValue","targetProperty":"aName2"}, {}],
				wire31: ["wm.Wire", {"expression":undefined,"source":"edtTel.dataValue","targetProperty":"aPhoneFmt"}, {}],
				wire32: ["wm.Wire", {"expression":"!${cbxNoPhoto.dataValue}","source":false,"targetProperty":"aPhotoPresent"}, {}],
				wire33: ["wm.Wire", {"expression":undefined,"source":"edtPostOffice.dataValue","targetProperty":"aPostOfficeBox"}, {}],
				wire34: ["wm.Wire", {"expression":undefined,"source":"cboSalutation.dataValue","targetProperty":"aSalutationId"}, {}],
				wire35: ["wm.Wire", {"expression":undefined,"source":"edtSkype.dataValue","targetProperty":"aSkype"}, {}],
				wire36: ["wm.Wire", {"expression":undefined,"source":"edtStreet.dataValue","targetProperty":"aStreet"}, {}],
				wire37: ["wm.Wire", {"expression":undefined,"source":"edtStreetAddressFrom.dataValue","targetProperty":"aStreetAddressFrom"}, {}],
				wire38: ["wm.Wire", {"expression":undefined,"source":"edtStreetAddressTo.dataValue","targetProperty":"aStreetAddressTo"}, {}],
				wire39: ["wm.Wire", {"expression":undefined,"source":"cboTitel.dataValue","targetProperty":"aTitelId"}, {}],
				wire40: ["wm.Wire", {"expression":undefined,"source":"edtWWW.dataValue","targetProperty":"aWWW"}, {}],
				wire41: ["wm.Wire", {"expression":undefined,"source":"edtZIPCode.dataValue","targetProperty":"aZipcode"}, {}],
				wire42: ["wm.Wire", {"expression":undefined,"source":"varFilename.dataValue","targetProperty":"aPhotoRealName"}, {}],
				wire43: ["wm.Wire", {"expression":undefined,"source":"varTenantId.dataValue","targetProperty":"aTenantId"}, {}]
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
	navCallPhoto: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layPhoto","targetProperty":"layer"}, {}]
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
	varFilename: ["wm.Variable", {"type":"StringData"}, {}],
	varUniqueFilename: ["wm.Variable", {"type":"StringData"}, {}],
	lbxMain: ["wm.Layout", {"autoScroll":false,"horizontalAlign":"left","verticalAlign":"top","width":"1274px"}, {}, {
		wizNewAddress: ["wm.WizardLayers", {"defaultLayer":0}, {"onCancelClick":"wizNewAddressCancelClick","onDoneClick":"wizNewAddressDoneClick","oncanchange":"wizNewAddressCanchange","onchange":"wizNewAddressChange"}, {
			layPerson: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Personendaten","horizontalAlign":"left","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlPersonLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlBasicData: ["wm.FancyPanel", {"height":"239px","innerLayoutKind":"left-to-right","title":"Person"}, {}, {
						pnlBasisData: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
							cboSalutationPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
								cboSalutation: ["wm.SelectMenu", {"caption":"Anrede","captionSize":"120px","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupSalutationByCountryRtnType","displayField":"caption","displayValue":""}, {"onchange":"cboSalutationChange"}, {
									binding: ["wm.Binding", {}, {}, {
										wire: ["wm.Wire", {"expression":undefined,"source":"app.salutationData","targetProperty":"dataSet"}, {}],
										wire1: ["wm.Wire", {"expression":undefined,"source":"app.salutationData.id","targetProperty":"dataValue"}, {}]
									}]
								}],
								btnFindSalutation: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindSalutationClick"}],
								btnAddSalutation: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddSalutationClick"}]
							}],
							edtAltSalutation: ["wm.Text", {"caption":"alternative Anrede","captionSize":"120px","dataValue":undefined,"displayValue":""}, {}],
							cboTitelPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
								cboTitel: ["wm.SelectMenu", {"caption":"Titel","captionSize":"120px","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupTitelByCountryRtnType","displayField":"caption","displayValue":""}, {}, {
									binding: ["wm.Binding", {}, {}, {
										wire: ["wm.Wire", {"expression":undefined,"source":"app.titelData","targetProperty":"dataSet"}, {}],
										wire1: ["wm.Wire", {"expression":undefined,"source":"app.titelData.id","targetProperty":"dataValue"}, {}]
									}]
								}],
								btnFindTitel: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindTitelClick"}],
								btnAddTitel: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddTitelClick"}]
							}],
							edtFirstName: ["wm.Text", {"caption":"Vorname","captionSize":"120px","dataValue":undefined,"displayValue":""}, {}],
							edtName1: ["wm.Text", {"caption":"Name","captionSize":"120px","dataValue":undefined,"displayValue":"","required":true}, {}],
							edtName2: ["wm.Text", {"caption":"Name 2","captionSize":"120px","dataValue":undefined,"displayValue":""}, {}],
							edtBirthday: ["wm.Date", {"caption":"Geburtstag","captionSize":"120px","dataValue":undefined,"displayValue":""}, {}],
							cbxIsPrivate: ["wm.Checkbox", {"caption":"Privat","captionSize":"120px","displayValue":false,"emptyValue":"false","width":"140px"}, {}]
						}]
					}],
					pnlMarriagePartner: ["wm.FancyPanel", {"title":"Ehepartner"}, {}, {
						cbxIsMarried: ["wm.Checkbox", {"caption":"verheiratet","displayValue":false,"emptyValue":"false"}, {"onchange":"cbxIsMarriedChange"}],
						pnlMarriagePartnerData: ["wm.Panel", {"disabled":true,"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
							edtMarriedSince: ["wm.Date", {"caption":"verheiratet seit","dataValue":undefined,"displayValue":""}, {}],
							cboMarrigePartnerIdPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
								cboMarrigePartnerId: ["wm.SelectMenu", {"allowNone":true,"caption":"Ehepartner","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupPersonByMarriageRtnType","displayField":"marriage_partner","displayValue":"","emptyValue":"null"}, {"onchange":"cboMarrigePartnerIdChange"}, {
									binding: ["wm.Binding", {}, {}, {
										wire: ["wm.Wire", {"expression":undefined,"source":"marriagePartnerLookupData","targetProperty":"dataSet"}, {}]
									}]
								}],
								btnFindPerson: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindPersonClick"}],
								btnAddPerson: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddPersonClick"}]
							}],
							edtMarrigePartnerFirstName: ["wm.Text", {"caption":"Vorname","dataValue":"","displayValue":"","emptyValue":"emptyString"}, {}],
							edtMarrigePartnerName: ["wm.Text", {"caption":"Name","dataValue":"","displayValue":"","emptyValue":"emptyString","required":true}, {}]
						}]
					}]
				}]
			}],
			layAddress: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Adressdaten","horizontalAlign":"left","margin":"5","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoAddressData: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoAddressData: ["wm.Checkbox", {"caption":"keine Adressdaten","captionAlign":"left","captionPosition":"right","captionSize":"150px","displayValue":false,"emptyValue":"false","height":"100%","width":"150px"}, {"onchange":"cbxNoAddressDataChange"}]
				}],
				pnlAddressLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlBasicAddressData: ["wm.FancyPanel", {"freeze":false,"title":"Adresse"}, {}, {
						cboAddressTypePanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							cboAddressType: ["wm.SelectMenu", {"caption":"Addresstyp","dataField":"id","dataType":"com.zabonlinedb.data.output.GetLookupAddressTypeByCountryRtnType","displayField":"caption","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"app.addressTypeData","targetProperty":"dataSet"}, {}],
									wire1: ["wm.Wire", {"expression":undefined,"source":"app.addressTypeData.id","targetProperty":"dataValue"}, {}]
								}]
							}],
							btnFindAddressType: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindAddressTypeClick"}],
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
							cboAreaCode: ["wm.SelectMenu", {"allowNone":true,"caption":"Ländervorwahl","dataField":"areacode","dataType":"com.zabonlinedb.data.output.GetLookupAreaCodeRtnType","displayField":"areacode","displayValue":""}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"app.areaCodeData","targetProperty":"dataSet"}, {}],
									wire1: ["wm.Wire", {"expression":undefined,"source":"app.areaCodeData.areacode","targetProperty":"dataValue"}, {}]
								}]
							}],
							btnFindAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindAreaCodeClick"}],
							btnAddAreaCode: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddAreadCodeClick"}]
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
			layPhoto: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Foto","horizontalAlign":"left","margin":"5","padding":"5","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlNoPhoto: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					cbxNoPhoto: ["wm.Checkbox", {"caption":"keine Foto","captionAlign":"left","captionPosition":"right","captionSize":"170px","displayValue":false,"emptyValue":"false","height":"100%","width":"170px"}, {"onchange":"cbxNoPhotoChange"}]
				}],
				pnlPhotoLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlChoosePhoto: ["wm.FancyPanel", {"innerHorizontalAlign":"center","title":"Fotodatei auswählen"}, {}, {
						picPhoto: ["wm.Picture", {"aspect":"v","height":"217px","margin":"5,0,0,0","source":"resources/images/logos/symbol_questionmark.png","width":"155px"}, {}],
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
						pnlSummeryDetailPerson: ["wm.FancyPanel", {"title":"Person","width":"25%"}, {}, {
							btnGotoPerson: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallPerson"}],
							lblSumInfoSalutation: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoAltSalutation: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoTitel: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}, {
								format: ["wm.DataFormatter", {}, {}]
							}],
							lblSumInfoFirstName: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoName: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoName2: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoBirthday: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoIsPrivat: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoIsMarried: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoMarriedSince: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoPartnerFirstName: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoPartnerName: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
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