import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AppWorkspace extends LightningElement {
    @track activeTabValue = 'home';
    
    connectedCallback() {
        // Initialize with a welcome message
        this.showToast('Welcome!', 'You are now using the enhanced Digital Marketing App with Lightning Experience features.', 'info');
    }
    
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }
}
