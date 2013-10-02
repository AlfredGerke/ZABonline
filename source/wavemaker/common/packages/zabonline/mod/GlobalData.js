dojo.provide("wm.packages.zabonline.mod.GlobalData");
//
dojo.declare("GlobalData", null, {
  getNameByIndex: function(index, ret) {
    if (this.globalDataFound() === true) {
      var item = this.scope.initData.getItem(index);
      return item.getValue("name");
    } else {
      return ret;
    }
  },
  getDataValueByIndex: function(index, ret) {
    if (this.globalDataFound() === true) {
      var item = this.scope.initData.getItem(index);
      return item.getValue("dataValue");
    } else {
      return ret;
    }
  },
  globalDataFound: function() {
    var item = this.scope.initData.getItem(0);

    return item.getValue("dataValue");
  },
  userName: function() {
    return this.getDataValueByIndex(1, "");
  },
  userId: function() {
    return this.getDataValueByIndex(2, "");
  },
  tenantId: function(variable) {
    var tenant_id = this.getDataValueByIndex(3, ""); 
           
    if (variable) {
      variable.setValue("dataValue", tenant_id); 
    }
            
    return tenant_id;
  },
  sessionId: function() {
    return this.getDataValueByIndex(4, "");
  },
  countryId: function() {
    return this.getDataValueByIndex(5, "");
  },
  countryCode: function() {
    return this.getDataValueByIndex(6, "");
  },
  currencyCode: function() {
    return this.getDataValueByIndex(7, "");
  },
  constructor: function(globalScope, resultCallBackStr) {
    console.debug('Start GlobalData.constructor');
    
    this.scope = globalScope;
    this.onResultCallbackStr = resultCallBackStr;
    
    console.debug('End GlobalData.constructor');
  },
  postscript: function() {
    console.debug('Start GlobalData.postscript');

    this.scope.connect(this.scope.userData, "onResult", this, "onResult");
    this.scope.connect(this.scope.userData, "onSuccess", this, "onSuccess");
    this.scope.connect(this, "onSuccess", this.scope, this.onResultCallbackStr);

    console.debug('End Global.postscript');
  },
  initData: function(username) {
    console.debug('Start GlobalData.initData');

    this.scope.initData.addItem({
      name: "userdatafound",
      dataValue: false
    }, 0);
    this.scope.initData.addItem({
      name: "username",
      dataValue: username
    }, 1);
    this.scope.initData.addItem({
      name: "userid",
      dataValue: null
    }, 2);
    this.scope.initData.addItem({
      name: "tenantid",
      dataValue: null
    }, 3);
    this.scope.initData.addItem({
      name: "sessionid",
      dataValue: this.scope.getSessionId()
    }, 4);
    this.scope.initData.addItem({
      name: "countryid",
      dataValue: null
    }, 5);
    this.scope.initData.addItem({
      name: "countryCode",
      dataValue: null
    }, 6);
    this.scope.initData.addItem({
      name: "currencyCode",
      dataValue: null
    }, 7);

    console.debug(this.scope.initData.getData());

    console.debug('End GlobalData.initData');
  },
  refresh: function(username) {
    console.debug('Start GlobalData.refresh');

    this.initData(username);

    //Eingaben für die Servicevariable eintragen
    this.scope.userData.input.setValue('Username', username);
    //Service der Servicevariable aktivieren
    if (this.scope.userData.canUpdate()) {
      this.scope.userData.update();
      return 1;
    }
    else {
      console.debug('Kein Update auf this.scope.userData');
      return 0;
    }

    console.debug('End GlobalData.refresh');
  },
  onResult: function(inSender, inDeprecated) {
    try {
      console.debug('Start GlobalData.onResult');

      var userId = this.scope.userData.getValue('id');
      var tenant = this.scope.userData.getValue('tenant');
      var tenantId = tenant.getValue('id');
      var country = tenant.getValue('country');
      var countryId = country.getValue('id');
      var countryCode = country.getValue('countryCode');
      var currencyCode = country.getValue('currencyCode');

      this.scope.initData.setItem(2, {
        name: "userid",
        dataValue: userId
      });
      this.scope.initData.setItem(3, {
        name: "tenantid",
        dataValue: tenantId
      });
      this.scope.initData.setItem(5, {
        name: "countryid",
        dataValue: countryId
      });
      this.scope.initData.setItem(6, {
        name: "countryCode",
        dataValue: countryCode
      });
      this.scope.initData.setItem(7, {
        name: "currencyCode",
        dataValue: currencyCode
      });

      console.debug(this.scope.initData.getData());

      console.debug('End GlobalData.onResult');
    } catch (e) {
      console.error('ERROR IN globalDataResult: ' + e);
    }
  },
  onSuccess: function(inSender, inDeprecated) {
    try {
      console.debug('Start GlobalData.onSuccess');
      
      this.scope.initData.setItem(0, {
        name: "userdatafound",
        dataValue: true
      });
      
      console.debug('End GlobalData.onSuccess');
    } catch (e) {
      console.error('ERROR IN globalDataSuccess: ' + e);
    }
  }    
});

