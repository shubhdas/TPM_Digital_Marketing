import { LightningElement, wire, track } from 'lwc';
import getDashboardData from '@salesforce/apex/DigitalMarketingController.getDashboardData';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import dashboardStyles from '@salesforce/resourceUrl/DashboardStyles';

export default class AdminDashboard extends LightningElement {
    @track dashboardData;
    @track error;
    @track personalizedView = true;
    @track showQuickActions = true;
    @track selectedWidgets = ['leads', 'clients', 'campaigns', 'projects', 'billing'];

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

    connectedCallback() {
        // Load custom styles
        loadStyle(this, dashboardStyles);
        this.loadUserPreferences();
    }

    loadUserPreferences() {
        // Try to load user preferences from localStorage
        try {
            const prefs = localStorage.getItem('adminDashboardPrefs');
            if (prefs) {
                const parsedPrefs = JSON.parse(prefs);
                this.personalizedView = parsedPrefs.personalizedView !== false; // Default to true
                this.showQuickActions = parsedPrefs.showQuickActions !== false; // Default to true
                if (parsedPrefs.selectedWidgets) {
                    this.selectedWidgets = parsedPrefs.selectedWidgets;
                }
            }
        } catch (error) {
            console.error('Error loading user preferences:', error);
        }
    }

    saveUserPreferences() {
        // Save user preferences to localStorage
        try {
            const prefs = {
                personalizedView: this.personalizedView,
                showQuickActions: this.showQuickActions,
                selectedWidgets: this.selectedWidgets
            };
            localStorage.setItem('adminDashboardPrefs', JSON.stringify(prefs));
        } catch (error) {
            console.error('Error saving user preferences:', error);
        }
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
            
            // Show error toast
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Failed to load dashboard data',
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
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

    // Personalization handlers
    handleTogglePersonalizedView() {
        this.personalizedView = !this.personalizedView;
        this.saveUserPreferences();
    }

    handleToggleQuickActions() {
        this.showQuickActions = !this.showQuickActions;
        this.saveUserPreferences();
    }

    handleWidgetSelection(event) {
        const widgetName = event.target.value;
        const index = this.selectedWidgets.indexOf(widgetName);
        
        if (index === -1) {
            this.selectedWidgets.push(widgetName);
        } else {
            this.selectedWidgets.splice(index, 1);
        }
        
        this.saveUserPreferences();
    }

    // Getters for conditional rendering
    get showLeadsWidget() {
        return this.selectedWidgets.includes('leads');
    }

    get showClientsWidget() {
        return this.selectedWidgets.includes('clients');
    }

    get showCampaignsWidget() {
        return this.selectedWidgets.includes('campaigns');
    }

    get showProjectsWidget() {
        return this.selectedWidgets.includes('projects');
    }

    get showBillingWidget() {
        return this.selectedWidgets.includes('billing');
    }
}
