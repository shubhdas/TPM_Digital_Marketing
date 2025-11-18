@isTest
public class LeadTriggerTest {
    @isTest
    static void testLeadNotification() {
        Test.startTest();
        Lead l = new Lead(FirstName='Test', LastName='Lead', Company='Test Company');
        insert l;
        Test.stopTest();
        // Email sending can't be asserted directly, but no errors should occur
    }
}