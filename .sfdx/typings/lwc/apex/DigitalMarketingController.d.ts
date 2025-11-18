declare module "@salesforce/apex/DigitalMarketingController.getDashboardData" {
  export default function getDashboardData(): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.getBillingData" {
  export default function getBillingData(): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.createBillingRecord" {
  export default function createBillingRecord(param: {amount: any, status: any, billingDate: any, clientId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.updateBillingRecord" {
  export default function updateBillingRecord(param: {billingId: any, amount: any, status: any, billingDate: any, clientId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.deleteBillingRecord" {
  export default function deleteBillingRecord(param: {billingId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.getLeads" {
  export default function getLeads(): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.createLead" {
  export default function createLead(param: {firstName: any, lastName: any, email: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.updateLead" {
  export default function updateLead(param: {leadId: any, firstName: any, lastName: any, email: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.deleteLead" {
  export default function deleteLead(param: {leadId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.getClients" {
  export default function getClients(): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.createClient" {
  export default function createClient(param: {name: any, email: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.updateClient" {
  export default function updateClient(param: {clientId: any, name: any, email: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.deleteClient" {
  export default function deleteClient(param: {clientId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.getCampaigns" {
  export default function getCampaigns(): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.createCampaign" {
  export default function createCampaign(param: {name: any, status: any, startDate: any, endDate: any, budget: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.updateCampaign" {
  export default function updateCampaign(param: {campaignId: any, name: any, status: any, startDate: any, endDate: any, budget: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.deleteCampaign" {
  export default function deleteCampaign(param: {campaignId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.getProjects" {
  export default function getProjects(): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.createProject" {
  export default function createProject(param: {name: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.updateProject" {
  export default function updateProject(param: {projectId: any, name: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.deleteProject" {
  export default function deleteProject(param: {projectId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.getBillings" {
  export default function getBillings(): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.createBilling" {
  export default function createBilling(param: {amount: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.updateBilling" {
  export default function updateBilling(param: {billingId: any, amount: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.deleteBilling" {
  export default function deleteBilling(param: {billingId: any}): Promise<any>;
}
declare module "@salesforce/apex/DigitalMarketingController.fetchGoogleAdsData" {
  export default function fetchGoogleAdsData(param: {clientId: any, clientSecret: any}): Promise<any>;
}
