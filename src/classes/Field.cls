public class Field {

    public Field(Schema.FieldSetMember f) {
        this.DBRequired = f.DBRequired;
        this.APIName = f.fieldPath;
        this.Label = f.label;
        this.Required = f.required;
        this.Type = String.valueOf(f.getType());
    }
    
    public Field(Boolean DBRequired) {
        this.DBRequired = DBRequired;
    }
    
    @AuraEnabled
    public Boolean DBRequired { get;set; }
    
    @AuraEnabled
    public String APIName { get;set; }
    
    @AuraEnabled
    public String Label { get;set; }
    
    @AuraEnabled
    public Boolean Required { get;set; }
    
    @AuraEnabled
    public String Type { get; set; }
}