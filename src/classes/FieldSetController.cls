public class FieldSetController {

    @AuraEnabled
    public static List<Field> getFields(String objectName, String fieldSetName) {
        return FieldSetUtil.getFields(objectName, fieldSetName);
    }
}