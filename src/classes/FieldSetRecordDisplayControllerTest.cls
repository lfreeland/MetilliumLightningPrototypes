@isTest
public with sharing class FieldSetRecordDisplayControllerTest {
    @isTest
    static void getRecordDisplay_nullRecordIdWithAccountAndAccountFieldSet_expectSomeFieldsInFormTest() {
        FieldSetRecordDisplayController.FieldSetRecordDisplay fsrd = 
            FieldSetRecordDisplayController.getRecordDisplay(null, 'Account', 'Metillium_Account_Test_Field_Set');
        
        system.assert(fsrd != null, 'The field set record display is null.');
        system.assert(fsrd.Fields != null, 'The fields should not be null.');
    }
    
    @isTest
    static void getRecordDisplay_accountRecordIdWithAccountAndAccountFieldSet_expectSomeFieldsInFormTest() {
        Account acct = new Account(
            Name = 'Test Account',
            Website = 'example.com'
        );
        
        insert acct;
        
        FieldSetRecordDisplayController.FieldSetRecordDisplay fsrd =
            FieldSetRecordDisplayController.getRecordDisplay(acct.Id, 'Account', 'Metillium_Account_Test_Field_Set');
        
        system.assert(fsrd != null, 'The field set record display is null.');
        system.assert(fsrd.Fields != null, 'The fields should not be null.');
    }
}