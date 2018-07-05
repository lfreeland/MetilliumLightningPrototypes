public with sharing class EmailGridController {

    @auraEnabled
    public static RecordsResponse getRecords(String requestJSON) {
        system.debug('    getRecords::requestJSON: ' + requestJSON);
    
        RecordsRequest request = (RecordsRequest) JSON.deserialize(requestJSON, RecordsRequest.class);
        
        system.debug('    getRecords::request : ' + request );
    
        List<SObject> records = getObjectRecords(request);
        
        system.debug('    getRecords::records ' + records);
        
        RecordsResponse response = new RecordsResponse(records);
        loadResponse(response, request);
        
        system.debug('    getRecords::response : ' + response );
        
        return response;
    }
    
    @auraEnabled
    public static EmailResponse emailRecords(String requestJSON) {
        system.debug('  emailRecords::requestJSON ' + requestJSON);
    
        EmailRecordsRequest request = (EmailRecordsRequest) JSON.deserialize(requestJSON, EmailRecordsRequest.class);
        
        system.debug('  emailRecords::request ' + request);
        

        EmailTemplate template = [Select id from EmailTemplate where DeveloperName = :request.emailTemplateName];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        User recipientUser = [Select Id, Email From User Where Id = :request.recipientUserId];
        
        for (String recordId : request.RecordIds) {
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.Id, request.recipientUserId, recordId);
                        
            //email.setTargetObjectId(request.recipientUserId);
            
            email.setToAddresses(new List<String>{ recipientUser.Email });

            email.setSaveAsActivity(false);
            
            system.debug('    email ' + email);
            
            emails.add(email);
        }
        


/*String emailSubject = email.getSubject();
String emailTextBody = email.getPlainTextBody();

email.setTargetObjectId(userId);
email.setSubject(emailSubject);
email.setPlainTextBody(emailTextBody);*/

        List<Messaging.SendEmailResult> emailResults = Messaging.sendEmail(emails,false);
    
        EmailResponse response = new EmailResponse();
        //response.EmailResults = emailResults;
        
        system.debug('   emailResults ' + emailResults);
        
        return response;
    }
    
    private static void loadResponse(RecordsResponse response, RecordsRequest request) {
        Schema.FieldSet fs = getFieldSet(request);
        
        for (FieldSetMember field : fs.getFields()) {
            response.ColumnNames.add(field.getLabel());
            response.ColumnAPINames.add(field.getFieldPath());
        }
        
        for (Record r : response.Records) {
            for(FieldSetMember field : fs.getFields()) {
                String apiFieldName = field.getFieldPath();
                Object fieldValue = r.Record.get(apiFieldName);
                
                String fieldValueString = fieldValue != null ? String.valueOf(fieldValue) : '';
        
                r.Values.add(fieldValueString);
            }
        }
    }
    
    private static Schema.FieldSet getFieldSet(RecordsRequest request) {
        List<String> types = new List<String>{ request.SObjectName };

        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        Schema.DescribeSobjectResult objectResult = results[0];
        
        Map<String, Schema.FieldSet> fsMap = objectResult.fieldSets.getMap();
        
        Schema.FieldSet fs = fsMap.get(request.FieldSet);
        
        return fs;
    }
    
    private static List<SObject> getObjectRecords(RecordsRequest request) {
        Schema.FieldSet fs = getFieldSet(request);
        
        List<FieldSetMember> fields = fs.getFields();
        List<String> fieldNames = new List<String>();
        
        for (FieldSetMember field : fields) {
            fieldNames.add(field.getFieldPath());
        }
        
        String soqlFieldNames = String.join(fieldNames, ',');

        String soql = 'SELECT ' + soqlFieldNames +
                      '  FROM ' + request.SObjectName;

        if (String.isNotBlank(request.WhereClause)) {
            soql += ' ' + request.WhereClause;
        }

        return Database.query(soql);
    }
    
    public class EmailRecordsRequest {
        public List<String> recordIds { get; set; }
        
        public String emailTemplateName { get; set; }
        
        public String recipientUserId { get; set; }
    }
    
    public class EmailResponse {
        //@auraEnabled
        //public List<Messaging.SendEmailResult> EmailResults { get; set; }
    }
    
    public class RecordsRequest {
        public String SObjectName { get; set; }
        
        public String FieldSet { get; set; }
        
        public String WhereClause { get; set; }
        
        public RecordsRequest() {
            SObjectName = '';
            FieldSet = '';
            WhereClause = '';
        }
    }
    
    public class RecordsResponse {
        @AuraEnabled
        List<Record> Records { get; set; }
        
        @AuraEnabled
        List<String> ColumnNames { get; set; }
        
        @AuraEnabled
        List<String> ColumnAPINames { get; set; }
        
        public RecordsResponse(List<SObject> sobjectRecords) {
            Records = new List<Record>();
            ColumnNames = new List<String>();
            ColumnAPINames = new List<String>();
            
            for (SObject sobjectRecord : sobjectRecords) {
                Record r = new Record(sobjectRecord);
                Records.add(r);
            }
        }
    }
    
    public class Record {
        @AuraEnabled
        public SObject Record { get; set; }
        
        @AuraEnabled
        public List<String> Values { get; set; }
        
        @AuraEnabled
        public Boolean Selected { get; set; }
        
        public Record(SObject objRecord) {
            Values = new List<String>();
        
            Selected = false;
            
            Record = objRecord;
        }
    }
}