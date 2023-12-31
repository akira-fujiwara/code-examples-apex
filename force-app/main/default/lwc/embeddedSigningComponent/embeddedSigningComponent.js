import { LightningElement, api } from 'lwc';
import sendEnvelope from '@salesforce/apex/EmbeddedSigningController.sendEnvelope';
import getEmbeddedSigningUrl from '@salesforce/apex/EmbeddedSigningController.getEmbeddedSigningUrl';

export default class EmbeddedSigningComponent extends LightningElement {

 //   template = '2712xxxx-xxxx-xxxx-xxxx-xxxxf9b8fa5f';
    template = 'dbcc4170-9533-4e3d-9471-fd7cf8e02601';

    description = 'Embedded Signing';
    @api recordId;
    handleClick() {
        sendEnvelope({template: this.template, description: this.description, recordId: this.recordId})
            .then((envelopeId) => (
                getEmbeddedSigningUrl({
                    envId: envelopeId, 
                    url: window.location.href
                })
            ))
            .then((signingUrl) => {
                window.location.href = signingUrl;
            })
            .catch((error) => {
                console.log('Error:');
                console.log(error);
            });
    }
}