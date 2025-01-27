//  基底クラスとapiデコレータをインポート
import { LightningElement, api } from 'lwc';
// createaAccountRecordメソッドをインポート
import createAccountRecord from '@salesforce/apex/AccountController.createAccountRecord';
// トースト通知を表示するためのモジュールをインポート
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class AccountCreator extends LightningElement {
    // 入力された取引先の値を格納するプロパティを定義 (慣習的に変数宣言ワードは付けない)
    accountNameForInsert = '';
    
    // 取引先名を変更したときに実行されるハンドラ関数
    handleNameChange(event) {
        // 入力フィールドの値を accountNameForInsert プロパティに代入
        this.accountNameForInsert = event.target.value;
    }
    // 取引先を作成ボタンを押したときに実行されるハンドラ関数
    handleCreateAccount() {
        // ApexのcreateAccountRecordメソッドを実行
        // ApexメソッドcreateAccountRecordの引数名がnameであるため、
        // オブジェクトリテラルでnameプロパティに値を設定。
        createAccountRecord({ name: this.accountNameForInsert })
            .then((result) => {
                console.log('作成した取引先ID: ' + result);
                this.accountNameForInsert = '';
                // 組み込みのdispatchEventを使用してトースト表示をする
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '成功',
                        message: '取引先が作成されました！ID: ' + result,
                        variant: 'success'
                    })
                );
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
