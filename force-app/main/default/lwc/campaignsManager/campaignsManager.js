import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getCampaigns from '@salesforce/apex/DigitalMarketingController.getCampaigns';
import createCampaign from '@salesforce/apex/DigitalMarketingController.createCampaign';
import updateCampaign from '@salesforce/apex/DigitalMarketingController.updateCampaign';
import deleteCampaign from '@salesforce/apex/DigitalMarketingController.deleteCampaign';

const ACTIONS = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' }
];

export default class CampaignsManager extends LightningElement {
    // state
    @track campaigns = [];
    @track filteredCampaigns = [];
    @track error;
    @track isModalOpen = false;
    @track editRecordId = null;
    @track searchKey = '';

    wiredResult; // holds the wired apex result for refreshApex

    // columns including row actions and status badge rendering
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Status', fieldName: 'Status__c', type: 'text' },
        { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' },
        { label: 'End Date', fieldName: 'End_Date__c', type: 'date' },
        { label: 'Budget', fieldName: 'Budget__c', type: 'currency' },
        { type: 'action', typeAttributes: { rowActions: ACTIONS } }
    ];

    get hasData() {
        return Array.isArray(this.filteredCampaigns) && this.filteredCampaigns.length >= 0;
    }

    get errorMessage() {
        return this.error ? (this.error.body ? this.error.body.message : this.error.message) : '';
    }

    get modalTitle() {
        return this.editRecordId ? 'Edit Campaign' : 'New Campaign';
    }

    @wire(getCampaigns)
    wiredCampaigns(result) {
        this.wiredResult = result;
        const { data, error } = result;
        if (data) {
            this.error = undefined;
            this.campaigns = data;
            this.applyFilter();
        } else if (error) {
            this.error = error;
            this.campaigns = [];
            this.filteredCampaigns = [];
        }
    }

    // UI handlers
    handleSearchChange(event) {
        this.searchKey = event.target.value || '';
        this.applyFilter();
    }

    applyFilter() {
        const key = (this.searchKey || '').toLowerCase();
        this.filteredCampaigns = (this.campaigns || []).filter(c => {
            return !key || (c.Name && c.Name.toLowerCase().includes(key));
        });
    }

    handleNewClick() {
        this.editRecordId = null;
        this.isModalOpen = true;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'edit') {
            this.editRecordId = row.Id;
            this.isModalOpen = true;
        } else if (actionName === 'delete') {
            this.handleDelete(row.Id);
        }
    }

    closeModal() {
        this.isModalOpen = false;
        this.editRecordId = null;
    }

    async handleFormSuccess() {
        this.isModalOpen = false;
        await refreshApex(this.wiredResult);
    }

    handleFormError(event) {
        this.error = event.detail;
    }

    // Legacy imperative actions (kept if needed elsewhere)
    async handleDelete(campaignId) {
        try {
            await deleteCampaign({ campaignId });
            await refreshApex(this.wiredResult);
        } catch (e) {
            this.error = e;
        }
    }
}
