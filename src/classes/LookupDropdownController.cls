public with sharing class LookupDropdownController {
    @auraEnabled
    public static Context loadLookupDropdown(String objectName, String lookupField, Id recordId) {
        Context c = new Context();
        
        String[] types = new String[]{ objectName };
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        Schema.DescribeSobjectResult objectResult = results[0];
        
        Map<String, Schema.SObjectField> objectFields = objectResult.Fields.getMap();
        Schema.SObjectField objectField = objectFields.get(lookupField);
        
        Schema.DescribeFieldResult lookupFieldDesc = objectField.getDescribe();
        List<Schema.sObjectType> lookupReferences = lookupFieldDesc.getReferenceTo();
        Schema.SObjectType lookupReferenceObject = lookupReferences[0];
        Schema.DescribeSobjectResult lookupObject = lookupReferenceObject.getDescribe();
        
        c.LookupLabel = lookupFieldDesc.getLabel();
        
        c.SelectableRecords = getSelectableRecords(lookupObject.getName());
        c.CurrentValue = getCurrentLookupValue(objectName, lookupField, recordId);
        
        system.debug('    context: ' + c);
        
        return c;
    }
    
    @auraEnabled
    public static LookupSaveResult saveLookup(Id recordId, String lookupField, String lookupValue) {
        LookupSaveResult result = new LookupSaveResult();
        Schema.SObjectType objectType = recordId.getSObjectType();
        
        sObject sObj = objectType.newSObject(recordId);
        sObj.put(lookupField, lookupValue);
        
        update sObj;
        
        //TO DO: Save the results to the result.
        
        return result;
    }
    
    private static List<SObject> getSelectableRecords(String objectName) {
        String query = 'SELECT Id, Name FROM ' + objectName + ' Order By Name LIMIT 1000';
        return Database.query(query);        
    }
    
    private static String getCurrentLookupValue(String objectName, String lookupField, String recordId) {
        String query = 'SELECT Id, ' + lookupField + ' FROM ' + objectName + ' WHERE Id = :recordId';
        SObject record = Database.query(query);
        
        return String.valueOf(record.get(lookupField));
    }
    
    public class LookupSaveResult {
        
    }

    public class Context {
        @AuraEnabled
        public String CurrentValue { get; set; }
        
        @AuraEnabled
        public List<SObject> SelectableRecords { get; set; }
        
        @AuraEnabled
        public String LookupLabel { get; set; }
    }
}