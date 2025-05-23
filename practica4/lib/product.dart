import 'package:practica4/client.dart';

abstract class Product {
  String name;
  Client owner                                                                                                                                                                                                                                                                                        ;

  Product(this.name, this.owner);

  double getPrice();
  void add(Product child);
  void remove(Product child);
  Product getChild(int id);
}

class Item extends Product {
  double price = 0;

  Item(super.name, super.owner, this.price) {
    if(price < 0) {
      throw StateError("Cannot put a negative price on an item");
    }
  }

  @override
  double getPrice() {
    return price;
  }

  @override
  void add(Product child) {
    throw Exception("Cannot add products to an item");
  }

  @override
  void remove(Product child) {
    throw Exception("Cannot remove products from an item");
  }

  @override
  Product getChild(int id) {
    throw Exception("Items do not have children");
  }
}

class ItemPackage extends Product {
  List<Product> children = [];
  ItemPackage(super.name, super.owner);

  @override
  double getPrice() {
    double result = 0;
    for (var product in children) {
      result = product.getPrice();
    }

    return result;
  }

  @override
  void add(Product child) {
    children.add(child);
  }

  @override
  void remove(Product child) {
    children.remove(child);
  }

  @override
  Product getChild(int id) {
    return children[id];
  }
}