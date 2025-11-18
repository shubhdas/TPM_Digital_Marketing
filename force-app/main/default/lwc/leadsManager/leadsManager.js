import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getLeads from '@salesforce/apex/DigitalMarketingController.getLeads';
import createLead from '@salesforce/apex/DigitalMarketingController.createLead';
import updateLead from '@salesforce/apex/DigitalMarketingController.updateLead';
import deleteLead from '@salesforce/apex/DigitalMarketingController.deleteLead';

export default class LeadsManager extends LightningElement {
    @track leads = [];
    @track error;
    @track newLead = { FirstName: '', LastName: '', Email: '' };
    @track isModalOpen = false;

    wiredResult; // holds the wired apex result for refreshApex

    // Columns definition for the datatable
    columns = [
        { label: 'First Name', fieldName: 'FirstName', type: 'text' },
        { label: 'Last Name', fieldName: 'LastName', type: 'text' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Status', fieldName: 'Status', type: 'text' },
        { type: 'action', typeAttributes: { rowActions: [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ]}}
    ];

    get hasData() {
        return Array.isArray(this.leads) && this.leads.length > 0;
    }

    connectedCallback() {
        // Load leads when component connects
        this.loadLeads();
    }

    @wire(getLeads)
    wiredLeads(result) {
        this.wiredResult = result;
        const { data, error } = result;
        if (data) {
            // Add data sanitization for security
            this.leads = this.sanitizeLeadsData(data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.leads = [];
            console.error('Error loading leads:', error);
        }
    }

    // Sanitize leads data to prevent XSS attacks
    sanitizeLeadsData(leadsData) {
        return leadsData.map(lead => {
            return {
                Id: lead.Id,
                FirstName: this.escapeHtml(lead.FirstName),
                LastName: this.escapeHtml(lead.LastName),
                Email: this.escapeHtml(lead.Email),
                Status: this.escapeHtml(lead.Status)
            };
        });
    }

    // Helper method to escape HTML to prevent XSS
    escapeHtml(text) {
        if (!text) return text;
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    loadLeads() {
        // The wired Apex method handles data loading, but we can refresh it explicitly
        if (this.wiredResult) {
            refreshApex(this.wiredResult);
        }
    }

    handleInputChange(event) {
        const field = event.target.name;
        // Add input sanitization
        this.newLead[field] = this.escapeHtml(event.target.value);
    }

    async handleCreateLead() {
        try {
            // Validate inputs before sending to server
            if (!this.validateLeadInput(this.newLead)) {
                throw new Error('Invalid lead data provided');
            }
            
            await createLead({ 
                firstName: this.escapeHtml(this.newLead.FirstName), 
                lastName: this.escapeHtml(this.newLead.LastName), 
                email: this.escapeHtml(this.newLead.Email) 
            });
            
            this.isModalOpen = false;
            this.newLead = { FirstName: '', LastName: '', Email: '' };
            await refreshApex(this.wiredResult);
        } catch (error) {
            this.error = error;
            console.error('Error creating lead:', error);
        }
    }

    // Input validation for lead creation
    validateLeadInput(lead) {
        if (!lead.FirstName || !lead.LastName || !lead.Email) {
            return false;
        }
        // Basic email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(lead.Email);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'edit') {
            this.handleUpdateLead({detail: {row}});
        } else if (actionName === 'delete') {
            this.handleDeleteLead(row.Id);
        }
    }

    async handleUpdateLead(event) {
        try {
            const lead = event.detail.row;
            // Sanitize data before sending to server
            await updateLead({ 
                leadId: lead.Id, 
                firstName: this.escapeHtml(lead.FirstName), 
                lastName: this.escapeHtml(lead.LastName), 
                email: this.escapeHtml(lead.Email),
                status: this.escapeHtml(lead.Status)
            });
            await refreshApex(this.wiredResult);
        } catch (error) {
            this.error = error;
            console.error('Error updating lead:', error);
        }
    }

    async handleDeleteLead(leadId) {
        try {
            // Confirm deletion
            const confirmed = confirm('Are you sure you want to delete this lead?');
            if (!confirmed) return;
            
            await deleteLead({ leadId });
            await refreshApex(this.wiredResult);
        } catch (error) {
            this.error = error;
            console.error('Error deleting lead:', error);
        }
    }

    handleNewLead() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}
