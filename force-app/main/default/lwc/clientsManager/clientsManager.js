import { LightningElement, track, wire } from 'lwc';
import getClients from '@salesforce/apex/DigitalMarketingController.getClients';
import createClient from '@salesforce/apex/DigitalMarketingController.createClient';
import updateClient from '@salesforce/apex/DigitalMarketingController.updateClient';
import deleteClient from '@salesforce/apex/DigitalMarketingController.deleteClient';
import { refreshApex } from '@salesforce/apex';

export default class ClientsManager extends LightningElement {
    @track clients = [];
    @track error;
    @track clientName = '';
    @track clientEmail = '';
    @track clientId;
    
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Email', fieldName: 'Client_Email__c', type: 'email' },
        { label: 'Phone', fieldName: 'Client_Phone__c', type: 'phone' },
        { label: 'Address', fieldName: 'Client_Address__c', type: 'text' },
        { label: 'Status', fieldName: 'Client_Status__c', type: 'text' },
        { type: 'action', typeAttributes: { rowActions: [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ]}}
    ];

    @wire(getClients)
    wiredClients({ error, data }) {
        if (data) {
            this.clients = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.clients = [];
        }
    }

    handleClientNameChange(event) {
        this.clientName = event.target.value;
    }

    handleClientEmailChange(event) {
        this.clientEmail = event.target.value;
    }

    handleCreateClient() {
        createClient({ name: this.clientName, email: this.clientEmail })
            .then(() => {
                this.clientName = '';
                this.clientEmail = '';
                return refreshApex(this.wiredClients);
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleUpdateClient() {
        updateClient({ clientId: this.clientId, name: this.clientName, email: this.clientEmail })
            .then(() => {
                this.clientName = '';
                this.clientEmail = '';
                this.clientId = null;
                return refreshApex(this.wiredClients);
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleDeleteClient(clientId) {
        deleteClient({ clientId: clientId })
            .then(() => {
                return refreshApex(this.clients);
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleEditClient(client) {
        this.clientName = client.Name;
        this.clientEmail = client.Client_Email__c;
        this.clientId = client.Id;
    }
    
    handleRowAction(event) {
        const action = event.detail.action;
        const client = event.detail.row;
        switch (action.name) {
            case 'edit':
                this.handleEditClient(client);
                break;
            case 'delete':
                this.handleDeleteClient(client.Id);
                break;
            default:
                break;
        }
    }
    
    handleNewClient() {
        this.clientName = '';
        this.clientEmail = '';
        this.clientId = null;
    }
}
