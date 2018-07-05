public with sharing class FieldSetUtil {
    public static List<Field> getFields(Id recordId, String objectName, String fieldSetName) {
        Schema.SObjectType objectType = null;
        
        if (recordId != null) {
            objectType = recordId.getSobjectType();
        }
        else if (String.isNotBlank(objectName)) {
            objectType = Schema.getGlobalDescribe().get(objectName);
        }

        return getFields(objectType, fieldSetName);
    }
    
    public static List<Field> getFields(String objectName, String fieldSetName) {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);

        return getFields(objectType, fieldSetName);
    }
    
    private static List<Field> getFields(Schema.SObjectType objectType, String fieldSetName) {
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();

        List<Field> fields = new List<Field>();
        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            Field f = new Field(fsm);

            fields.add(f);
        }

        return fields;
    }
}