({
	init : function(component, event, helper) {
        var action = component.get("c.getRecords");
        var objectName = component.get("v.objectName");
        var fieldSet = component.get("v.fieldSet");
        var whereClause = component.get("v.whereClause");
        
        console.log("objectName: " + objectName);
        console.log("fieldSet: " + fieldSet);
        console.log("whereClause: " + whereClause);
        
        debugger;
        
        var getRecordsRequest = {
            "requestJSON" : JSON.stringify({
                "SObjectName": objectName,
                "FieldSet": fieldSet,
                "WhereClause": whereClause
            })
        }
        
        action.setParams(getRecordsRequest);
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("callback state: " + state);
            
            debugger;
            
            if (component.isValid() && state === "SUCCESS") {
                var context = response.getReturnValue();
                console.log("context: " + context.toString());
                
                component.set("v.records", context.Records);
                component.set("v.columnNames", context.ColumnNames);
                component.set("v.columnAPINames", context.ColumnAPINames);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    doEmailRecords : function(component, event, helper) {
        var records = component.get("v.records");
        var emailTemplateName = component.get("v.emailTemplate");
        var recipientUserId = component.get("v.recipientUserId");
        
        debugger;
        
        var emailRecordsRequestObj = {
            "emailTemplateName" : emailTemplateName,
            "recipientUserId" : recipientUserId,
            "recordIds" : []
        };
        
        for (var i = 0; i < records.length; ++i) {
            var record = records[i];
            
            if (record && record.Selected) {
                emailRecordsRequestObj.recordIds.push(record.Record.Id);
            }
        }
        
        if (emailRecordsRequestObj &&
            emailRecordsRequestObj.recordIds &&
            emailRecordsRequestObj.recordIds.length == 0) {
            return;
        }
               
        var action = component.get("c.emailRecords");
        
        var emailRecordsRequest = {
            "requestJSON" : JSON.stringify(emailRecordsRequestObj)
        };
        
        action.setParams(emailRecordsRequest);
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("callback state: " + state);
            
            debugger;
            
            if (component.isValid() && state === "SUCCESS") {
                var context = response.getReturnValue();
                console.log("context: " + context.toString());
            }
        });
        
        $A.enqueueAction(action);
        
    }
	
})