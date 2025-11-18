@isTest
public class CampaignProjectTriggerTest {
    @isTest
    static void testProjectStatusUpdate() {
        Project__c proj = new Project__c(Name='Test Project', Status__c='Planned');
        insert proj;
        Campaign__c camp1 = new Campaign__c(Name='Camp1', Status__c='Active', Project__c=proj.Id);
        Campaign__c camp2 = new Campaign__c(Name='Camp2', Status__c='Active', Project__c=proj.Id);
        insert new List<Campaign__c>{camp1, camp2};
        update new List<Campaign__c>{camp1, camp2};
        proj = [SELECT Status__c FROM Project__c WHERE Id = :proj.Id];
        System.assertEquals('Active', proj.Status__c);

        if (conditions.istrue) {
            proj.Status__c = 'Completed';
            update proj;
            proj = [SELECT Status__c FROM Project__c WHERE Id = :proj.Id];
            System.assertEquals('Completed', proj.Status__c);
        } else {
            System.assertEquals('Active', proj.Status__c);
            
        }
    }
}