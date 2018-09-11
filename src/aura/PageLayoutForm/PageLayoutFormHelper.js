({
	retrievePageLayout : function(component, helper) {
		var action = component.get("c.getPageLayoutMetadata");
        var pageLayoutName = component.get("v.pageLayoutName");

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

                component.set("v.pageLayout", pageLayout);
            }
        });

        $A.enqueueAction(action);
	},

	onsuccess : function(component, event, helper) {
		var payload = event.getParams().response;
		
        var toastEvent = $A.get("e.force:showToast");
        var recordURL = '/' + payload.id;
        
        toastEvent.setParams({
        	message: "success",
            messageTemplate: 'The {0} was saved successfully.',
            messageTemplateData: [{
                url: recordURL,
                label: 'record',
            }],
            type: 'success'
        });
        toastEvent.fire();
        
        // Set the record id so that future saves will update the created record
        // if no record id was initially specified.
        component.set('v.recordId', payload.id);
	}
})