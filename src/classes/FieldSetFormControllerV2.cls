public with sharing class FieldSetFormControllerV2 {
    @AuraEnabled
    public static FieldSetForm getForm(Id recordId, String objectName, String fieldSetName) {
        FieldSetForm form = new FieldSetForm();        
        form.Fields = FieldSetUtil.getFields(recordId, objectName, fieldSetName);
        
        return form;
    }
    
    public class FieldSetForm {
        @AuraEnabled
        public List<Field> Fields { get; set; }

        public FieldSetForm() {
            Fields = new List<Field>();
        }
    }
}