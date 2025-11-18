trigger CampaignTrigger on Campaign__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        CampaignTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}
