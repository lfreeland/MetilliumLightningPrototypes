({
    init: function(cmp, event, helper) {
        console.log('FieldSetFormController.init');
        
        var fieldSetName = cmp.get('v.fieldSetName');
        var sobjectName = cmp.get('v.sObjectName');
        var recordId = cmp.get('v.recordId');
        
        if (!fieldSetName) {
        	console.log('The field set is required.');
        	return;
        }
        
        var getFormAction = cmp.get('c.getForm');

        getFormAction.setParams({
            fieldSetName: fieldSetName,
            objectName: sobjectName,
            recordId: recordId
        });

        getFormAction.setCallback(this, 
            function(response) {
            	var state = response.getState();
            	console.log('FieldSetFormController getFormAction callback');
            	console.log("callback state: " + state);
            
            	if (cmp.isValid() && state === "SUCCESS") {
	                var form = response.getReturnValue();
	                cmp.set('v.fields', form.Fields);
                }
            }
        );
        $A.enqueueAction(getFormAction);
    },
    
    onEditFormLoad : function(cmp, event, helper) {
    	//debugger;
    },
    
    onEditFormSuccess : function(cmp, event, helper) {
        //debugger;
        /*
        var response = event.getParam('response');
        var record = response;
        
        for (var prop in record) {
            console.log(' prop: ' + prop);
        }
        
        for (prop in record.fields) {
	        console.log(' prop: ' + prop);
	        
	        for (fieldProp in record.fields.get(prop)) {
	        	console.log(' fieldProp: ' + fieldProp);
	        }
        }
        
        var apiName = record.apiName;
        var childRelationships = record.childRelationships;
        var fields = record.fields;
        var id = record.id;
        var recordTypeInfo = record.recordTypeInfo;
        */
    },
    
    onEditFormSubmit : function(cmp, event, helper) {
        //debugger;
    },
    
    onEditFormError : function(cmp, event, helper) {
        //debugger;
    }
})