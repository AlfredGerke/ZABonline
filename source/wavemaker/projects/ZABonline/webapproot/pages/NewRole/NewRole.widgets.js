NewRole.widgets = {
	addRole: ["wm.ServiceVariable", {"inFlightBehavior":"dontExecute","operation":"addRoleData","service":"ZABonlineAdminService"}, {"onError":"addRoleError","onResult":"addRoleResult","onSuccess":"addRoleSuccess"}, {
		input: ["wm.ServiceInput", {"type":"addRoleDataInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"edtRoleCaption.dataValue","targetProperty":"aCaption"}, {}],
				wire1: ["wm.Wire", {"expression":undefined,"source":"edtRoleDesc.dataValue","targetProperty":"aDescription"}, {}],
				wire2: ["wm.Wire", {"expression":undefined,"source":"cbxIsAdmin.dataValue","targetProperty":"aIsAdmin"}, {}],
				wire3: ["wm.Wire", {"expression":undefined,"source":"cbxSetup.dataValue","targetProperty":"aSetup"}, {}],
				wire4: ["wm.Wire", {"expression":undefined,"source":"cbxMembers.dataValue","targetProperty":"aMembers"}, {}],
				wire5: ["wm.Wire", {"expression":undefined,"source":"cbxActivityRecording.dataValue","targetProperty":"aActivityRecording"}, {}],
				wire6: ["wm.Wire", {"expression":undefined,"source":"cbxSEPA.dataValue","targetProperty":"aSEPA"}, {}],
				wire7: ["wm.Wire", {"expression":undefined,"source":"cbxBilling.dataValue","targetProperty":"aBilling"}, {}],
				wire8: ["wm.Wire", {"expression":undefined,"source":"cbxImport.dataValue","targetProperty":"aImport"}, {}],
				wire9: ["wm.Wire", {"expression":undefined,"source":"cbxExport.dataValue","targetProperty":"aExport"}, {}],
				wire10: ["wm.Wire", {"expression":undefined,"source":"cbxReferenceData.dataValue","targetProperty":"aReferenceData"}, {}],
				wire11: ["wm.Wire", {"expression":undefined,"source":"cbxReporting.dataValue","targetProperty":"aReporting"}, {}],
				wire12: ["wm.Wire", {"expression":undefined,"source":"cbxMisc.dataValue","targetProperty":"aMisc"}, {}],
				wire13: ["wm.Wire", {"expression":undefined,"source":"cbxFileressource.dataValue","targetProperty":"aFileresource"}, {}]
			}]
		}]
	}],
	varResultByInsert: ["wm.Variable", {"isList":true,"type":"de.zabonline.srv.Results.ProcResults"}, {}, {
		binding: ["wm.Binding", {}, {}, {
			wire: ["wm.Wire", {"expression":undefined,"source":"addRole","targetProperty":"dataSet"}, {}]
		}]
	}],
	navCallRole: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layRole","targetProperty":"layer"}, {}]
			}]
		}]
	}],
	navCallProperties: ["wm.NavigationCall", {}, {}, {
		input: ["wm.ServiceInput", {"type":"gotoLayerInputs"}, {}, {
			binding: ["wm.Binding", {}, {}, {
				wire: ["wm.Wire", {"expression":undefined,"source":"layProperties","targetProperty":"layer"}, {}]
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
	bxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		wizNewRole: ["wm.WizardLayers", {}, {"onCancelClick":"wizNewRoleCancelClick","onDoneClick":"wizNewRoleDoneClick","oncanchange":"wizNewRoleCanchange","onchange":"wizNewRoleChange"}, {
			layRole: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Rolle","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlRoleLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlRoleData: ["wm.FancyPanel", {"title":"Bezeichnung"}, {}, {
						edtRoleCaption: ["wm.Text", {"caption":"Rolle","dataValue":undefined,"displayValue":"","required":true}, {}],
						edtRoleDesc: ["wm.Text", {"caption":"Beschreibung","dataValue":undefined,"displayValue":"","width":"640px"}, {}]
					}]
				}]
			}],
			layProperties: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Eigenschaften","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlPropertiesLayout: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					pnlRoleProperties: ["wm.FancyPanel", {"title":"Berechtigungen"}, {}, {
						pnlPropertiesToolbar: ["wm.Panel", {"_classes":{"domNode":["toolbar"]},"height":"36px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
							mnuProperties: ["wm.DojoMenu", {"fullStructure":[{"label":"Bearbeiten","separator":undefined,"defaultLabel":"Bearbeiten","iconClass":undefined,"imageList":undefined,"idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[{"label":"Alle auswählen","separator":undefined,"defaultLabel":"Alle auswählen","iconClass":"app_silkIconList_88","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"","children":[]},{"label":"Auswahl aufheben","separator":undefined,"defaultLabel":"Auswahl aufheben","iconClass":"app_silkIconList_21","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[]},{"label":"Auswahl umkehren","separator":undefined,"defaultLabel":"Auswahl umkehren","iconClass":"app_silkIconList_6","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[]}]}],"localizationStructure":{},"openOnHover":true}, {}]
						}],
						cbxIsAdmin: ["wm.Checkbox", {"caption":"Administrator","displayValue":false}, {}],
						pnlNonAdminGrants: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
							pnlGrants: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"180px"}, {}, {
								cbxMembers: ["wm.Checkbox", {"caption":"Mitglieder","displayValue":false}, {}],
								cbxActivityRecording: ["wm.Checkbox", {"caption":"Leistungsdaten","displayValue":false}, {}],
								cbxSEPA: ["wm.Checkbox", {"caption":"SEPA","displayValue":false}, {}],
								cbxBilling: ["wm.Checkbox", {"caption":"Abrechnung","displayValue":false}, {}],
								cbxImport: ["wm.Checkbox", {"caption":"Import","displayValue":false}, {}],
								cbxExport: ["wm.Checkbox", {"caption":"Export","displayValue":false}, {}],
								cbxReferenceData: ["wm.Checkbox", {"caption":"Stammdaten","displayValue":false}, {}],
								cbxReporting: ["wm.Checkbox", {"caption":"Berichte","displayValue":false}, {}],
								cbxMisc: ["wm.Checkbox", {"caption":"Verschiedenes","displayValue":false}, {}],
								cbxFileressource: ["wm.Checkbox", {"caption":"Dateien","displayValue":false}, {}],
								cbxSetup: ["wm.Checkbox", {"caption":"Setup","displayValue":false}, {}]
							}]
						}]
					}]
				}]
			}],
			laySummery: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Zusammenfassung","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
				pnlSummery: ["wm.Panel", {"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}, {
					pnlSummeryDetailTop: ["wm.Panel", {"height":"90%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
						pnlSummeryDetailRole: ["wm.FancyPanel", {"title":"Rolle","width":"50%"}, {}, {
							btnGotoRole: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallRole"}],
							lblSumInfoCaption: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoDesc: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}],
						pnlSummeryDetailProperties: ["wm.FancyPanel", {"title":"Eigenschaften","width":"50%"}, {}, {
							btnGotoProperties: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallProperties"}],
							lblSumInfoIsAdmin: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoMember: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoActivityRecording: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoSEPA: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoBilling: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoImport: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoExport: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoReferenceData: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoReports: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoMisc: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoFileresources: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoSetup: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
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