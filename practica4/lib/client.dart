import 'package:practica4/product.dart';

class Client {
  String name;
  List<Product> sellableProducts = [];
  double balance = 0;

  Client(this.name, this.balance) {
    if(balance < 0) {
      throw StateError("Cannot have negative balance");
    }
  }

  @override
  bool operator == (Object other) =>
     other is Client && name == other.name;
}