dojo.provide("wm.packages.zabonline.mod.DummyServiceVariable");

dojo.declare("DummyServiceVariable", null, {
  constructor: function() {
    console.debug('Start DummyServiceVariable.constructor');
    
    console.debug('End DummyServiceVariable.constructor');
  },
  onResult: function() {
    console.debug('Start DummyServiceVariable.onResult');
    
    console.debug('End DummyServiceVariable.onResult');  
  },
  request: function() {
    console.debug('Start DummyServiceVariable.request');
    
    console.debug('End DummyServiceVariable.request');  
  },
  doRequest: function() {
    console.debug('Start DummyServiceVariable.doRequest');
    
    this.request();
    
    console.debug('End DummyServiceVariable.doRequest');    
  },  
  doResult: function() {
    console.debug('Start DummyServiceVariable.doResult');  
    
    this.onResult();
    
    console.debug('End DummyServiceVariable.doResult');    
  }  
});