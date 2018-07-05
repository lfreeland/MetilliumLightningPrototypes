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
	                cmp.set('v.record', form.Record);
	                helper.createForm(cmp);
                }
            }
        );
        $A.enqueueAction(getFormAction);
    },
    
    saveForm : function(cmp, event, helper) {
        console.log('FieldSetFormController.saveForm');
    
    	var upsertRecordAction = cmp.get('c.upsertRecord');
    	var record = cmp.get('v.record');
    	
    	if (!record.sobjectType) {
    		record.sobjectType = cmp.get('v.sObjectName');
    	}
    	
    	upsertRecordAction.setParams({
            recordToUpsert: record
        });

        upsertRecordAction.setCallback(this, 
            function(response) {
            	var state = response.getState();
            	
            	console.log('FieldSetFormController upsertRecordAction callback');
            	console.log("callback state: " + state);
            	
            	var toastEvent = $A.get("e.force:showToast");
            
            	if (cmp.isValid() && state === "SUCCESS") {
            		
            		toastEvent.setParams({
            			"title": "Success!",
            			"message": "The record has been upserted successfully.",
            			"type": "success"
            		});
            	
            		toastEvent.fire();
            		
            		$A.get('e.force:refreshView').fire();
                }
                else if (state === "ERROR") {
                	var errorMessage = response.getError()[0].message;
                
                	toastEvent.setParams({
            			"title": "Error",
            			"message": "The record was not saved. Error: " + errorMessage,
            			"type": "error"
            		});
            	
            		toastEvent.fire();
                }
            }
        );
        $A.enqueueAction(upsertRecordAction);
    }
})