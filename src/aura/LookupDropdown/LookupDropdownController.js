({
	initLookupDropdown : function(component, event, helper) {
		var action = component.get("c.loadLookupDropdown");
        var objectName = component.get("v.sObjectName");
        var lookupField = component.get("v.lookupField");
        var recordId = component.get("v.recordId");
        console.log("objectName: " + objectName);
        console.log("lookupField: " + lookupField);
        console.log("recordId: " + recordId);
        
        action.setParams({"objectName": objectName,
                          "lookupField": lookupField,
                          "recordId": recordId});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("callback state: " + state);
            
            if (component.isValid() && state === "SUCCESS") {
                var context = response.getReturnValue();
                console.log("context: " + context.toString());
                
                component.set("v.lookupFieldLabel", context.LookupLabel);
                component.set("v.selectableRecords", context.SelectableRecords);
                component.set("v.currentLookupValue", context.CurrentValue);
                
                var cmp = component.find('lookupDropDownSelect');
                cmp.set('v.label', context.LookupLabel);
                cmp.set('v.body', []); // clear all options
                var body = cmp.get('v.body');
                
                $A.createComponent(
                        'aura:html',
                        {
                            tag: 'option',
                            HTMLAttributes: {
                                value: '',
                                text: 'None'
                            }
                        },
                        
                        function (newOption) {
                            //Add options to the body
                            if (component.isValid()) {
                                body.push(newOption);
                                cmp.set('v.body', body);
                            }
                        });
                
                context.SelectableRecords.forEach(function (selectableRecord) {
                    $A.createComponent(
                        'aura:html',
                        {
                            tag: 'option',
                            HTMLAttributes: {
                                value: selectableRecord.Id,
                                text: selectableRecord.Name,
                                selected: selectableRecord.Id === context.CurrentValue ? "selected" : ""
                            }
                        },
                        
                        function (newOption) {
                            //Add options to the body
                            if (component.isValid()) {
                                body.push(newOption);
                                cmp.set('v.body', body);
                            }
                        })
                });
            }
        });
        
        $A.enqueueAction(action);
	},
    
    saveLookupValue : function(component, event, helper) {
        var action = component.get("c.saveLookup");
        var lookupField = component.get("v.lookupField");
        var recordId = component.get("v.recordId");
        var cmp = component.find('lookupDropDownSelect');
        var selectedId = cmp.get('v.value');
        
        console.log('selectedId: ' + selectedId);
        
        action.setParams({"recordId": recordId,
                          "lookupField": lookupField,
                          "lookupValue": selectedId});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("callback state: " + state);
            
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }
            
        });
        $A.enqueueAction(action);
    }
})