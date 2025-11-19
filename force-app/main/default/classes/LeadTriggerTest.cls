@isTest
public class LeadTriggerTest {
    
    @isTest
    static void testLeadTrigger() {
        // Create a new Lead record
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            Email = 'john.doe@test.com'
        );
        
        // Insert the lead
        Test.startTest();
        insert testLead;
        Test.stopTest();
        
        // Add assertions to verify trigger behavior
        // For example, check if email was sent or other trigger logic
    }
}
