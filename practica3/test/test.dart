import 'package:flutter_test/flutter_test.dart';

import 'package:practica3/account.dart';
import 'package:practica3/bankservice.dart';
import 'package:practica3/transaction.dart';


void main() {
  group('Account tests', () {
    test('Balance inicial es cero', () {
      Account test = Account("titular");
      expect(test.balance, equals(0));
    });

    test('No se permite depositar cantidades negativas o 0', () {
      expect(() => DepositTransaction("id", -1), throwsStateError);
      expect(() => DepositTransaction("id", 0), throwsStateError);
    });

    test('No se permite retirar cantidades negativas o cero', () {
      expect(() => WithdrawTransaction("id", -1), throwsStateError);
      expect(() => WithdrawTransaction("id", 0), throwsStateError);
    });
  });

  group('Transaction tests', () {
    test('DepositTransaction aumenta el saldo correctamente', () {
      Account test = Account("titular");
      Transaction transTest = DepositTransaction("id", 10);
      transTest.apply(test);
      expect(test.balance, equals(10));
    });

    test('WithdrawalTransaction lanza StateError cuando hay fondos insuficientes', () {
      Account test = Account("titular");
      Transaction transTest = WithdrawTransaction("id", 10);
      expect(() => transTest.apply(test), throwsStateError);
    });

    test('TransferTransaction mueve fondos correctamente', () {
      Account test = Account("titular");
      Transaction transTest = TransferTransaction("id", 10, Account("owner"));
      expect(() => transTest.apply(test), throwsStateError);
    });
  });

  group('BankService tests', () {
    test('La lista inicial de cuentas está vacía', () {
      BankService test = BankService();
      expect(test.accountList.isEmpty, true);
    });

    test('Deposit aumenta el saldo de la cuenta', () {
      BankService test = BankService();
      Account testAcc = Account("owner");
      test.accountList["test"] = testAcc;
      test.deposit("test", 10);
      expect(test.accountList["test"]!.balance, equals(10));
    });

    test('withdraw lanza StateError cuando el saldo es insuficiente', () {
      BankService test = BankService();
      Account testAcc = Account("owner");
      test.accountList["test"] = testAcc;
      expect(() => test.withdraw("test", 10), throwsStateError);
    });

    test('Transfer mueve fondos correctamente', () {
      BankService test = BankService();
      Account testAcc1 = Account("owner");
      Account testAcc2 = Account("owner");
      testAcc2.balance = 10;
      test.accountList["test1"] = testAcc1;
      test.accountList["test2"] = testAcc2;

      test.transfer("test2", "test1", 5);
      expect(test.accountList["test1"]!.balance,equals(5));
      expect(test.accountList["test2"]!.balance, equals(5));
    });

    test('Transfer lanza StateError cuando los fondos son insuficientes', () {
      BankService test = BankService();
      Account testAcc1 = Account("owner");
      Account testAcc2 = Account("owner");
      testAcc2.balance = 10;
      test.accountList["test1"] = testAcc1;
      test.accountList["test2"] = testAcc2;
      expect(() => test.transfer("test2", "test1", 100), throwsStateError);
    });

    test('El id de la transacción es único', () {
      BankService test = BankService();
      Account testAcc = Account("owner");
      test.accountList["test"] = testAcc;
      for(int i = 0; i < 1000; i++) {
        test.deposit("test", 10);
      }

      //Recolectar ids
      final ids = test.transactionList.map((transaction) => transaction.id).toSet();
      expect(ids.length, equals(test.transactionList.length));
    });
  });
}