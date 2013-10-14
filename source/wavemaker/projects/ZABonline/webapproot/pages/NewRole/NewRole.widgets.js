NewRole.widgets = {
	bxMain: ["wm.Layout", {"horizontalAlign":"left","verticalAlign":"top"}, {}, {
		wizNewRole: ["wm.WizardLayers", {}, {}, {
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
							mnuProperties: ["wm.DojoMenu", {"fullStructure":[{"label":"Bearbeiten","separator":undefined,"defaultLabel":"Bearbeiten","iconClass":undefined,"imageList":undefined,"idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[{"label":"Alle auswählen","separator":undefined,"defaultLabel":"Alle auswählen","iconClass":"app_silkIconList_88","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[]},{"label":"Auswahl aufheben","separator":undefined,"defaultLabel":"Auswahl aufheben","iconClass":"app_silkIconList_21","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[]},{"label":"Auswahl umkehren","separator":undefined,"defaultLabel":"Auswahl umkehren","iconClass":"app_silkIconList_6","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[]}]}],"localizationStructure":{}}, {}]
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
								cbxReporting: ["wm.Checkbox", {"caption":"Reports","displayValue":false}, {}],
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
							btnGotoRole: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallTenant"}],
							lblSumInfoMandant: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoDesc: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
						}],
						pnlSummeryDetailProperties: ["wm.FancyPanel", {"title":"Eigenschaften","width":"50%"}, {}, {
							btnGotoProperties: ["wm.Button", {"caption":"Ändern","margin":"4","width":"100%"}, {"onclick":"navCallRelated"}],
							lblSumInfoFactoryDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoPersonDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoContactDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}],
							lblSumInfoAddressDatasheet: ["wm.Label", {"caption":"","height":"20px","padding":"4","width":"100%"}, {}]
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