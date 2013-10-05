NewUser.widgets = {
	navCallUser: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layUser","targetProperty":"layer"}, {}]
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
	navCallAdmin: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layAdmin","targetProperty":"layer"}, {}]
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
	varTenantId: ["wm.Variable", {"type":"NumberData"}, {}],
	tenantLookupVar: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","maxResults":50,"operation":"getLookupTenant","service":"ZABonlineDB"}, {}, {
		input: ["wm.ServiceInput", {"type":"getLookupTenantInputs"}, {}]
	}],
	roleLookupVar: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","maxResults":50,"operation":"getLookupRole","service":"ZABonlineDB"}, {}, {
		input: ["wm.ServiceInput", {"type":"getLookupRoleInputs"}, {}]
	}],
	personLookupVar: ["wm.ServiceVariable", {"autoUpdate":true,"inFlightBehavior":"executeLast","maxResults":50,"operation":"getLookupPersonByTenant","service":"ZABonlineDB"}, {}, {
		input: ["wm.ServiceInput", {"type":"getLookupPersonByTenantInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"varTenantId.dataValue","targetProperty":"TenantId"}, {}]
			}]
		}]
	}],
	addUser: ["wm.ServiceVariable", {"inFlightBehavior":"dontExecute","operation":"addUserData","service":"ZABonlineAdminService"}, {"onError":"addUserError","onResult":"addUserResult","onSuccess":"addUserSuccess"}, {
		input: ["wm.ServiceInput", {"type":"addUserDataInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"edtEmail.dataValue","targetProperty":"aEmail"}, {}],
				wire1: ["wm.Wire", {"expression":undefined,"source":"cbxAllowLogin.dataValue","targetProperty":"aAllowLogin"}, {}],
				wire2: ["wm.Wire", {"expression":undefined,"source":"edtName.dataValue","targetProperty":"aName"}, {}],
				wire3: ["wm.Wire", {"expression":undefined,"source":"edtFirstname.dataValue","targetProperty":"aFirstname"}, {}],
				wire4: ["wm.Wire", {"expression":undefined,"source":"edtUser.dataValue","targetProperty":"aUsername"}, {}],
				wire5: ["wm.Wire", {"expression":undefined,"source":"edtRole.dataValue","targetProperty":"aRoleId"}, {}],
				wire6: ["wm.Wire", {"expression":undefined,"source":"edtTenant.dataValue","targetProperty":"aTenantId"}, {}],
				wire7: ["wm.Wire", {"expression":undefined,"source":"edtPerson.dataValue","targetProperty":"aPersonId"}, {}]
			}]
		}]
	}],
	varResultByInsert: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"addUser","targetProperty":"dataSet"}, {}]
		}]
	}],
	lbxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		wizNewUser: ["wm.WizardLayers", {}, {"onCancelClick":"wizNewUserCancelClick","onDoneClick":"wizNewUserDoneClick","oncanchange":"wizNewUserCanchange","onchange":"wizNewUserChange"}, {
			layUser: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Benutzer","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlUserLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlUserData: ["wm.FancyPanel", {"title":"Anmeldedaten"}, {}, {
						edtUser: ["wm.Text", {"caption":"Benutzer","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtPassword: ["wm.Text", {"caption":"Passwort","dataValue":undefined,"displayValue":"","password":true,"required":true}, {}],
						edtRepeatPass: ["wm.Text", {"caption":" ","dataValue":undefined,"displayValue":"","helpText":undefined,"password":true,"placeHolder":undefined}, {}],
						edtFirstname: ["wm.Text", {"caption":"Vorname","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtName: ["wm.Text", {"caption":"Name","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtEmail: ["wm.Text", {"caption":"eMail","dataValue":undefined,"displayValue":"","required":true}, {}]
					}]
				}]
			}],
			layRelated: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Zugehörig","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlRelatedLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlRelated: ["wm.FancyPanel", {"styles":{"fontSize":""},"title":"Verknüpfungen"}, {}, {
						edtRolePanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							edtRole: ["wm.SelectMenu", {"caption":"Berechtigungen","captionSize":"110px","dataField":"pk","dataType":"com.zabonlinedb.data.output.GetLookupRoleRtnType","displayExpression":"${description}+\", (\"+${caption}+\")\"","displayField":"caption","displayValue":"","emptyValue":"null","required":true}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"roleLookupVar","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindRole: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindRoleClick"}],
							btnAddRole: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddRoleClick"}]
						}],
						edtTenantPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							edtTenant: ["wm.SelectMenu", {"caption":"Mandant","captionSize":"110px","dataField":"pk","dataType":"com.zabonlinedb.data.output.GetLookupTenantRtnType","displayExpression":"${description}+\", (\"+${caption}+\")\"","displayField":"caption","displayValue":"","emptyValue":"null","required":true}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"tenantLookupVar","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindTenant: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindMandantClick"}],
							btnAddTenant: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddMandantClick"}]
						}],
						edtPersonPanel: ["wm.Panel", {"height":"24px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"380px"}, {}, {
							edtPerson: ["wm.SelectMenu", {"caption":"Personendaten","captionSize":"110px","dataField":"personId","dataType":"com.zabonlinedb.data.output.GetLookupPersonByTenantRtnType","displayField":"nameFirstname","displayValue":"","emptyValue":"null"}, {}, {
								binding: ["wm.Binding", {}, {}, {
									wire: ["wm.Wire", {"expression":undefined,"source":"personLookupVar","targetProperty":"dataSet"}, {}]
								}]
							}],
							btnFindPerson: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":48,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnFindPersonClick"}],
							btnAddPerson: ["wm.Button", {"caption":undefined,"height":"100%","imageIndex":1,"imageList":"app.silkIconList","margin":"1","padding":"1","styles":{"fontStyle":"","fontSize":"12px","fontWeight":""},"width":"35px"}, {"onclick":"btnAddPersonClick"}]
						}]
					}]
				}]
			}],
			layAdmin: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Administration","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlAdminLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlAdmin: ["wm.FancyPanel", {"title":"Administration"}, {}, {
						cbxAllowLogin: ["wm.Checkbox", {"caption":"Anmeldung erlauben","captionSize":"130px","displayValue":true,"startChecked":true}, {}]
					}]
				}]
			}],
			laySummery: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Zusammenfassung","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlSummery: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlSummeryDetailTop: ["wm.Panel", {"height":"90%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
						pnlSummeryDetailLogin: ["wm.FancyPanel", {"title":"Anmeldedaten","width":"33%"}, {}, {
							btnGotoLogin: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallUser"}],
							lblSumInfoUser: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoFirstname: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoName: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoEmail: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}, {
								format: ["wm.DataFormatter", {}, {}]
							}]
						}],
						pnlSummeryDetailRelated: ["wm.FancyPanel", {"title":"Zugehörigkeit","width":"34%"}, {}, {
							btnGotoRelated: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallRelated"}],
							lblSumInfoRole: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoTenant: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoPerson: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}],
						pnlSummeryDetailAdmin: ["wm.FancyPanel", {"title":"Administration","width":"33%"}, {}, {
							btnGotoContact: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallAdmin"}],
							lblSumInfoAllowLogin: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
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