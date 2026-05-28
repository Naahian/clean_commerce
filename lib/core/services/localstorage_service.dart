import 'dart:convert';

import 'package:clean_commerce/core/injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDbKeys {
  static const int version = 1;

  // Boxes (NOT keys inside box)
  static const String userBox = "userBox";
  static const String productBox = "productBox";
  static const String cartBox = "cartBox";
  static const String settingsBox = "settingsBox";

  // Keys inside boxes
  static const String cachedCart = "cachedCart";
  static const String cachedProducts = "cachedProducts";
  static const String cachedProfile = "cachedProfile";

  static const String settings = "settings";
  static const String isFirstTime = "isFirstTime";
  static const String isDark = "isDark";
  static const String currency = "currency";

  static List<String> allBoxes = [userBox, productBox, cartBox, settingsBox];
}

// PROVIDER

final localStorageProvider = Provider<LocalStorageService>(
  (_) => getIt<LocalStorageService>(),
);

// SERVICE

class LocalStorageService {
  Box get _userBox => Hive.box(LocalDbKeys.userBox);
  Box get _productBox => Hive.box(LocalDbKeys.productBox);
  Box get _cartBox => Hive.box(LocalDbKeys.cartBox);
  Box get _settingsBox => Hive.box(LocalDbKeys.settingsBox);

  Future<void> init({bool isTest = false}) async {
    if (isTest) {
      Hive.init('./test/hive_test');
    } else {
      await Hive.initFlutter();
    }

    for (final box in LocalDbKeys.allBoxes) {
      await Hive.openBox(box);
    }
  }

  // USER CACHE

  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      await _userBox.put(LocalDbKeys.cachedProfile, user);
    } on HiveError catch (e) {
      throw Exception('Hive error: $e');
    }
  }

  Map<String, dynamic>? getUser() {
    try {
      final data = _userBox.get(LocalDbKeys.cachedProfile);
      if (data == null) return null;
      return Map<String, dynamic>.from(data);
    } catch (e) {
      throw Exception('LocalStorage Error: ');
    }
  }

  Future<void> clearUser() async {
    try {
      await _userBox.delete(LocalDbKeys.cachedProfile);
    } on HiveError catch (e) {
      throw Exception('Hive error: $e');
    }
  }

  // PRODUCT CACHE

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    try {
      await _productBox.put(LocalDbKeys.cachedProducts, products);
    } on HiveError catch (e) {
      throw Exception('Hive error: $e');
    }
  }

  List<Map<String, dynamic>>? getProducts() {
    try {
      final data = _productBox.get(LocalDbKeys.cachedProducts);
      if (data == null) return null;
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception('LocalStorage Error: ');
    }
  }

  // CART CACHE

  Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    try {
      await _cartBox.put(LocalDbKeys.cachedCart, json.encode(cart));
    } on HiveError catch (e) {
      throw Exception('Hive error: $e');
    }
  }

  List<Map<String, dynamic>>? getCart() {
    try {
      final jsonString = _cartBox.get(LocalDbKeys.cachedCart);
      if (jsonString == null) return null;

      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e, stack) {
      return null;
    }
  }

  Future<void> clearCart() async {
    await _cartBox.delete(LocalDbKeys.cachedCart);
  }

  // SETTINGS
  bool isFirstTime() {
    return _settingsBox.get(LocalDbKeys.isFirstTime, defaultValue: true);
  }

  Future<void> setFirstTime(bool value) async {
    await _settingsBox.put(LocalDbKeys.isFirstTime, value);
  }

  bool isDark() {
    return _settingsBox.get(LocalDbKeys.isDark, defaultValue: true);
  }

  Future<void> setDark(bool value) async {
    await _settingsBox.put(LocalDbKeys.isDark, value);
  }

  String getCurrency() {
    return _settingsBox.get(LocalDbKeys.currency, defaultValue: "BDT");
  }

  Future<void> setCurrency(String value) async {
    await _settingsBox.put(LocalDbKeys.currency, value);
  }

  // GLOBAL CLEAR

  Future<void> clearAll() async {
    try {
      await Future.wait(LocalDbKeys.allBoxes.map((b) => Hive.box(b).clear()));
    } on HiveError catch (e) {
      throw Exception('Hive error: $e');
    }
  }
}
