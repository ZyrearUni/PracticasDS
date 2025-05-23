import 'package:practica4/client.dart';
import 'package:practica4/product.dart';

abstract class Transaction {
  int id;
  Client owner;

  Transaction(this.id, this.owner);
  void apply(List<Product> products);
}

class BuyTransaction extends Transaction {
  Client buyer;
  BuyTransaction(super.id, super.owner, this.buyer);

  @override
  void apply(List<Product> products) {
    if(products[id].owner != buyer) {
      if(buyer.balance < products[id].getPrice()) {
        throw Exception("Not enough balance");
      }

      buyer.balance -= products[id].getPrice();
      owner.balance += products[id].getPrice();
      owner.sellableProducts.add(products[id]);
      products.remove(products[id]);
    }
  }
}

class SellTransaction extends Transaction {
  Product toSell;

  SellTransaction(this.toSell, Client owner) : super(-1, owner);

  @override
  void apply(List<Product> products) {
    owner.sellableProducts.remove(toSell);
    products.add(toSell);
  }
}

class RetireTransaction extends Transaction {
  RetireTransaction(super.id, super.owner);

  @override
  void apply(List<Product> products) {
    if (products[id].owner == owner) {
      owner.sellableProducts.add(products[id]);
      products.remove(products[id]);
    }
  }
}