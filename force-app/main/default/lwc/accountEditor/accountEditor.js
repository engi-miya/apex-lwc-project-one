import { LightningElement, api } from 'lwc';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import EMAIL_FIELD from '@salesforce/schema/Account.Website';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';


export default class AccountEditor extends LightningElement {
    // レコードページが提供するrecordId, objectApiName
    @api recordId;
    @api objectApiName;

    fields = [NAME_FIELD, PHONE_FIELD, EMAIL_FIELD, INDUSTRY_FIELD];

    handleSubmit(event) {
        // event.preventDefault();
        const fields = event.detail.fields;
        try {
            this.template.querySelector('lightning-record-form').submit(fields);
        } catch (error) {
            console.log(error.message);
        }
    }
}