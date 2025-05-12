import 'package:practica3/account.dart';
import 'package:practica3/transaction.dart';

class BankService {
  late Map<String, Account> accountList;

  void createAccount (String number) {
    Account toCreate = Account(number);

    //Para añadir una cuenta a la lista hay que generar un número aleatorio
  }

  void deposit(String accountNumber, double amount) {
    Transaction depositTransaction = DepositTransaction(amount);
    depositTransaction.apply(accountList[accountNumber]!);
  }

  void withdraw(String accountNumber, double amount) {
    Transaction withdrawTransaction = WithdrawTransaction(amount);
    withdrawTransaction.apply(accountList[accountNumber]!);
  }

  void transaction(String accountFrom, String toAccount, double amount) {
    Transaction depositTransaction = TransferTransaction(amount, accountList[toAccount]!);
    depositTransaction.apply(accountList[accountFrom]!);
  }

  double getBalance(String accountNumber) {
    return accountList[accountNumber]!.balance;
  }
}