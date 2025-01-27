// 基底クラスをインポート
import { LightningElement, api } from 'lwc';
// ApexのgetAccountRecordsをインポート
import getAccountRecords from '@salesforce/apex/AccountController.getAccountRecords';
// トースト表示するためのモジュールをインポート
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Id, Name, Phone, Website
const columns = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Phone', fieldName: 'Phone'},
    { label: 'Website', fieldName: 'website'}
];

export default class AccountGetter extends LightningElement {
    accoutName = '';
    columns = columns;
    data = [];

    // 取引先の入力が変わったときに発生するイベントハンドラー関数
    handleChangeAccountName(event) {
        this.accoutName = event.target.value;
    }

    //取引先を検索ボタンを押したときに発生するイベントハンドラー関数
    handleGetAccountRecords() {
        getAccountRecords({name: this.accoutName})
            .then((result) => {
                // 取得した取引先の数
                console.log('表示した取引先の数: ' + result.length);
                // 取得したレコードを格納
                this.data = result;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '成功',
                        message: result.length + ' 件 取引先レコードを表示しました。' + this.data[0].Name,
                        variant: 'success'
                    })
                );
                this.accoutName = '';
                this.template.querySelector('lightning-input').value = this.accoutName;
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'エラー',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}