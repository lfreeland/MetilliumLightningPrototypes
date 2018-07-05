@isTest
public with sharing class RecordVideoViewerControllerTest {

    @isTest
    static void getVideoURL_accountWithWebsiteAsVideoSource_expectVideoSourceUrlReturnedTest() {
        String videoSrcURL = 'http://vid@example.com';
        
        Account acct = new Account(
            Name = 'Test Account',
            Website = videoSrcURL
        );
        
        insert acct;
        
        String recordVideoSrcUrl = RecordVideoViewerController.getVideoURL(acct.Id, 'Website');
        
        system.assertEquals(videoSrcURL, recordVideoSrcUrl, 'The video url was not retrieved from the website field on the account.');
    }
}