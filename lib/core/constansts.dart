import 'package:flutter/material.dart';

class ApiEndpoints {
  //bkash
  static final bkashSandbox = "https://checkout.sandbox.bka.sh/v1.2.0-beta";
  static final bkashLive = "https://checkout.pay.bka.sh/v1.2.0-beta";
  static final baseUrl = bkashSandbox;

  static final grantToken =
      "${ApiEndpoints.baseUrl}/tokenized/checkout/token/grant";
  static final refreshToken =
      "${ApiEndpoints.baseUrl}/tokenized/checkout/token/refresh";
  static final createPayment =
      "${ApiEndpoints.baseUrl}/tokenized/checkout/create";
  static final executePayment =
      "${ApiEndpoints.baseUrl}/tokenized/checkout/execute";
  static final queryPayment =
      "${ApiEndpoints.baseUrl}/tokenized/checkout/payment/status";

  static final fallBackimage = "https://placehold.net/product-400x400.png";
}

// ENUMS

enum Constants {
  instance;

  static const String appName = "Clean Commerce";
  static const String appVersion = "1.0.0";
  static const String appDescription =
      "A clean architecture e-commerce app built with Flutter.";
  static const String appAuthor = "Nahian Dev";
  static const double shippingFee = 60.0;
}

// ignore: constant_identifier_names
enum Currency { BDT, USD }

enum TransactionType { payment, coupon }

enum TransactionStatus { pending, completed, rejected }

enum PaymentMethod {
  google_pay,
  cashOnDelivery;

  IconData get icon {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return Icons.attach_money;
      case PaymentMethod.google_pay:
        return Icons.wallet;
    }
  }

  Color get color {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return Colors.orange;
      case PaymentMethod.google_pay:
        return Colors.red;
    }
  }
}

enum PaymentStatus {
  paid,
  unpaid,
  refunded;

  Color get color {
    switch (this) {
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.unpaid:
        return Colors.orange;
      case PaymentStatus.refunded:
        return Colors.purple;
    }
  }

  bool get isSuccess => this == PaymentStatus.paid;
  bool get isFailed => this == PaymentStatus.unpaid;
  bool get isPending => this == PaymentStatus.refunded;
}

// enums/order_status.dart
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  reqCancel,
  cancelled;

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.reqCancel:
        return Colors.orange;
    }
  }

  bool get isCompleted => this == OrderStatus.delivered;
  bool get isActive => !isCompleted && this != OrderStatus.cancelled;
}

enum Categories {
  all,
  electronics,
  fashion,
  food,
  decoration,
  accessories;

  String get name {
    switch (this) {
      case Categories.all:
        return 'All';
      case Categories.electronics:
        return 'Electronics';
      case Categories.fashion:
        return 'Fashion';
      case Categories.food:
        return 'Food';
      case Categories.decoration:
        return 'Decoration';
      case Categories.accessories:
        return 'Accessories';
    }
  }

  IconData get icon {
    switch (this) {
      case Categories.all:
        return Icons.category;
      case Categories.electronics:
        return Icons.electrical_services;
      case Categories.fashion:
        return Icons.checkroom;
      case Categories.food:
        return Icons.local_dining;
      case Categories.decoration:
        return Icons.wallet_giftcard_outlined;
      case Categories.accessories:
        return Icons.headphones;
    }
  }

  Color get color {
    switch (this) {
      case Categories.all:
        return Colors.grey;
      case Categories.electronics:
        return Colors.blue;
      case Categories.fashion:
        return Colors.pink;
      case Categories.food:
        return Colors.orange;
      case Categories.decoration:
        return Colors.green;
      case Categories.accessories:
        return Colors.purple;
    }
  }

  static List<Categories> get valuesList => values;
}
