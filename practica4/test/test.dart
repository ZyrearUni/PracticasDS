import 'package:flutter_test/flutter_test.dart';

import 'package:practica4/client.dart';
import 'package:practica4/product.dart';
import 'package:practica4/transaction.dart';
import 'package:practica4/marketplace_context.dart';

void main() {
  Client owner_test = new Client("owner_test", 0.0);
  group('Client', () {
    test('should throw error for negative balance', () {
      expect(() => Client('BadGuy', -1), throwsA(isA<StateError>()));
    });

    test('should compare clients based on name', () {
      Client client1 = Client('Alice', 10);
      Client client2 = Client('Alice', 20);
      Client client3 = Client('Bob', 10);
      expect(client1 == client2, isTrue);
      expect(client1 == client3, isFalse);
    });

    test('should allow adding sellable products', () {
      Client client = Client('Seller', 50);
      Product product = Item('Widget', client, 20);
      client.sellableProducts.add(product);
      expect(client.sellableProducts.contains(product), isTrue);
    });
  });

  group('Item', () {
    test('should throw exception on invalid operations', () {
      Product item = Item("test", owner_test, 10);

      expect(() => item.add(item), throwsException);
      expect(() => item.remove(item), throwsException);
      expect(() => item.getChild(0), throwsException);
    });
  });

  group('ItemPackage', () {
    test('should accumulate child prices correctly', () {
      Product package = ItemPackage('Pack', owner_test);

      package.add(Item('Item1', owner_test, 10));
      package.add(Item('Item2', owner_test, 15));
      expect(package.getPrice(), equals(25));
    });

    test('should allow adding and removing items', () {
      ItemPackage package = ItemPackage('Box', owner_test);
      Product item = Item("test", owner_test, 10);

      package.add(item);
      expect(package.children.contains(item), isTrue);
      package.remove(item);
      expect(package.children.contains(item), isFalse);
    });
  });

  group('BuyTransaction', () {
    test('successful transaction updates balances and products', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 0);
      Client buyer = Client("buyer", 100);
      Product item = Item("test", owner, 50);
      context.availableProducts.add(item);

      context.buyProduct(0, owner, buyer);
      expect(buyer.balance, equals(50));
      expect(owner.balance, equals(50));
      expect(owner.sellableProducts.contains(item), isTrue);
      expect(context.availableProducts, isEmpty);
    });

    test('throws if buyer has insufficient balance', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 0);
      Client buyer = Client("buyer", 10);
      Product item = Item("test", owner, 50);
      context.availableProducts.add(item);

      expect(() => context.buyProduct(0, owner, buyer), throwsException);
    });

    test('does nothing if buyer is owner', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 100);
      Product item = Item("test", owner, 50);
      context.availableProducts.add(item);

      context.buyProduct(0, owner, owner);
      expect(owner.balance, equals(100));
      expect(context.availableProducts.length, equals(1));
    });
  });

  group('SellTransaction', () {
    test('makes product available and removes from sellables', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 0);
      Product item = Item("test", owner, 50);

      context.sellProduct(item, owner);
      expect(context.availableProducts.contains(item), isTrue);
      expect(owner.sellableProducts.contains(item), isFalse);
    });
  });

  group('RetireTransaction', () {
    test('retire only if owner matches', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 0);
      Product item = Item("test", owner, 50);
      context.availableProducts.add(item);

      context.retireProduct(0, owner);
      expect(context.availableProducts, isEmpty);
      expect(owner.sellableProducts.contains(item), isTrue);
    });

    test('does not retire if owner does not match', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 0);
      Client stranger = Client('Stranger', 100);
      Product item = Item("test", owner, 50);
      context.availableProducts.add(item);

      context.retireProduct(0, stranger);
      expect(context.availableProducts.length, equals(1));
      expect(owner.sellableProducts.contains(item), isFalse);
    });
  });

  group('MarketplaceContext', () {
    test('multiple buy/sell transactions', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 0);
      Client buyer = Client("buyer", 100);
      Product item = Item("test", owner, 50);
      Product item2 = Item('Lamp', owner, 30);
      context.availableProducts.add(item);
      context.availableProducts.add(item2);

      context.buyProduct(0, owner, buyer); // test
      context.buyProduct(0, owner, buyer); // Lamp

      expect(buyer.balance, equals(20)); // 100 - 50 - 30
      expect(owner.balance, equals(80)); // 0 + 50 + 30
      expect(context.availableProducts, isEmpty);
      expect(owner.sellableProducts.length, equals(2));
    });

    test('selling again after retiring', () {
      MarketplaceContext context = MarketplaceContext();
      Client owner = Client("owner", 0);
      Product item = Item("test", owner, 50);
      context.availableProducts.add(item);

      context.retireProduct(0, owner);
      context.sellProduct(item, owner);

      expect(context.availableProducts.contains(item), isTrue);
      expect(owner.sellableProducts.contains(item), isFalse);
    });
  });
}