dojo.provide("wm.packages.zabonline.extend.ZabExtender");
//
dojo.declare("ZabExtender", null, {
  postscript: function() {
    console.debug("Start ZabExtender");
    
    var zabOnlineLoadingDialogHack = function() {
        if (!wm.LoadingDialog.setParameter) {
          wm.LoadingDialog.extend({
              setParameter: function(svcVarToBind, wdgToCover) {
                  this.setValue("serviceVariableToTrack", svcVarToBind);
                  this.widgetToCover = wdgToCover;
              }
          });
        }
    };
    //
    var zabOnlineDialogHack = function() {
        if (!wm.Dialog.showModal) {
          wm.Dialog.extend({
              showModal: function() {        
                  this.setModal(true);
                  this.show();
              }
          });
        }
    };
    //
    var zabOnlineTextHack = function() {
       if (!wm.Text.quickSetup) {
         wm.Text.extend({
           quickSetup: function(require, regExpr, doClear, forceRegExpr) {
             //
             this.required = require;             
             //
             if (require) {
               this.setRegExp(regExpr);
             } else {
               if (forceRegExpr) {
                 this.setRegExp(regExpr);
               } else {
                 this.setRegExp(".*");
               }
             }                        
             //
             if (doClear) {
               this.clear();
             }
           }
         });
       } 
    };
    //
    var zabOnlineServiceVariableHack = function() {
      wm.ServiceVariable.extend({
        onError: function(inError) {
          var found = -1;
          var inMessage = "";
          var error_message = (dojo.isObject(inError) ? inError.message : inError);
            
          inMessage= "ERROR_MSG_NO_LOGIN_ALLOWED";
          found = error_message.search(/NO_LOGIN_ALLOWED/);
          if (found == -1) {
            inMessage = "ERROR_MSG_UNKNOWN_USDERID";
            found = error_message.search(/UNKNOWN_USDERID/);
          }        
            
          if (found == -1) {
            inMessage = "ERROR_MSG_INVALID_SESSION_DATA";
            found = error_message.search(/INVALID_SESSION_DATA/);
          }  

          if (found == -1) {
            inMessage = "ERROR_MSG_SESSION_IDLE_TIMEOUT";
            found = error_message.search(/SESSION_IDLE_TIMEOUT/);
          }  
            
          if (found == -1) {
            inMessage = "ERROR_MSG_SESSION_LIFETIME_TIMEOUT";
            found = error_message.search(/SESSION_LIFETIME_TIMEOUT/);
          }  
          
          if (found == -1) {
            inMessage = "ERROR_MSG_NO_VALID_AUTHENTIFICATION";
            found = error_message.search(/NO_VALID_AUTHENTIFICATION/);
          }           

          if (found == -1) {
            inMessage = "ERROR_MSG_UNKNOWN_ERROR_BY_DBSERVICE";
            found = error_message.search(/UNKNOWN_ERROR_BY_DBSERVICE/);
          }

          if (found == -1) {
            inMessage = "ERROR_MSG_CANCEL_BY_UNKNOWN_REASON";         
            found = error_message.search(/CANCEL_BY_UNKNOWN_REASON/);
          }  
          
          if (found !== -1) {
             dojo.publish("session-expiration-databasecall", [this, inMessage]);
          } else {
            this.inherited(arguments);          
          }
        }
      });
    };
    //
    if (wm.LoadingDialog) {
        zabOnlineLoadingDialogHack();
    }
    else {
        var buildPackage = wm.Array.last(wm.componentList["wm.LoadingDialog"]);
        wm.addFrameworkFix(buildPackage, zabOnlineLoadingDialogHack);
    }
    //           
    if (wm.Dialog) {
        zabOnlineDialogHack();
    }
    else {
        var buildPackage = wm.Array.last(wm.componentList["wm.Dialog"]);
        wm.addFrameworkFix(buildPackage, zabOnlineDialogHack);
    }    
    //
    if (wm.Text) {
        zabOnlineTextHack();
    }
    else {
        var buildPackage = wm.Array.last(wm.componentList["wm.Text"]);
        wm.addFrameworkFix(buildPackage, zabOnlineTextHack);
    }    
    //
    if (wm.ServiceVariable) {
        zabOnlineServiceVariableHack();
    }
    else {
        var buildPackage = wm.Array.last(wm.componentList["wm.ServiceVariable"]);
        wm.addFrameworkFix(buildPackage, zabOnlineServiceVariableHack);
    }

    console.debug("End ZabExtender");
  }
});