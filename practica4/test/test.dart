import 'package:flutter_test/flutter_test.dart';

import 'package:practica4/client.dart';
import 'package:practica4/product.dart';
import 'package:practica4/transaction.dart';
import 'package:practica4/marketplace_context.dart';

void main() {
  late Client owner;
  late Client buyer;
  late Item item;
  late MarketplaceContext context;

  setUp(() {
    owner = Client('Owner', 0);
    buyer = Client('Buyer', 100);
    item = Item('Book', owner, 50);
    owner.sellableProducts.add(item);
    context = MarketplaceContext();
    context.availableProducts.add(item);
  });

  group('Client', () {
    test('should throw error for negative balance', () {
      expect(() => Client('BadGuy', -1), throwsA(isA<StateError>()));
    });

    test('should compare clients based on name', () {
      var client1 = Client('Alice', 10);
      var client2 = Client('Alice', 20);
      var client3 = Client('Bob', 10);
      expect(client1 == client2, isTrue);
      expect(client1 == client3, isFalse);
    });

    test('should allow adding sellable products', () {
      var client = Client('Seller', 50);
      var product = Item('Widget', client, 20);
      client.sellableProducts.add(product);
      expect(client.sellableProducts.contains(product), isTrue);
    });
  });

  group('Item', () {
    test('should throw exception on invalid operations', () {
      expect(() => item.add(item), throwsException);
      expect(() => item.remove(item), throwsException);
      expect(() => item.getChild(0), throwsException);
    });
  });

  group('ItemPackage', () {
    test('should accumulate child prices correctly', () {
      var package = ItemPackage('Pack', owner);
      package.add(Item('Item1', owner, 10));
      package.add(Item('Item2', owner, 15));
      expect(package.getPrice(), equals(25));
    });

    test('should allow adding and removing items', () {
      var package = ItemPackage('Box', owner);
      package.add(item);
      expect(package.children.contains(item), isTrue);
      package.remove(item);
      expect(package.children.contains(item), isFalse);
    });
  });

  group('BuyTransaction', () {
    test('successful transaction updates balances and products', () {
      context.buyProduct(0, owner, buyer);
      expect(buyer.balance, equals(50));
      expect(owner.balance, equals(50));
      expect(owner.sellableProducts.contains(item), isTrue);
      expect(context.availableProducts, isEmpty);
    });

    test('throws if buyer has insufficient balance', () {
      buyer.balance = 20;
      expect(() => context.buyProduct(0, owner, buyer), throwsException);
    });

    test('does nothing if buyer already owns the product', () {
      item.owner = buyer;
      context.buyProduct(0, owner, buyer);
      expect(buyer.balance, equals(100));
      expect(context.availableProducts.length, equals(1));
    });
  });

  group('SellTransaction', () {
    test('makes product available and removes from sellables', () {
      context.sellProduct(item, owner);
      expect(context.availableProducts.contains(item), isTrue);
      expect(owner.sellableProducts.contains(item), isFalse);
    });
  });

  group('RetireTransaction', () {
    test('retire only if owner matches', () {
      context.retireProduct(0, owner);
      expect(context.availableProducts, isEmpty);
      expect(owner.sellableProducts.contains(item), isTrue);
    });

    test('does not retire if owner does not match', () {
      var stranger = Client('Stranger', 100);
      context.retireProduct(0, stranger);
      expect(context.availableProducts.length, equals(1));
      expect(owner.sellableProducts.contains(item), isTrue);
    });
  });

  group('MarketplaceContext', () {
    test('multiple buy/sell transactions', () {
      var item2 = Item('Lamp', owner, 30);
      owner.sellableProducts.add(item2);
      context.availableProducts.add(item2);

      context.buyProduct(0, owner, buyer); // Book
      context.buyProduct(0, owner, buyer); // Lamp (shifted index)

      expect(buyer.balance, equals(20)); // 100 - 50 - 30
      expect(owner.balance, equals(80)); // 0 + 50 + 30
      expect(context.availableProducts, isEmpty);
      expect(owner.sellableProducts.length, equals(2));
    });

    test('selling again after retiring', () {
      context.retireProduct(0, owner);
      context.sellProduct(item, owner);

      expect(context.availableProducts.contains(item), isTrue);
      expect(owner.sellableProducts.contains(item), isFalse);
    });

    test('transaction history replaces old transaction', () {
      context.buyProduct(0, owner, buyer);
      expect(context.transaction is BuyTransaction, isTrue);

      context.sellProduct(item, owner);
      expect(context.transaction is SellTransaction, isTrue);
    });
  });
}