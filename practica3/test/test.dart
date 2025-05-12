import 'package:flutter_test/flutter_test.dart';
import 'package:practica3/bankservice.dart';


void main() {
  group('Account tests', () {
    test('Balance inicial es cero', () {

    });

    test('No se permite depositar cantidades negativas o 0', () {

    });

    test('No se permite retirar cantidades negativas o cero', () {

    });
  });

  group('Transaction tests', () {
    test('DepositTransaction aumenta el saldo correctamente', () {

    });

    test('WithdrawalTransaction lanza StateError cuando hay fondos insuficientes', () {

    });

    test('TransferTransaction mueve fondos correctamente', () {

    });
  });

  group('BankService tests', () {
    test('La lista inicial de cuentas está vacía', () {

    });

    test('Deposit aumenta el saldo de la cuenta', () {

    });

    test('withdraw lanza StateError cuando el saldo es insuficiente', () {

    });

    test('Transfer mueve fondos correctamente', () {

    });

    test('Transfer lanza StateError cuando los fondos son insuficientes', () {

    });

    test('El id de la transacción es único', () {

    });
  });
}