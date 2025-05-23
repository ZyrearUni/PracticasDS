import 'package:practica4/client.dart';
import 'package:practica4/product.dart';
import 'package:practica4/transaction.dart';

class MarketplaceContext {
  late Transaction transaction;
  List<Product> availableProducts = [];

  void buyProduct(int id, Client owner, Client buyer) {
    transaction = BuyTransaction(id, owner, buyer);
    transaction.apply(availableProducts);
  }

  void sellProduct(Product toSell, Client owner) {
    transaction = SellTransaction(toSell, owner);
    transaction.apply(availableProducts);
  }

  void retireProduct(int id, Client owner) {
    transaction = RetireTransaction(id, owner);
    transaction.apply(availableProducts);
  }
}