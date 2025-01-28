@IsTest
private class AccountControllerTest {
  // テストデータを作成する
  @TestSetup
  private static void setupTestData() {
    List<Account> testAccounts = new List<Account>();
    for (Integer i = 0; i < 10; i++) {
      testAccounts.add(
        new Account(
          Name = 'test取引先' + i,
          Phone = '03-1234-6789' + i,
          Website = 'www.test' + i + '.com'
        )
      );
    }
    insert testAccounts;
  }

  // 取引先アカウント作成_正常系
  @IsTest
  private static void testCreateAccountRecord_positive() {
    // テストメソッドの実装
    Test.startTest();
    String testName = 'test1';
    AccountController.createAccountRecord(testName);

    // 取引先名がないとき
    // testName取引先取得
    Account testAccount = [SELECT Id, Name FROM Account WHERE Name = :testName LIMIT 1];
    // アサーション
    Assert.areEqual('test1', testAccount.Name, '取引先名が一致しません。');
    Test.stopTest();
  }
  // 取引先アカウント作成_異常系
  @IsTest
  private static void testCreateAccountRecord_negative() {
    // テストデータの作成
    String name = '';

    // 例外がスローされることを確認
    Boolean caughtException = false;

    try {
      AccountController.createAccountRecord(name);
    } catch (AuraHandledException e) {
      caughtException = true;
      Assert.areEqual('取引先名は必須です。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
    Assert.isTrue(caughtException, '例外がスローされませんでした。');
  }

  // 取引先1レコード取得_正常系
  @IsTest
  private static void testGetAccountRecord_positive() {
    // テストデータの作成
    Account testAccount = new Account(Name = 'ToGet');
    insert testAccount;

    // テストの実行
    String testName = 'ToGet';
    Account gotAccount = AccountController.getAccountRecord(testName);

    // アサーション
    Assert.areEqual('ToGet', testAccount.Name, '取引先名が一致しません。');
  }
  @IsTest
  // 取引先1レコード取得_異常系
  private static void testGetAccount_negative() {
    // 取引先名が空欄のデータ作成
    String emptyName = '';
    // 例外がスローされることを確認
    Boolean caughtException = false;
    try {
      // コードを実行
      AccountController.getAccountRecord(emptyName);
    } catch (AuraHandledException e) {
      caughtException = true;
      Assert.areEqual(
        '取引先名は必須です。',
        e.getMessage(),
        'エラーメッセージが一致しません。'
      );
    }
    Assert.isTrue(caughtException, '例外がスローされませんでした。');
  }
  
  // 複数の取引先レコードを取得_正常系
  @isTest
  private static void testGetAccountRecords_positive() {
    // テストスタート
    Test.startTest();
    // テストレコードを作成
    // setupTestData();
    // 取引先名に'test'を含むレコードを取得
    List<Account> testAccounts = AccountController.getAccountRecords('test');
    // レコード数を比較
    Assert.areEqual(10, testAccounts.size(), 'レコードの数が違います。');
    Test.stopTest();
  }

  // 複数の取引先レコードを取得_異常系
  // 存在しない取引先名を引数にしたとき
  @isTest
  private static void getAccountRecords_invalidAccountName() {
    Test.startTest();
    // 存在しないレコード軍を取得
    List<Account> testAccounts = AccountController.getAccountRecords('ありえん');
    // サイズが0のはず
    Assert.areEqual(0, testAccounts.size(), 'レコード数が0ではありません。');
    Test.stopTest();
  }

  // 引数が空文字列またはnullのとき
  @IsTest
  private static void getAccountRecords_accountNameIsEmpty() {
    String emptyAccountName = '';
    Test.startTest();
    try {
      List<Account> testAccounts = AccountController.getAccountRecords(emptyAccountName);
      Assert.fail();
    } catch (IllegalArgumentException e) {
      Assert.areEqual('取引先名は必須です。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
    Test.stopTest();
  }



  // 取引先レコードを更新_正常系
  // ユーザーが期待する通りの動きをした場合のテスト
  @IsTest
  private static void testUpdateAccountRecord_positive() {
    // テスト用の取引先レコードを作成
    Account testAccount = new Account(Name = 'Miyahara', Phone = '09069880982');
    insert testAccount;
    // 何をテストすればよいか？レコードが更新されること
    // 更新したいレコードを取得
    Account acct = [
      SELECT Id, Name, Phone
      FROM Account
      WHERE Name = 'Miyahara'
      LIMIT 1
    ];

    // プロダクションコードを実行
    // 指定した名前をもつ取引先レコードの電話番号を更新する
    String testName = 'Miyahara';
    String testPhone = '09000000000';
    AccountController.updateAccountRecord(testName, testPhone);

    // 再度レコードを取得
    acct = [
      SELECT Id, Name, Phone
      FROM Account
      WHERE Id = :acct.Id
    ];

    // アサーション
    // Phoneが更新されていることを確認する
    Assert.areEqual('09000000000', acct.Phone, '電話番号が一致しません。');
  }

  @IsTest
  // 取引先レコードを更新_異常系
  // ユーザーが誤った操作や予期せぬ状況が発生した場合のテスト
  // nameがnullか空文字の場合、AuraHandleExceptionエラーがスローされること
  private static void testUpdateAccountRecord_emptyName() {
    // nameが空文字の場合
    Boolean caughtException = false;
    try {
        AccountController.updateAccountRecord(null, '09000004444');
    } catch (AuraHandledException e) {
        caughtException = true;
        Assert.areEqual('取引先名は必須です。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
    Assert.isTrue(caughtException, '例外がスローされませんでした。');
  }

  @IsTest
  // 取引先名をもつレコードが見つからなかった場合  
  private static void testUpdateAccountRecord_accountNotFound() {
    // 
    Account miyaAccount = new Account(Name = 'engimiya', Phone = '01011111111');
    insert miyaAccount;
    // 取引先がない場合
    Boolean caughtException = false;
    try {
        AccountController.updateAccountRecord('存在しない名前', '090900000000');
    } catch (AuraHandledException e) {
        caughtException = true;
        Assert.areEqual('取引先が存在しません。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
    Assert.isTrue(caughtException, '例外がスローされませんでした。');
  }

  @IsTest
  // 取引先レコードを削除する正常系のテスト
  private static void testDeleteAccountRecord_positive() {
    // テスト用のあ取引先レコードを作成
    Account testForDeleteAccount = new Account(Name = 'for delete');
    insert testForDeleteAccount;
    // 正しい引数を与えて、レコードがあった場合、取引先レコードが削除されるはず
    // コード実行
    String nameForDelete = 'for delete';
    AccountController.deleteAccountRecord(nameForDelete);
    // 取引先レコードが削除されるはずアサーション (Sizeが0であること)
    List<Account> accts =  [SELECT Id FROM Account WHERE Name = :nameForDelete];
    Assert.areEqual(0, accts.size(), '取引先レコードが削除されていません。');
  }

  @IsTest
  // 取引先レコードを削除する異常系のテスト
  // 取引先がない場合
  private static void testDeleteAccountRecord_accountNotFound() {
    // 正しい引数を与えて、レコードがない場合、エラーが表示されるはず
    String notExistAccountName = 'not exist name';

    Test.startTest();
    try {
      AccountController.deleteAccountRecord(notExistAccountName);
    } catch (AuraHandledException e) {
      // エラーが発生するはず
      Assert.areEqual('取引先レコードが存在しません。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
    Test.stopTest();
  }

  @IsTest
  // 引数が空文字列場合
  // エラーが表示されるはず
  private static void testDeleteAccountRecord_NameIsEmpty() {
    // 
    Test.startTest();
    try {
      // 空文字を渡して、IllegalArgumentExceptionが発生することを期待
      AccountController.deleteAccountRecord('');
    } catch(IllegalArgumentException e) {
      System.debug('IllegalArgumentExceptionが発生しました。');
      Assert.areEqual('取引先名は必須です。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
    Test.stopTest();
  }

  @IsTest
  // 引数が空文字列場合
  // エラーが表示されるはず
  private static void testDeleteAccountRecord_ArgIsNull() {
    // ガバナ制限をリセットするため
    Test.startTest();

    try {
      // 引数をnullに設定してコードを実行
      // catchの中にいくはず
      AccountController.deleteAccountRecord(null);
    } catch (IllegalArgumentException e) {
      // エラーが発生していることを確認する
      Assert.areEqual('取引先名は必須です。', e.getMessage(), 'エラーメッセージが一致しません。');
    }

    Test.stopTest();
  }

  // 取引先レコードのIndustoryを更新するメソッド_正常系
  // Idが一致する取引先レコードのIndustoryを更新する
  @IsTest
  private static void testUpdateAccountIndustry_positive() {
    // テスト取引先を取得
    Account testAccount = [SELECT id FROM Account WHERE Name = 'test取引先1'];
    Id idForTest = testAccount.Id;
    // Bankingをテスト値として使用
    String testIndustryValue = 'Banking';

    AccountController.updateAccountIndustry(idForTest, testIndustryValue);
    // Assertion
    Account afterUpdateAccount = [SELECT Id, Industry FROM Account WHERE Id = :idForTest];
    Assert.areEqual('Banking', afterUpdateAccount.Industry, 'Industryの値が違います。');
  }
  // 取引先レコードのIndustoryを更新するメソッド_異常系
  @IsTest
  private static void testUpdateAccountIndustry_industryIsEmpty() {
    Account testAccount = [SELECT id FROM Account WHERE Name = 'test取引先1'];
    Id idForTest = testAccount.Id;

    // 更新する値が選択されていないときをnullとする
    String testNullIndstry = null;

    // 処理実行。例外処理がおこなわれてエラーがスローされるはず
    try {
      AccountController.updateAccountIndustry(idForTest, testNullIndstry);
      Assert.fail('NNullPointerException is detected.');
    } catch (AuraHandledException e) {
      Assert.areEqual('Industryが選択されていません。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
  }
  // 無効なIdのとき例外処理がされるはず
  @IsTest
  private static void testUpdateAccountIndustry_InvalidId() {
    String validIndustryValue = 'Finance';
    // 無効なIdを引数に処理を実行。無効なIdですよという例外処理がされるはず
    try {
      AccountController.updateAccountIndustry('003IR00001jzvirYAA', validIndustryValue);
      Assert.fail('AuraHandledException is detected.');
    } catch (AuraHandledException e) {
      Assert.areEqual('取引先IDが無効です。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
  }
  // Idが空文字列、nullのとき例外処理がされるはず
  @IsTest
  private static void testUpdateAccountIndustry_idIsEmpty() {
    // Industryには正常値を設定
    String validIndustryValue = 'Finance';
    // Id部分に空文字を設定して実行。
    try {
      AccountController.updateAccountIndustry('', validIndustryValue);
      Assert.fail('');
    } catch (AuraHandledException e) {
      // 例外処理のメッセージが一致するはず。
        Assert.areEqual('取引先IDは必須です。', e.getMessage(), 'エラーメッセージが一致しません。');
    }
  }
}