@isTest
public with sharing class FieldSetFormControllerTest {
    
    @isTest
    static void getForm_nullRecordIdWithAccountAndAccountFieldSet_expectSomeFieldsAndBlankRecordInFormTest() {
        FieldSetFormController.FieldSetForm fsm = FieldSetFormController.getForm(null, 'Account', 'Metillium_Account_Test_Field_Set');
        
        system.assert(fsm != null, 'The field set form is null.');
        system.assert(fsm.Record != null, 'The record should not be null.');
        system.assert(fsm.Fields != null, 'The fields should not be null.');
    }
    
    @isTest
    static void getForm_accountRecordIdWithAccountAndAccountFieldSet_expectSomeFieldsAndAccountRecordInFormTest() {
        Account acct = new Account(
            Name = 'Test Account',
            Website = 'example.com'
        );
        
        insert acct;
        
        FieldSetFormController.FieldSetForm fsm = FieldSetFormController.getForm(acct.Id, 'Account', 'Metillium_Account_Test_Field_Set');
        
        system.assert(fsm != null, 'The field set form is null.');
        system.assert(fsm.Record != null, 'The record should not be null.');
        system.assertEquals(acct.Id, fsm.Record.Id, 'The desired account record was not queried.');
        
        system.assert(fsm.Fields != null, 'The fields should not be null.');
    }
}