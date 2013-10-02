dojo.provide("wm.packages.zabonline.mod.Utils");

dojo.declare("Utils", null, {
  constructor: function() {
    console.debug('Start Utils.constructor');
    
    console.debug('End Utils.constructor');
  },
  setDefaultStr: function(str, defaultStr) {
    console.debug('Start Utils.setDefaultStr');
    if (!defaultStr) {
      defaultStr = "";
    }
    
    if (!str) {
      return defaultStr;
    } else
    {
      return str;
    }
    console.debug('End Utils.setDefaultStr');  
  },
  getPropertyValue: function(data, prop) {
    if (data) {
      var value = data[prop];
      if (value) {
        return value;
      } else {
        return null;
      }
    }    
  },
  extractFilename: function(file, slash) {
    if (!slash) {
      slash = "/";
    }
    
    return file.substring(file.lastIndexOf("/")+1);
  }
});
