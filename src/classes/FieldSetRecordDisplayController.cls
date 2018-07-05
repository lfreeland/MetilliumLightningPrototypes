public with sharing class FieldSetRecordDisplayController {
    @AuraEnabled
    public static FieldSetRecordDisplay getRecordDisplay(Id recordId, String objectName, String fieldSetName) {
        FieldSetRecordDisplay display = new FieldSetRecordDisplay();        
        display.Fields = FieldSetUtil.getFields(recordId, objectName, fieldSetName);
        
        return display;
    }

    public class FieldSetRecordDisplay {
        @AuraEnabled
        public List<Field> Fields { get; set; }

        public FieldSetRecordDisplay() {
            Fields = new List<Field>();
        }
    }
}