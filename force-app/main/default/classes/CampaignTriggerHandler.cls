/**
 * @description Trigger handler for Campaign__c. Consolidates all Campaign__c trigger logic.
 * - Bulkified and compliant with governor limits
 * - No SOQL/DML in loops
 * - Uses early returns and clear separation of concerns
 * - with sharing to respect org sharing
 */
public with sharing class CampaignTriggerHandler {
    /**
     * Process after update logic for Campaign__c
     * Responsibilities merged from:
     *  - CampaignTrigger.trigger (create Billing__c when Status__c transitions to 'Completed')
     *  - CampaignProjectTrigger.trigger (update Project__c.Status__c to 'Active' when all related Campaign__c are Active)
     */
    public static void afterUpdate(List<Campaign__c> newList, Map<Id, Campaign__c> oldMap) {
        if (newList == null || newList.isEmpty()) {
            return;
        }

        createBillingsWhenCompleted(newList, oldMap);
        updateProjectsWhenAllCampaignsActive(newList);
    }

    // Create Billing__c when a campaign transitions to Completed
    private static void createBillingsWhenCompleted(List<Campaign__c> newList, Map<Id, Campaign__c> oldMap) {
        List<Billing__c> billingsToCreate = new List<Billing__c>();

        for (Campaign__c camp : newList) {
            Campaign__c oldCamp = oldMap != null ? oldMap.get(camp.Id) : null;
            if (oldCamp == null) {
                continue;
            }
            // Transition to Completed
            if (camp.Status__c == 'Completed' && oldCamp.Status__c != 'Completed') {
                billingsToCreate.add(new Billing__c(
                    Amount__c = camp.Budget__c,
                    Status__c = 'Pending',
                    Campaign__c = camp.Id
                ));
            }
        }

        if (!billingsToCreate.isEmpty()) {
            // User mode DML as per rules
            Database.insert(billingsToCreate, false);
        }
    }

    // If all Campaigns under a Project__c are Active, set the Project__c.Status__c = 'Active'
    private static void updateProjectsWhenAllCampaignsActive(List<Campaign__c> newList) {
        // Collect impacted Project Ids from records that reference a project
        Set<Id> projectIds = new Set<Id>();
        for (Campaign__c c : newList) {
            if (c.Project__c != null) {
                projectIds.add(c.Project__c);
            }
        }
        if (projectIds.isEmpty()) {
            return;
        }

        // One SOQL to get all campaigns for these projects
        Map<Id, List<Campaign__c>> campaignsByProject = new Map<Id, List<Campaign__c>>();
        for (Campaign__c c : [
            SELECT Id, Status__c, Project__c
            FROM Campaign__c
            WHERE Project__c IN :projectIds
        ]) {
            List<Campaign__c> bucket = campaignsByProject.get(c.Project__c);
            if (bucket == null) {
                bucket = new List<Campaign__c>();
                campaignsByProject.put(c.Project__c, bucket);
            }
            bucket.add(c);
        }

        // Determine which projects have ALL campaigns Active
        List<Project__c> projectsToUpdate = new List<Project__c>();
        for (Id projId : campaignsByProject.keySet()) {
            List<Campaign__c> related = campaignsByProject.get(projId);
            if (related.isEmpty()) {
                continue;
            }
            Boolean allActive = true;
            for (Campaign__c c : related) {
                if (c.Status__c != 'Active') {
                    allActive = false;
                    break;
                }
            }
            if (allActive) {
                projectsToUpdate.add(new Project__c(Id = projId, Status__c = 'Active'));
            }
        }

        if (!projectsToUpdate.isEmpty()) {
            Database.update(projectsToUpdate, false);
        }
    }
}
