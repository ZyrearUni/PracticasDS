import 'package:practica3/account.dart';
import 'package:practica3/transaction.dart';
import 'dart:math';

class BankService {
  Map<String, Account> accountList = {};
  List<Transaction> transactionList = List.empty(growable: true);

  void createAccount (String owner) {
    Account toCreate = Account(owner);

    String number = "ES45";

    do {
      for (int i = 0; i < 4; i++) {
        final random = Random();
        final digits = random.nextInt(10000);

        number  += " ${digits.toString().padLeft(4, '0')}";
      }
    } while (accountList.containsKey(number));

    accountList[number] = toCreate;
  }

  void deposit(String accountNumber, double amount) {
    Transaction depositTransaction = DepositTransaction((transactionList.length+1).toString(), amount);
    depositTransaction.apply(accountList[accountNumber]!);
    transactionList.add(depositTransaction);
  }

  void withdraw(String accountNumber, double amount) {
    Transaction withdrawTransaction = WithdrawTransaction((transactionList.length+1).toString(), amount);
    withdrawTransaction.apply(accountList[accountNumber]!);
    transactionList.add(withdrawTransaction);
  }

  void transfer(String accountFrom, String toAccount, double amount) {
    Transaction transferTransaction = TransferTransaction((transactionList.length+1).toString(), amount, accountList[toAccount]!);
    transferTransaction.apply(accountList[accountFrom]!);
    transactionList.add(transferTransaction);
  }

  double getBalance(String accountNumber) {
    return accountList[accountNumber]!.balance;
  }
}