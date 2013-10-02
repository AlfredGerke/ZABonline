
wm.addFrameworkFix("build.Gzipped.wm_editors", function() {
   wm.Number.extend({
     getEditorProps: function(inNode, inProps) {
    var v = this.displayValue;
	var constraints = this.getEditorConstraints();
	var p = dojo.mixin(this.inherited(arguments), {
	    constraints: constraints,
	    //editPattern: constraints.pattern,
	    rangeMessage: this.rangeMessage,
	    required: this.required,
	    value: v ? Number(v) : "",
	    editOptions: {}
	}, inProps || {});
	if (this.places) {
	    p.editOptions.places = Number(this.places);
	}
	return p;
	}
});
dijit.form.NumberTextBox.extend({
        	format: function(value,  constraints){
			// summary:
			//		Formats the value as a Number, according to constraints.
			// tags:
			//		protected
			var formattedValue = String(value);
			if(typeof value != "number"){ return formattedValue; }
			if(isNaN(value)){ return ""; }
			// check for exponential notation that dojo.number.format chokes on
			if(!("rangeCheck" in this && this.rangeCheck(value, constraints)) && constraints.exponent !== false && /&#100;e[-+]?&#100;/i.test(formattedValue)){
				return formattedValue;
			}
			constraints = dojo.mixin({}, constraints, this.editOptions);
			return this._formatter(value, constraints);
		}
});
wm.AbstractEditor.extend({
        getInvalid: function() {	        
		if (this.validationEnabled() && this.editor && this.editor.isValid) {
			if (this._isValid === undefined)
				this._isValid = this.editor.isValid();
			return !(this.readonly || this._isValid);
		} else if (this.required && !this.readonly) {
		    var value = this.getDataValue();
		    if (value === undefined || value === null || value === "") {
			return true;
		    }
		}
	}
});
});
wm.addFrameworkFix("build.Gzipped.wm_livepanel", function() {
    wm.LiveFormBase.extend({
       clearDataOutput: function() {
	      dojo.forEach(this.getRelatedEditorsArray(), function(e) {
		     e.clearDataOutput();
		  });
	      this.dataOutput.setData(null);
        }
    });
});
