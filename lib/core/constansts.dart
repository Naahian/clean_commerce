class ApiEndpoints {
  static final baseUrl = "https://dummyjson.com";

  //auth
  static final login = "/auth/login";
  static final userInfo = "/auth/me";
  static final refresh = "/auth/refresh";

  //others
  static final users = "/users";
  static final posts = "/posts";
  static final randomImage = "/icon";
}

// ignore: constant_identifier_names
enum Currency { BDT, USD }

enum TransactionType { payment, coupon }

enum TransactionStatus { pending, completed, rejected }

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  reqCancel,
  canceled,
}
