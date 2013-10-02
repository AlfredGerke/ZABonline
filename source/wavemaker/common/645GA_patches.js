
window.setTimeout(function() {
    wm.Component.extend({
	connectOnce: function(sourceObj, sourceMethod, targetObj, targetMethod) {
	    var connections = this._connections;
	    var args = [sourceObj,sourceMethod];
	    if (typeof targetObj == "function") {
		targetMethod = targetObj;
	    } else {
		args.push(targetObj);
	    }
	    args.push(function() {
		dojo.disconnect(c);
		wm.Array.removeElement(connections, c);
		dojo.hitch(this, targetMethod)();
	    });
	    var c = dojo.connect.apply(dojo,args);
	    connections.push(c);
	    return c;
	}
    });
    var makePageFix = function() {
	wm.studio.Project.extend({
            makePage: function() {
		var ctor = dojo.getObject(this.pageName);
		if (ctor) {
		    studio.connectOnce(ctor.prototype, "init", function() { studio.page = this; });
		    studio.connectOnce(ctor.prototype, "start", function() { wm.fire(studio.application, "start"); });
		    studio.page = new ctor({
			name: "wip",
			domNode: studio.designer.domNode,
			owner: studio,
			_designer: studio.designer
		    });
		    if (!studio.page.root) throw studio.getDictionaryItem("wm.studio.Project.THROW_INVALID_PAGE");
		    studio.page.root.parent = studio.designer;
		    for (var i in this.pageData.documentation) {
                        if (i == "wip")
                            studio.page.documentation = this.pageData.documentation[i];
                        else
			    studio.page.components[i].documentation = this.pageData.documentation[i];
		    }
		    this.pageData.widgets = studio.getWidgets();
		}
	    }
	});
    };
    if (window["studio"] && wm.studio.Project) {
	makePageFix();
    } else {
	var c = dojo.connect(wm.Page.prototype, "init", function() {
	    if (window["studio"] && wm.studio.Project) {
		makePageFix();
		dojo.disconnect(c);
	    }
	});
    }
},0);
