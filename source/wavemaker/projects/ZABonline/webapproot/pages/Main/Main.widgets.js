Main.widgets = {
	templateUsernameVar: ["wm.ServiceVariable", {"autoUpdate":true,"operation":"getUserName","service":"securityService","startUpdate":true}, {"onSuccess":"templateUsernameVarSuccess"}, {
		input: ["wm.ServiceInput", {"type":"getUserNameInputs"}, {}]
	}],
	templateLogoutVar: ["wm.LogoutVariable", {}, {"onError":"templateLogoutVarError","onSuccess":"invalidateSessionVar"}, {
		input: ["wm.ServiceInput", {"type":"logoutInputs"}, {}]
	}],
	registerSessionVar: ["wm.ServiceVariable", {"autoUpdate":true,"operation":"registerSession","service":"ZABonlineSessionMgrService","startUpdate":true}, {}, {
		input: ["wm.ServiceInput", {"type":"registerSessionInputs"}, {}]
	}],
	closeSessionVar: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"closeSession","service":"ZABonlineSessionMgrService"}, {"onError":"closeSessionVarError","onSuccess":"templateLogoutVar"}, {
		input: ["wm.ServiceInput", {"type":"closeSessionInputs"}, {}]
	}],
	invalidateSessionVar: ["wm.ServiceVariable", {"inFlightBehavior":"executeLast","operation":"invalidateSession","service":"MiscellaneousAnonym"}, {"onError":"invalidateSessionVarError"}, {
		input: ["wm.ServiceInput", {"type":"invalidateSessionInputs"}, {}]
	}],
	dlgWarningOnStart: ["wm.GenericDialog", {"button1Caption":"Beenden","button1Close":true,"button2Caption":"Einrichten","desktopHeight":"107px","height":"107px","title":"Warnung","userPrompt":"ZABonline läßt sich nicht einrichten..."}, {"onButton2Click":"dlgWarningOnStartButton2Click","onClose":"dlgWarningOnStartClose"}],
	dlgWarningOnConnect: ["wm.GenericDialog", {"desktopHeight":"75px","height":"74px","noEscape":false,"title":"Warnung","userPrompt":"Keine Berechtigung für eine Anmeldung vorhanden!"}, {"onClose":"dlgWarningOnConnectClose"}],
	dlgErrorOnLogout: ["wm.GenericDialog", {"button1Caption":"Abmelden","button1Close":true,"button2Caption":"Abbruch","button2Close":true,"desktopHeight":"65px","enterKeyIsButton":"1","height":"107px","title":"titel"}, {"onButton1Click":"closeSessionVar","onButton2Click":"templateLogoutVar","onClose":"dlgErrorOnLogout.hide"}],
	lbxMain: ["wm.Layout", {"autoScroll":false,"disabled":true,"horizontalAlign":"left","verticalAlign":"top","width":"1434px"}, {}, {
		pnlTop: ["wm.HeaderContentPanel", {"border":"0,0,2,0","height":"29px","horizontalAlign":"left","layoutKind":"left-to-right","margin":"0","padding":"2","verticalAlign":"top","width":"100%"}, {}, {
			pnlMain: ["wm.Panel", {"disabled":true,"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"470px"}, {}, {
				mnuMain: ["wm.DojoMenu", {"fullStructure":[
{"label":"Daten","separator":undefined,"defaultLabel":"Daten","iconClass":undefined,"imageList":undefined,"idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[
{"label":"Neu","separator":undefined,"defaultLabel":"Neu","iconClass":"app_silkIconList_1","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[
{"label":"Adresse","separator":undefined,"defaultLabel":"Adresse","iconClass":"app_silkIconList_85","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainAdresseClick","children":[]},
{"label":"Betrieb","separator":undefined,"defaultLabel":"Betrieb","iconClass":"app_silkIconList_58","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainBetriebClick","children":[]},
{"label":"Mitglied","separator":undefined,"defaultLabel":"Mitglied","iconClass":"app_silkIconList_54","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainMitgliedClick","children":[]},
{"label":"Akte","separator":undefined,"defaultLabel":"Akte","iconClass":"app_silkIconList_52","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainAkteClick","children":[]},
{"label":"Vorgang","separator":undefined,"defaultLabel":"Vorgang","iconClass":"app_silkIconList_45","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainVorgangClick","children":[]},
{"label":"Notizen","separator":undefined,"defaultLabel":"Notizen","iconClass":"app_silkIconList_74","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainNotizenClick","children":[]},
{"label":undefined,"separator":true,"defaultLabel":"Separator","iconClass":undefined,"imageList":undefined,"idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Benutzer","separator":undefined,"defaultLabel":"Benutzer","iconClass":"app_silkIconList_54","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"mnuMainBenutzerClick","children":[]},
{"label":"Mandant","separator":undefined,"defaultLabel":"Mandant","iconClass":"app_silkIconList_58","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"mnuMainMandantClick","children":[]},
{"label":"Benutzerrolle","separator":undefined,"defaultLabel":"Benutzerrolle","iconClass":"app_silkIconList_88","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"mnuMainBenutzerrolleClick","children":[]},
{"label":"Datenblatt","separator":undefined,"defaultLabel":"Datenblatt","iconClass":"app_silkIconList_59","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"mnuMainDatenblattClick","children":[]},
{"label":"Tabelle","separator":undefined,"defaultLabel":"Tabelle","iconClass":"app_silkIconList_82","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"mnuMainTabelleClick","children":[]}
]},
{"label":"Öffnen","separator":undefined,"defaultLabel":"Öffnen","iconClass":"app_silkIconList_0","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[
{"label":"Adressbuch","separator":undefined,"defaultLabel":"Adressbuch","iconClass":"app_silkIconList_85","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Betriebsverwaltung","separator":undefined,"defaultLabel":"Betriebsverwaltung","iconClass":"app_silkIconList_58","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Mitgliederverwaltung","separator":undefined,"defaultLabel":"Mitgliederverwaltung","iconClass":"app_silkIconList_54","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Aktenordner","separator":undefined,"defaultLabel":"Aktenordner","iconClass":"app_silkIconList_52","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":undefined,"separator":true,"defaultLabel":"Separator","iconClass":undefined,"imageList":undefined,"idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Struktur","separator":undefined,"defaultLabel":"Struktur","iconClass":"app_silkIconList_82","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"mnuMainStrukturClick","children":[]}
]},
{"label":"Druckvorschau","separator":undefined,"defaultLabel":"Druckvorschau","iconClass":"app_silkIconList_76","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Druck","separator":undefined,"defaultLabel":"Druck","iconClass":"app_silkIconList_77","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]}
]},
{"label":"Bearbeiten","separator":undefined,"defaultLabel":"Bearbeiten","iconClass":undefined,"imageList":undefined,"idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[
{"label":"Buchhaltung","separator":undefined,"defaultLabel":"Buchhaltung","iconClass":"app_silkIconList_23","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Abrechnung","separator":undefined,"defaultLabel":"Abrechnung","iconClass":"app_silkIconList_68","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"online Banking","separator":undefined,"defaultLabel":"online Banking","iconClass":"app_silkIconList_80","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Leistungsdaten","separator":undefined,"defaultLabel":"Leistungsdaten","iconClass":"app_silkIconList_62","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Vorgangsverwaltung","separator":undefined,"defaultLabel":"Vorgangsverwaltung","iconClass":"app_silkIconList_46","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Stammdaten","separator":undefined,"defaultLabel":"Stammdaten","iconClass":"app_silkIconList_82","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]}
]},
{"label":"Suchen","separator":undefined,"defaultLabel":"Suchen","iconClass":"app_silkIconList_66","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[]},
{"label":"Information","separator":undefined,"defaultLabel":"Information","iconClass":undefined,"imageList":undefined,"idInPage":undefined,"isCheckbox":false,"onClick":undefined,"children":[
{"label":"Hilfe","separator":undefined,"defaultLabel":"Hilfe","iconClass":"app_silkIconList_56","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":undefined,"children":[]},
{"label":"Über die Anwendung","separator":undefined,"defaultLabel":"Über die Anwendung","iconClass":"app_silkIconList_45","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":false,"onClick":"mnuMainUeber_die_AnwendungClick","children":[]},
{"label":"Kontakt","separator":undefined,"defaultLabel":"Kontakt","iconClass":"app_silkIconList_27","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainKontaktClick","children":[]},
{"label":"Impressum","separator":undefined,"defaultLabel":"Impressum","iconClass":"app_silkIconList_83","imageList":"app.silkIconList","idInPage":undefined,"isCheckbox":undefined,"onClick":"mnuMainImpressumClick","children":[]}
]}
],"height":"100%","localizationStructure":{},"openOnHover":true}, {}]
			}],
			pnlAdmin: ["wm.Panel", {"disabled":true,"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"112px"}, {}],
			pnlSpacer: ["wm.Panel", {"disabled":true,"height":"100%","horizontalAlign":"left","verticalAlign":"top","width":"100%"}, {}],
			pnlSecurity: ["wm.Template", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"300px"}, {}, {
				lblUserName: ["wm.Label", {"height":"100%","padding":"4","width":"100%"}, {}, {
					format: ["wm.DataFormatter", {}, {}],
					binding: ["wm.Binding", {}, {}, {
						wire: ["wm.Wire", {"expression":"\"Willkommen, \" + ${templateUsernameVar.dataValue}","source":false,"targetProperty":"caption"}, {}]
					}]
				}],
				btnLogout: ["wm.Button", {"_classes":{"domNode":["wm_FontSizePx_10px"]},"caption":"Abmelden","height":"100%","margin":"2"}, {"onclick":"closeSessionVar"}]
			}]
		}],
		pnlDesctop: ["wm.Panel", {"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
			pnlOutline: ["wm.EmphasizedContentPanel", {"height":"100%","horizontalAlign":"left","margin":"2","verticalAlign":"top","width":"200px"}, {}, {
				grpLayers: ["wm.AccordionLayers", {"autoScroll":true,"clientBorderColor":"#ffffff","defaultLayer":0}, {}, {
					layMember: ["wm.Layer", {"autoScroll":true,"borderColor":"#ffffff","caption":"Mitglieder","horizontalAlign":"center","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
						conFileAccordionPage: ["wm.PageContainer", {"deferLoad":true,"pageName":"MemberByAccordion","subpageEventlist":{},"subpageMethodlist":{},"subpageProplist":{}}, {}]
					}],
					layFile: ["wm.Layer", {"autoScroll":true,"borderColor":"#ffffff","caption":"Akten","horizontalAlign":"left","margin":"0","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
						conFile: ["wm.PageContainer", {"deferLoad":true}, {}]
					}],
					layBilling: ["wm.Layer", {"autoScroll":true,"borderColor":"#ffffff","caption":"Faktura","horizontalAlign":"left","margin":"0","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
						conBilling: ["wm.PageContainer", {"deferLoad":true}, {}]
					}],
					layMasterData: ["wm.Layer", {"autoScroll":true,"borderColor":"#ffffff","caption":"Stammdaten","horizontalAlign":"left","margin":"0","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
						conMasterData: ["wm.PageContainer", {"deferLoad":true}, {}]
					}],
					layMisc: ["wm.Layer", {"autoScroll":true,"borderColor":"#ffffff","caption":"Verschiedenes","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
						conMisc: ["wm.PageContainer", {"deferLoad":true}, {}]
					}],
					layAdmin: ["wm.Layer", {"autoScroll":true,"borderColor":"#ffffff","caption":"Administrator","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
						conAdmin: ["wm.PageContainer", {"deferLoad":true,"pageName":"AdminByAccordion","subpageEventlist":{},"subpageMethodlist":{},"subpageProplist":{}}, {}]
					}],
					layBottomDoNotShow: ["wm.Layer", {"borderColor":"#ffffff","caption":undefined,"horizontalAlign":"left","showing":false,"themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
						conBottomDoNotShow: ["wm.PageContainer", {"deferLoad":true,"showing":false}, {}]
					}]
				}]
			}],
			splVertical1: ["wm.Splitter", {"bevelSize":"5","height":"100%","maximum":400,"minimum":200,"width":"5px"}, {}],
			pnlClient: ["wm.MainContentPanel", {"border":"2","disabled":true,"height":"100%","horizontalAlign":"left","margin":"2","verticalAlign":"top","width":"100%"}, {}, {
				pnlWorkspace: ["wm.Panel", {"disabled":true,"height":"100%","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					conWorkspace: ["wm.PageContainer", {"deferLoad":true,"pageName":"GlobalSearch","subpageEventlist":{},"subpageMethodlist":{},"subpageProplist":{}}, {}]
				}],
				splHorizintal1: ["wm.Splitter", {"bevelSize":"5","height":"5px","maximum":300,"minimum":150,"width":"100%"}, {}],
				pnlDetails: ["wm.Panel", {"disabled":true,"height":"200px","horizontalAlign":"left","layoutKind":"left-to-right","verticalAlign":"top","width":"100%"}, {}, {
					tabDetails: ["wm.TabLayers", {"disabled":true}, {}, {
						layFollowUp: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Wiedervorlagen","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}, {
							conFollowUp: ["wm.PageContainer", {"deferLoad":true,"pageName":"FollowUp","subpageEventlist":{},"subpageMethodlist":{},"subpageProplist":{}}, {}]
						}],
						layNote: ["wm.Layer", {"border":"1","borderColor":"#333333","caption":"Notizen","horizontalAlign":"left","themeStyleType":"ContentPanel","verticalAlign":"top"}, {}]
					}]
				}]
			}]
		}],
		pnlBottom: ["wm.HeaderContentPanel", {"disabled":true,"height":"30px","horizontalAlign":"left","layoutKind":"left-to-right","margin":"2","verticalAlign":"top","width":"100%"}, {}, {
			Footer: ["wm.Template", {"_classes":{"domNode":["toolbar"]},"disabled":true,"height":"100%","horizontalAlign":"center","padding":"2","verticalAlign":"middle","width":"100%"}, {}, {
				footerLabel: ["wm.Label", {"align":"center","caption":"Copyright 2010 ACME, Inc.","height":"100%","padding":"4","width":"100%"}, {}, {
					format: ["wm.DataFormatter", {}, {}]
				}]
			}]
		}]
	}]
}