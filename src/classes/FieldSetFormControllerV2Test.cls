@isTest
public with sharing class FieldSetFormControllerV2Test {
    @isTest
    static void getForm_nullRecordIdWithAccountAndAccountFieldSet_expectSomeFieldsInFormTest() {
        FieldSetFormControllerV2.FieldSetForm fsm = FieldSetFormControllerV2.getForm(null, 'Account', 'Metillium_Account_Test_Field_Set');
        
        system.assert(fsm != null, 'The field set form is null.');
        system.assert(fsm.Fields != null, 'The fields should not be null.');
    }
    
    @isTest
    static void getForm_accountRecordIdWithAccountAndAccountFieldSet_expectSomeFieldsInFormTest() {
        Account acct = new Account(
            Name = 'Test Account',
            Website = 'example.com'
        );
        
        insert acct;
        
        FieldSetFormControllerV2.FieldSetForm fsm = FieldSetFormControllerV2.getForm(acct.Id, 'Account', 'Metillium_Account_Test_Field_Set');
        
        system.assert(fsm != null, 'The field set form is null.');
        system.assert(fsm.Fields != null, 'The fields should not be null.');
    }
}