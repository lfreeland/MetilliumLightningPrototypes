public with sharing class RecordVideoViewerController {
    @AuraEnabled
    public static String getVideoURL(Id recordId, String videoField) {
        Schema.SObjectType objectType = recordId.getSobjectType();
        String objectName = objectType.getDescribe().getName();
        
        String videoSOQL = 'SELECT ' + videoField +
                           '  FROM ' + objectName +
                           ' WHERE Id = :recordId';

        SObject record = Database.query(videoSOQL);
        String videoSrcURL = (String) record.get(videoField);                           
        
        return videoSrcURL;
    }
}