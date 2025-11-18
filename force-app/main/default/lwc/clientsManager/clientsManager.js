import { LightningElement, track, wire } from 'lwc';
import getClients from '@salesforce/apex/DigitalMarketingController.getClients';
import createClient from '@salesforce/apex/DigitalMarketingController.createClient';
import updateClient from '@salesforce/apex/DigitalMarketingController.updateClient';
import deleteClient from '@salesforce/apex/DigitalMarketingController.deleteClient';

export default class ClientsManager extends LightningElement {
    @track clients = [];
    @track error;
    @track clientName = '';
    @track clientId;

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

    handleCreateClient() {
        createClient({ name: this.clientName })
            .then(() => {
                this.clientName = '';
                return refreshApex(this.clients);
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleUpdateClient() {
        updateClient({ id: this.clientId, name: this.clientName })
            .then(() => {
                this.clientName = '';
                this.clientId = null;
                return refreshApex(this.clients);
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleDeleteClient(clientId) {
        deleteClient({ id: clientId })
            .then(() => {
                return refreshApex(this.clients);
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleEditClient(client) {
        this.clientName = client.Name;
        this.clientId = client.Id;
    }
}