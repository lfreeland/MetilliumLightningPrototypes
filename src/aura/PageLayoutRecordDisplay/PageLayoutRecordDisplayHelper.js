({
	retrievePageLayout : function(component, helper) {
		var action = component.get("c.getPageLayoutMetadata");
        var pageLayoutName = component.get("v.PageLayoutName");
        
        console.log("pageLayoutName: " + pageLayoutName);
        
        var actionParams = {
            "pageLayoutName" : pageLayoutName
        };
        
        action.setParams(actionParams);
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("callback state: " + state);
            
            if (component.isValid() && state === "SUCCESS") {
                var pageLayout = response.getReturnValue();
                console.log("pageLayout: " + pageLayout.toString());
                
                component.set("v.PageLayout", pageLayout);
            }
        });
        
        $A.enqueueAction(action);
	}
})