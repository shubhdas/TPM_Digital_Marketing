@isTest
public class CampaignTriggerTest {
    @isTest
    static void testBillingCreatedOnCampaignCompleted() {
        Campaign__c camp = new Campaign__c(Name='Test Campaign', Status__c='Planned', Budget__c=1000);
        insert camp;
        camp.Status__c = 'Completed';
        update camp;
        List<Billing__c> billings = [SELECT Id, Amount__c, Status__c, Campaign__c FROM Billing__c WHERE Campaign__c = :camp.Id];
        System.assertEquals(1, billings.size());
        System.assertEquals(1000, billings[0].Amount__c);
        System.assertEquals('Pending', billings[0].Status__c);
    }
}