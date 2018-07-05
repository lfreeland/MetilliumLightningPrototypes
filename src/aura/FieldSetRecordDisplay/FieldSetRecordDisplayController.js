({
    init: function(cmp, event, helper) {
        console.log('FieldSetRecordDisplayController.init');
        
        var fieldSetName = cmp.get('v.fieldSetName');
        var sobjectName = cmp.get('v.sObjectName');
        var recordId = cmp.get('v.recordId');
        
        if (!fieldSetName) {
        	console.log('The field set is required.');
        	return;
        }
        
        var getRecordDisplayAction = cmp.get('c.getRecordDisplay');

        getRecordDisplayAction.setParams({
            fieldSetName: fieldSetName,
            objectName: sobjectName,
            recordId: recordId
        });

        getRecordDisplayAction.setCallback(this, 
            function(response) {
            	var state = response.getState();
            	console.log('FieldSetRecordDisplayController getRecordDisplay callback');
            	console.log("callback state: " + state);
            
            	if (cmp.isValid() && state === "SUCCESS") {
	                var recordDisplay = response.getReturnValue();
	                cmp.set('v.fields', recordDisplay.Fields);
                }
            }
        );
        $A.enqueueAction(getRecordDisplayAction);
    }
})