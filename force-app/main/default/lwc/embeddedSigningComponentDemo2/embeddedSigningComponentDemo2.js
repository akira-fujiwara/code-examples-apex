import { LightningElement, api , wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Account.SigingUrl__c'];

import sendEnvelope2 from '@salesforce/apex/EmbeddedSigningController2.sendEnvelope2';
import { updateRecord } from 'lightning/uiRecordApi';
export default class EmbeddedSigningComponent extends LightningElement {

 //   template = '2712xxxx-xxxx-xxxx-xxxx-xxxxf9b8fa5f';
    template = 'dbcc4170-9533-4e3d-9471-fd7cf8e02601';

    description = 'Embedded Signing';
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    account;
    get SigningUrl() {
        return this.account.data.fields.SigningUrl__c.value;
    }
    handleClick() {
        alert('clicked');
        sendEnvelope2({template: this.template, description: this.description, recordId: this.recordId, url: this.window.location.href})
            .then((signingUrl) => {
                alert('url = ' + signingUrl);
                window.location.href = signingUrl;
            }).catch((error) => {
                console.log('Error:');
                console.log(error);
            });
        alert('called');
    }
}