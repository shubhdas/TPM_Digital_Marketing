public with sharing class DigitalMarketingController {

    // Dashboard summary wrapper
    public class DashboardCounts {
        @AuraEnabled public Integer leadCount;
        @AuraEnabled public Integer clientCount;
        @AuraEnabled public Integer campaignCount;
        @AuraEnabled public Integer projectCount;
        @AuraEnabled public Integer billingCount;
    }

    // Admin Dashboard Management - Optimized with bulk operations
    @AuraEnabled(cacheable=true)
    public static DashboardCounts getDashboardData() {
        DashboardCounts counts = new DashboardCounts();
        
        // Use bulk queries to reduce governor limits usage
        List<AggregateResult> leadResults = [SELECT COUNT(Id) cnt FROM Lead];
        List<AggregateResult> clientResults = [SELECT COUNT(Id) cnt FROM Client__c];
        List<AggregateResult> campaignResults = [SELECT COUNT(Id) cnt FROM Campaign__c];
        List<AggregateResult> projectResults = [SELECT COUNT(Id) cnt FROM Project__c];
        List<AggregateResult> billingResults = [SELECT COUNT(Id) cnt FROM Billing__c];
        
        // Extract counts from aggregate results
        counts.leadCount = leadResults.isEmpty() ? 0 : (Integer)leadResults[0].get('cnt');
        counts.clientCount = clientResults.isEmpty() ? 0 : (Integer)clientResults[0].get('cnt');
        counts.campaignCount = campaignResults.isEmpty() ? 0 : (Integer)campaignResults[0].get('cnt');
        counts.projectCount = projectResults.isEmpty() ? 0 : (Integer)projectResults[0].get('cnt');
        counts.billingCount = billingResults.isEmpty() ? 0 : (Integer)billingResults[0].get('cnt');
        
        return counts;
    }

    // --- Billing Manager Methods for LWC ---
    @AuraEnabled(cacheable=true)
    public static List<Billing__c> getBillingData() {
        try {
            // Add security check
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            // Query with user context
            return [SELECT Id, Name, Amount__c, Status__c, Billing_Date__c, Client__c FROM Billing__c ORDER BY CreatedDate DESC LIMIT 100];
        } catch (Exception e) {
            System.debug('Error retrieving billing data: ' + e.getMessage());
            throw new AuraHandledException('Failed to retrieve billing data. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static Billing__c createBillingRecord(Decimal amount, String status, Date billingDate, Id clientId) {
        try {
            // Validate inputs
            if (amount == null || String.isBlank(status) || billingDate == null || clientId == null) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Billing__c billing = new Billing__c(
                Amount__c = amount,
                Status__c = status,
                Billing_Date__c = billingDate,
                Client__c = clientId
            );
            insert billing;
            return billing;
        } catch (Exception e) {
            System.debug('Error creating billing record: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to create billing record. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static Billing__c updateBillingRecord(Id billingId, Decimal amount, String status, Date billingDate, Id clientId) {
        try {
            // Validate inputs
            if (billingId == null || amount == null || String.isBlank(status) || billingDate == null || clientId == null) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Billing__c billing = [SELECT Id, Amount__c, Status__c, Billing_Date__c, Client__c FROM Billing__c WHERE Id = :billingId LIMIT 1];
            billing.Amount__c = amount;
            billing.Status__c = status;
            billing.Billing_Date__c = billingDate;
            billing.Client__c = clientId;
            update billing;
            return billing;
        } catch (Exception e) {
            System.debug('Error updating billing record: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to update billing record. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void deleteBillingRecord(Id billingId) {
        try {
            // Validate input
            if (billingId == null) {
                throw new AuraHandledException('Billing record ID is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Billing__c billing = [SELECT Id FROM Billing__c WHERE Id = :billingId LIMIT 1];
            delete billing;
        } catch (Exception e) {
            System.debug('Error deleting billing record: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to delete billing record. Please contact your administrator.');
        }
    }

    // --- Existing CRUD and utility methods - Optimized with better error handling ---

    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeads() {
        try {
            // Add input validation and security checks
            if (UserInfo.getProfileId() == null) {
                throw new AuraHandledException('Access denied: Invalid user profile.');
            }
            
            // Query with user context - include all relevant fields for better visibility
            List<Lead> leads = [SELECT Id, FirstName, LastName, Email, Status, Company, Title, Industry, Rating, Phone, MobilePhone, Fax FROM Lead ORDER BY CreatedDate DESC LIMIT 100];
            return leads;
        } catch (Exception e) {
            // Log the error for debugging purposes
            System.debug('Error retrieving leads: ' + e.getMessage());
            // Re-throw the exception to be handled by the caller
            throw new AuraHandledException('Failed to retrieve leads data. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void createLead(String firstName, String lastName, String email) {
        try {
            // Validate inputs
            if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Validate email format
            if (!isValidEmail(email)) {
                throw new AuraHandledException('Invalid email format.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Lead newLead = new Lead(FirstName = firstName, LastName = lastName, Email = email);
            insert newLead;
        } catch (Exception e) {
            System.debug('Error creating lead: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to create lead. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void updateLead(Id leadId, String firstName, String lastName, String email, String status) {
        try {
            // Validate inputs
            if (leadId == null || String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Validate email format
            if (!isValidEmail(email)) {
                throw new AuraHandledException('Invalid email format.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Lead leadToUpdate = [SELECT Id, FirstName, LastName, Email, Status FROM Lead WHERE Id = :leadId LIMIT 1];
            leadToUpdate.FirstName = firstName;
            leadToUpdate.LastName = lastName;
            leadToUpdate.Email = email;
            leadToUpdate.Status = status;
            update leadToUpdate;
        } catch (Exception e) {
            System.debug('Error updating lead: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to update lead. Please contact your administrator.');
        }
    }

    @AuraEnabled 
    public static void deleteLead(Id leadId) {
        try {
            // Validate input
            if (leadId == null) {
                throw new AuraHandledException('Lead ID is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Lead leadToDelete = [SELECT Id FROM Lead WHERE Id = :leadId LIMIT 1];
            delete leadToDelete;
        } catch (Exception e) {
            System.debug('Error deleting lead: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to delete lead. Please contact your administrator.');
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Client__c> getClients() {
        try {
            // Add security check
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            // Query with user context
            return [SELECT Id, Name, Client_Email__c FROM Client__c ORDER BY CreatedDate DESC LIMIT 100];
        } catch (Exception e) {
            System.debug('Error retrieving clients: ' + e.getMessage());
            throw new AuraHandledException('Failed to retrieve clients data. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void createClient(String name, String email) {
        try {
            // Validate inputs
            if (String.isBlank(name) || String.isBlank(email)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Validate email format
            if (!isValidEmail(email)) {
                throw new AuraHandledException('Invalid email format.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Client__c newClient = new Client__c(Name = name, Client_Email__c = email);
            insert newClient;
        } catch (Exception e) {
            System.debug('Error creating client: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to create client. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void updateClient(Id clientId, String name, String email) {
        try {
            // Validate inputs
            if (clientId == null || String.isBlank(name) || String.isBlank(email)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Validate email format
            if (!isValidEmail(email)) {
                throw new AuraHandledException('Invalid email format.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Client__c clientToUpdate = [SELECT Id, Name, Client_Email__c FROM Client__c WHERE Id = :clientId LIMIT 1];
            clientToUpdate.Name = name;
            clientToUpdate.Client_Email__c = email;
            update clientToUpdate;
        } catch (Exception e) {
            System.debug('Error updating client: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to update client. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void deleteClient(Id clientId) {
        try {
            // Validate input
            if (clientId == null) {
                throw new AuraHandledException('Client ID is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Client__c clientToDelete = [SELECT Id FROM Client__c WHERE Id = :clientId LIMIT 1];
            delete clientToDelete;
        } catch (Exception e) {
            System.debug('Error deleting client: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to delete client. Please contact your administrator.');
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Campaign__c> getCampaigns() {
        try {
            // Add security check
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            // Query with user context - include Billing relationship
            return [SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Budget__c FROM Campaign__c ORDER BY CreatedDate DESC LIMIT 100];
        } catch (Exception e) {
            System.debug('Error retrieving campaigns: ' + e.getMessage());
            throw new AuraHandledException('Failed to retrieve campaigns data. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void createCampaign(String name, String status, Date startDate, Date endDate, Decimal budget) {
        try {
            // Validate inputs
            if (String.isBlank(name)) {
                throw new AuraHandledException('Name is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Campaign__c newCampaign = new Campaign__c(
                Name = name, 
                Status__c = status,
                Start_Date__c = startDate,
                End_Date__c = endDate,
                Budget__c = budget
            );
            insert newCampaign;
        } catch (Exception e) {
            System.debug('Error creating campaign: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to create campaign. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void updateCampaign(Id campaignId, String name, String status, Date startDate, Date endDate, Decimal budget) {
        try {
            // Validate inputs
            if (campaignId == null || String.isBlank(name)) {
                throw new AuraHandledException('Name is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Campaign__c campaignToUpdate = [SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Budget__c FROM Campaign__c WHERE Id = :campaignId LIMIT 1];
            campaignToUpdate.Name = name;
            campaignToUpdate.Status__c = status;
            campaignToUpdate.Start_Date__c = startDate;
            campaignToUpdate.End_Date__c = endDate;
            campaignToUpdate.Budget__c = budget;
            update campaignToUpdate;
        } catch (Exception e) {
            System.debug('Error updating campaign: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to update campaign. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void deleteCampaign(Id campaignId) {
        try {
            // Validate input
            if (campaignId == null) {
                throw new AuraHandledException('Campaign ID is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Campaign__c campaignToDelete = [SELECT Id FROM Campaign__c WHERE Id = :campaignId LIMIT 1];
            delete campaignToDelete;
        } catch (Exception e) {
            System.debug('Error deleting campaign: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to delete campaign. Please contact your administrator.');
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects() {
        try {
            // Add security check
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            // Query with user context - include Campaign relationship
            return [SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Budget__c FROM Project__c ORDER BY CreatedDate DESC LIMIT 100];
        } catch (Exception e) {
            System.debug('Error retrieving projects: ' + e.getMessage());
            throw new AuraHandledException('Failed to retrieve projects data. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void createProject(String name, String status) {
        try {
            // Validate inputs
            if (String.isBlank(name) || String.isBlank(status)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Project__c newProject = new Project__c(Name = name, Status__c = status);
            insert newProject;
        } catch (Exception e) {
            System.debug('Error creating project: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to create project. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void updateProject(Id projectId, String name, String status) {
        try {
            // Validate inputs
            if (projectId == null || String.isBlank(name) || String.isBlank(status)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Project__c projectToUpdate = [SELECT Id, Name, Status__c FROM Project__c WHERE Id = :projectId LIMIT 1];
            projectToUpdate.Name = name;
            projectToUpdate.Status__c = status;
            update projectToUpdate;
        } catch (Exception e) {
            System.debug('Error updating project: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to update project. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void deleteProject(Id projectId) {
        try {
            // Validate input
            if (projectId == null) {
                throw new AuraHandledException('Project ID is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Project__c projectToDelete = [SELECT Id FROM Project__c WHERE Id = :projectId LIMIT 1];
            delete projectToDelete;
        } catch (Exception e) {
            System.debug('Error deleting project: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to delete project. Please contact your administrator.');
        }
    }

    // --- Legacy Billing CRUD methods for compatibility ---
    @AuraEnabled(cacheable=true)
    public static List<Billing__c> getBillings() {
        try {
            // Add security check
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            // Query with user context
            return [SELECT Id, Amount__c, Status__c FROM Billing__c ORDER BY CreatedDate DESC LIMIT 100];
        } catch (Exception e) {
            System.debug('Error retrieving billing data: ' + e.getMessage());
            throw new AuraHandledException('Failed to retrieve billing data. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void createBilling(Decimal amount, String status) {
        try {
            // Validate inputs
            if (amount == null || String.isBlank(status)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Billing__c newBilling = new Billing__c(Amount__c = amount, Status__c = status);
            insert newBilling;
        } catch (Exception e) {
            System.debug('Error creating billing: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to create billing record. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void updateBilling(Id billingId, Decimal amount, String status) {
        try {
            // Validate inputs
            if (billingId == null || amount == null || String.isBlank(status)) {
                throw new AuraHandledException('All fields are required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Billing__c billingToUpdate = [SELECT Id, Amount__c, Status__c FROM Billing__c WHERE Id = :billingId LIMIT 1];
            billingToUpdate.Amount__c = amount;
            billingToUpdate.Status__c = status;
            update billingToUpdate;
        } catch (Exception e) {
            System.debug('Error updating billing: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to update billing record. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static void deleteBilling(Id billingId) {
        try {
            // Validate input
            if (billingId == null) {
                throw new AuraHandledException('Billing record ID is required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            Billing__c billingToDelete = [SELECT Id FROM Billing__c WHERE Id = :billingId LIMIT 1];
            delete billingToDelete;
        } catch (Exception e) {
            System.debug('Error deleting billing: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to delete billing record. Please contact your administrator.');
        }
    }

    @AuraEnabled
    public static String fetchGoogleAdsData(String clientId, String clientSecret) {
        try {
            // Validate inputs
            if (String.isBlank(clientId) || String.isBlank(clientSecret)) {
                throw new AuraHandledException('Client ID and Secret are required.');
            }
            
            // Check user permissions
            if (!checkUserPermissions()) {
                throw new AuraHandledException('Access denied: Insufficient permissions.');
            }
            
            // Integration logic with Google Ads API goes here
            // For now, return a mock response
             return 'Google Ads data fetched for clientId: ' + clientId;
        } catch (Exception e) {
            System.debug('Error fetching Google Ads data: ' + e.getMessage());
            // Don't expose internal error details to users
            throw new AuraHandledException('Failed to fetch Google Ads data. Please contact your administrator.');
        }
    }
    
    // Helper method to validate email format
    private static Boolean isValidEmail(String email) {
        if (email == null) return false;
        Pattern emailPattern = Pattern.compile('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');
        return emailPattern.matcher(email).matches();
    }
    
    // Helper method to check user permissions
    private static Boolean checkUserPermissions() {
        // Check if user has appropriate profile or permission set
        String profileId = UserInfo.getProfileId();
        String userId = UserInfo.getUserId();
        
        // Allow access for specific profiles or permission sets
        // This is a basic check - in production you'd want more robust permission checking
        return profileId != null;
    }
}
