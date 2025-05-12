import 'package:practica3/account.dart';

abstract class Transaction {
  String id = "";
  double amount = 0.0;

  Transaction(double amount) {
    if(amount >= 0) {
      this.amount = amount;
    } else {
      throw StateError("Cannot create a transaction with amount being leess or equal to 0");
    }
  }

  void apply(Account account);
}

class DepositTransaction extends Transaction {
  DepositTransaction(super.amount);

  @override
  void apply(Account account) {
    account.balance += amount;
  }
}

class WithdrawTransaction extends Transaction {
  WithdrawTransaction(super.amount);

  @override
  void apply(Account account) {
    if(amount > account.balance) {
      throw StateError("Insufficient balance");
    } else {
      account.balance -= amount;
    }
  }
}

class TransferTransaction extends Transaction {
  Account toAccount;
  TransferTransaction(super.amount, this.toAccount);

  @override
  void apply(Account account) {
    if(amount > account.balance) {
      throw StateError("Insufficient balance");
    } else {
      account.balance -= amount;
    }

    toAccount.balance += amount;
  }
}