// 取引先レコードを取得するApexコード
public with sharing class AccountController {
    @AuraEnabled (cacheable = true)

    public static List<Account> getAccountRecords() {
    // Get All Account Records
        List<Account> accountList = [SELECT Id, Name, Phone, Website
                                        FROM ACcount];
        return accountList;
    }
    // 取引先レコードを作成する
    public static Id createAccountRecord(String name) {
        // 取引先名のチェック
        if (String.isBlank(name)) {
            AuraHandledException e = new AuraHandledException('取引先名は必須です。');
            e.setMessage('取引先名は必須です。');
            throw e;
        }

        // 取引先レコードの作成
        Account acct = new Account(Name = name);
        insert acct;

        return acct.Id;
    }
    
    // 指定した名前を持つ取引先レコードを取得する
    public static Account getAccountRecord(String name) {
        // 取引先名がない場合エラー処理
        if (String.isBlank(name)) {
            AuraHandledException e = new AuraHandledException('取引先名は必須です。');
            e.setMessage('取引先名は必須です。');
            throw e;
        }
        // 取引先を1つだけ取得
        Account acct = [SELECT Id, Name FROM Account WHERE Name = :name LIMIT 1];
        return acct;
    }

    // 取引先の電話番号を更新する
    public static void updateAccountRecord(String name, String phone) {
        // 引数の名前を持つ取引先レコードを取得
        List<Account> accts = [SELECT Id, Name, Phone FROM Account WHERE Name = :name LIMIT 1];

        // 名前が空白、空文字列、nullのときはエラーをスロー
        if (String.isBlank(name)) {
            AuraHandledException e = new AuraHandledException('取引先名は必須です。');
            e.setMessage('取引先名は必須です。');
            throw e;
        }
        // 取引先名をもつ取引先がない場合
        if (accts.size() == 0) {
            // AuraHandledExceptionエラーをスロー
            AuraHandledException e = new AuraHandledException('取引先が存在しません。');
            e.setMessage('取引先が存在しません。');
            throw e;
        }
        
        Account acct = accts[0];
        acct.phone = phone;
        update acct;
    }
    // 指定した名前の取引先レコードを削除する
    public static void deleteAccountRecord(String name) {
        if (String.isBlank(name)) {
            // 引数が空文字列のときエラーをスローする
            IllegalArgumentException e = new IllegalArgumentException('取引先名は必須です。');
            e.setMessage('取引先名は必須です。');
            throw e;
        }
        // 削除対象のレコードを取得
        List<Account> accts = [SELECT Id, Name FROM Account WHERE name = :name];
        if (accts.size() == 0) {
            AuraHandledException e = new AuraHandledException('取引先レコードが存在しません。');
            e.setMessage('取引先レコードが存在しません。');
            throw e;
        }

        // 対象の取引先レコードを削除
        delete accts;
    }
}