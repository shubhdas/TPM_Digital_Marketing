import { LightningElement, track } from 'lwc';
import fetchGoogleAdsData from '@salesforce/apex/DigitalMarketingController.fetchGoogleAdsData';

export default class GoogleAdsIntegration extends LightningElement {
    @track adsData;
    @track error;

    connectedCallback() {
        this.loadGoogleAdsData();
    }

    loadGoogleAdsData() {
        fetchGoogleAdsData()
            .then(result => {
                this.adsData = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.adsData = undefined;
            });
    }
}