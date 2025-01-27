import { LightningElement, api } from 'lwc';
import deleteAccountRecord from '@salesforce/apex/AccountController.deleteAccountRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountDeletor extends LightningElement {
    accountNameForDelete = '';

    // 入力フィールドに値が入力されたときのハンドラー
    handleInputNameChange(event) {
        this.accountNameForDelete = event.target.value;
    }

    handleDeleteAccountRecord() {
        // ApexのdeleteAccountRecordを呼び出し
        deleteAccountRecord({name: this.accountNameForDelete})
            .then(() => {
                console.log('削除に成功しました。');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '成功',
                        message: '取引先の削除に成功しました。',
                        variant: 'success'
                    })
                );
                this.accountNameForDelete = '';
                this.template.querySelector('lightning-input').value = this.accountNameForDelete;
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '失敗',
                        message: '削除に失敗しました。' + error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}