import 'package:clean_commerce/core/services/localstorage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late LocalStorageService storage;

  setUpAll(() async {
    Hive.init('./test_hive');

    storage = LocalStorageService();

    await storage.init(isTest: true);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  group("LocalStorageService Tests", () {
    // =========================
    // USER TESTS
    // =========================

    test("save & get user", () async {
      final user = {"id": "123", "name": "Test User", "email": "test@mail.com"};

      await storage.saveUser(user);

      final result = storage.getUser();

      expect(result, isNotNull);
      expect(result!["id"], "123");
      expect(result["name"], "Test User");
    });

    test("clear user", () async {
      await storage.clearUser();

      final result = storage.getUser();

      expect(result, isNull);
    });

    // =========================
    // PRODUCT TESTS
    // =========================

    test("save & get products", () async {
      final products = [
        {"id": "p1", "name": "Product 1", "price": 100},
        {"id": "p2", "name": "Product 2", "price": 200},
      ];

      await storage.saveProducts(products);

      final result = storage.getProducts();

      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result.first["id"], "p1");
    });

    // =========================
    // CART TESTS
    // =========================

    test("save & get cart", () async {
      final cart = [
        {"productId": "p1", "qty": 2},
      ];

      await storage.saveCart(cart);

      final result = storage.getCart();

      expect(result, isNotNull);
      expect(result!.first["qty"], 2);
    });

    test("clear cart", () async {
      await storage.clearCart();

      final result = storage.getCart();

      expect(result, isNull);
    });

    // =========================
    // SETTINGS TESTS
    // =========================

    test("first time flag", () async {
      await storage.setFirstTime(false);

      final result = storage.isFirstTime();

      expect(result, false);
    });

    // =========================
    // GLOBAL CLEAR TEST
    // =========================

    test("clear all data", () async {
      await storage.clearAll();

      expect(storage.getUser(), isNull);
      expect(storage.getProducts(), isNull);
      expect(storage.getCart(), isNull);
    });
  });

  tearDownAll(() => Hive.deleteFromDisk());
}
