public with sharing class FieldSetFormController {
    @AuraEnabled
    public static FieldSetForm getForm(Id recordId, String objectName, String fieldSetName) {
        FieldSetForm form = new FieldSetForm();
        
        form.Fields = FieldSetUtil.getFields(recordId, objectName, fieldSetName);
        form.Record = getRecord(recordId, objectName, form.Fields);
        
        return form;
    }
    
    @AuraEnabled
    public static void upsertRecord(SObject recordToUpsert) {
        upsert recordToUpsert;
    }
    
    private static SObject getRecord(Id recordId, String objectName, List<Field> fields) {
        if (recordId == null) {
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
            return objectType.newSObject();
        }
        
        List<String> fieldsToQuery = new List<String>();
        for (Field f : fields) {
            fieldsToQuery.add(f.APIName);
        }
        
        Schema.SObjectType objectType = recordId.getSobjectType();
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        String objectAPIName = objectDescribe.getName();
        
        String recordSOQL = 'SELECT ' + String.join(fieldsToQuery, ',') +
                            '  FROM ' + objectAPIName +
                            ' WHERE Id = :recordId';

        SObject record = Database.query(recordSOQL);
        
        return record;
    }
    
    public class FieldSetForm {
        @AuraEnabled
        public List<Field> Fields { get; set; }
        
        @AuraEnabled
        public SObject Record { get; set; }
        
        public FieldSetForm() {
            Fields = new List<Field>();
        }
    }
}