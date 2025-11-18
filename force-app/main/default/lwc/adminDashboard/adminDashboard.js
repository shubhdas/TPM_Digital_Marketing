import { LightningElement, wire, track } from 'lwc';
import getDashboardData from '@salesforce/apex/DigitalMarketingController.getDashboardData';
import { NavigationMixin } from 'lightning/navigation';

export default class AdminDashboard extends LightningElement {
    @track dashboardData;
    @track error;

    get hasData() {
        return this.dashboardData && (
            this.leadsCount !== undefined ||
            this.clientsCount !== undefined ||
            this.campaignsCount !== undefined ||
            this.projectsCount !== undefined ||
            this.billingCount !== undefined
        );
    }

    get leadsCount() {
        return this.dashboardData ? this.dashboardData.leadCount : 0;
    }
    get clientsCount() {
        return this.dashboardData ? this.dashboardData.clientCount : 0;
    }
    get campaignsCount() {
        return this.dashboardData ? this.dashboardData.campaignCount : 0;
    }
    get projectsCount() {
        return this.dashboardData ? this.dashboardData.projectCount : 0;
    }
    get billingCount() {
        return this.dashboardData ? this.dashboardData.billingCount : 0;
    }

    @wire(getDashboardData)
    wiredDashboardData({ error, data }) {
        if (data) {
            this.dashboardData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.dashboardData = undefined;
            // eslint-disable-next-line no-console
            console.error('Error fetching dashboard data', error);
        }
    }

    // Navigation methods using NavigationMixin
    navigateToLeads() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__leadsManager'
            }
        });
    }

    navigateToClients() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__clientsManager'
            }
        });
    }

    navigateToCampaigns() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__campaignsManager'
            }
        });
    }

    navigateToProjects() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__projectsManager'
            }
        });
    }

    navigateToBilling() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__billingManager'
            }
        });
    }

    navigateToGoogleAds() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__googleAdsIntegration'
            }
        });
    }
}
