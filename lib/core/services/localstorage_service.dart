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

  static List<String> allBoxes = [userBox, productBox, cartBox, settingsBox];
}

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
      throw Exception('Hive error: ');
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
      throw Exception('Hive error: ');
    }
  }

  // PRODUCT CACHE

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    try {
      await _productBox.put(LocalDbKeys.cachedProducts, products);
    } on HiveError catch (e) {
      throw Exception('Hive error: ');
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
      await _cartBox.put(LocalDbKeys.cachedCart, cart);
    } on HiveError catch (e) {
      throw Exception('Hive error: ');
    }
  }

  List<Map<String, dynamic>>? getCart() {
    try {
      final data = _cartBox.get(LocalDbKeys.cachedCart);
      if (data == null) return null;
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception('LocalStorage Error: ');
    }
  }

  Future<void> clearCart() async {
    await _cartBox.delete(LocalDbKeys.cachedCart);
  }

  // SETTINGS

  Future<void> setFirstTime(bool value) async {
    await _settingsBox.put(LocalDbKeys.isFirstTime, value);
  }

  bool isFirstTime() {
    return _settingsBox.get(LocalDbKeys.isFirstTime, defaultValue: true);
  }

  // GLOBAL CLEAR

  Future<void> clearAll() async {
    try {
      await Future.wait(LocalDbKeys.allBoxes.map((b) => Hive.box(b).clear()));
    } on HiveError catch (e) {
      throw Exception('Hive error: ');
    }
  }
}
