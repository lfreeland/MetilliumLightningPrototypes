@isTest
public with sharing class PageLayoutRecordDisplayControllerTest {
    @isTest
    static void getPageLayoutMetadata_emptyPageLayoutName_expectEmptyPageLayoutTest() {
        PageLayoutRecordDisplayController.PageLayout pageLayout =
                PageLayoutRecordDisplayController.getPageLayoutMetadata('');
        
        assertEmptyPageLayout(pageLayout);
    }
    
    @isTest
    static void getPageLayoutMetadata_nonExistentPageLayout_expectEmptyPageLayoutTest() {
        String nonExistentPageLayout = 'asfdsdf1213120akdk';
        
        PageLayoutRecordDisplayController.PageLayout pageLayout =
                PageLayoutRecordDisplayController.getPageLayoutMetadata(nonExistentPageLayout);

        assertEmptyPageLayout(pageLayout);
    }
    
    @isTest
    static void getPageLayoutMetadata_existingPageLayout_expectNonEmptyPageLayoutTest() {
        String existentPageLayout = 'Account-Account Layout';
        
        PageLayoutRecordDisplayController.PageLayout pageLayout =
                PageLayoutRecordDisplayController.getPageLayoutMetadata(existentPageLayout);

        assertNonEmptyPageLayout(pageLayout);
    }
    
    static void assertEmptyPageLayout(PageLayoutRecordDisplayController.PageLayout pageLayout) {
        system.assert(pageLayout != null, 'The page layout should not be null.');
        system.assert(pageLayout.Sections != null, 'The page layout\'s sections should not be null.');
        system.assertEquals(0, pageLayout.Sections.size(), 'The page layout\'s sections should be empty.');
    }

    static void assertNonEmptyPageLayout(PageLayoutRecordDisplayController.PageLayout pageLayout) {
        system.assert(pageLayout != null, 'The page layout should not be null.');
        system.assert(pageLayout.Sections != null, 'The page layout\'s sections should not be null.');
        system.assert(pageLayout.Sections.size() > 0, 'The page layouts should have sections.');
    }
}