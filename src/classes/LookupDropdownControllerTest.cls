@isTest
public with sharing class LookupDropdownControllerTest {
    @isTest
    static void loadLookupDropdown_lookupAccountsOnGivenContact_expectAccountRecordsReturnedTest() {
        Account lookupAcct = new Account(
            Name = 'Test Account'
        );
        
        insert lookupAcct;
        
        Contact someContact = new Contact(
            FirstName = 'Luke',
            LastName = 'Smith'
        );
        
        insert someContact;
        
        LookupDropdownController.Context ctxt = LookupDropdownController.loadLookupDropdown('Contact', 'AccountId', someContact.Id);
        
        system.assert(ctxt != null, 'The lookup dropdown context is null.');
        
        system.assert(ctxt.SelectableRecords != null, 'The selectable records should not be null.');
        system.assertEquals(1, ctxt.SelectableRecords.size(), 'There should be one selectable record.');
        system.assertEquals(lookupAcct.Id, ctxt.SelectableRecords[0].Id, 'The lookup account is not the selectable record.');
    }

    @isTest
    static void saveLookup_contactRecordTiedToSpecificAccount_expectContactTiedToAccountTest() {
        Account lookupAcct = new Account(
            Name = 'Test Account'
        );
        
        insert lookupAcct;
        
        Contact someContact = new Contact(
            FirstName = 'Luke',
            LastName = 'Smith'
        );
        
        insert someContact;

        LookupDropdownController.LookupSaveResult saveResult =
            LookupDropdownController.saveLookup(someContact.Id, 'AccountId', lookupAcct.Id);

        system.assert(saveResult != null, 'The save result is null.');
        
        Contact someContactQueried =
        [SELECT Id,
                AccountId
           FROM Contact
          WHERE Id = :someContact.Id];

        system.assertEquals(lookupAcct.Id, someContactQueried.AccountId, 'The contact was not tied to the lookup account.');
    }
}