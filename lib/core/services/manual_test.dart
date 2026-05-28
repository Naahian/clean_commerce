import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/features/data/models/auth_models.dart';
import 'package:clean_commerce/features/data/models/comment_model.dart';
import 'package:clean_commerce/features/data/models/order_model.dart';
import 'package:clean_commerce/features/data/models/transaction_model.dart';
import 'package:clean_commerce/features/data/services/auth_service.dart';
import 'package:clean_commerce/features/data/services/comment_service.dart';
import 'package:clean_commerce/features/data/services/order_service.dart';
import 'package:clean_commerce/features/data/services/product_service.dart';
import 'package:clean_commerce/features/data/services/transaction_service.dart';
import 'package:clean_commerce/features/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManualTest {
  final authService = getIt<AuthService>();
  final productService = getIt<ProductService>();
  final commentService = getIt<CommentService>();
  final orderService = getIt<OrderService>();
  final transactionService = getIt<TransactionService>();
  final _client = Supabase.instance.client;

  void start() async {
    debugPrint("#--------- REMOTE TEST ----------#");
    await remoteTest();
  }

  ///   REMOTE TEST   ///

  Future<void> remoteTest() async {
    debugPrint("### Auth Test ###");
    // await signup();
    // await login();
    if (_client.auth.currentUser == null) {
      debugPrint("# Not Authenticated #");
      return;
    }
    // await deleteAccountTest();

    debugPrint("### Product Test ###");
    // await getProducts();
    // await getSingleProduct("930bd560-a0db-4526-b00d-d4d4e1b33747");

    debugPrint("### Order Test ###");
    // await createOrder(_client.auth.currentUser!.id, 999);
    // await getOrder();
    await cancelOrderReq("cdf1b3d3-558f-4003-885c-5ef828618115");

    debugPrint("### Transaction Test ###");
    // await createTransaction(_client.auth.currentUser!.id, 888);
    // await getTransaction();

    debugPrint("### Comment Test ###");
    // await createComment(
    //   _client.auth.currentUser!.id,
    //   "930bd560-a0db-4526-b00d-d4d4e1b33747",
    // );
    // await getCommentsByProduct("930bd560-a0db-4526-b00d-d4d4e1b33747");
    // await deleteComment("b7bdda0c-05a8-4193-aec4-909811c8aff5");
  }

  Future<void> signup() async {
    debugPrint("# Create User");
    final createdUser = await authService.createUser(
      CreateUserModel(
        email: "testuser@gmail.com",
        password: "tree1234",
        displayName: "Test User",
      ),
    );
    debugPrint(createdUser.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> login() async {
    debugPrint("# Login User");
    final loginUser = await authService.login(
      LoginModel(email: "harry@mail.com", password: "tree123"),
    );
    debugPrint(loginUser.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> deleteAccount() async {
    debugPrint("# delete User");
    await authService.deleteMyAccount();
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> getProducts() async {
    debugPrint("# Get Products");
    final products = await productService.getAll(limit: 5, skip: 1);
    debugPrint(products.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> getSingleProduct(String prodId) async {
    debugPrint("# Get Single Product");
    final product = await productService.getById(prodId);
    debugPrint(product.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> createOrder(String userId, double amount) async {
    debugPrint("# Create An Order");

    final result = await orderService.create(
      CreateOrderModel(
        userId: userId,
        totalAmount: amount,
        shippingAddress: '123/myhome/street/dhaka',
        items: [
          {
            "idx": 1,
            "id": "f5b942d3-a0ec-4643-958a-36295ef87dbe",
            "owner_id": userId,
            "name": "Running Shoe",
            "description": "Comfortable athletic shoes",
            "price": "39.99",
            "quantity": 180,
            "category": "fashion",
            "images": ["product_shoe.jpg", "product_glass.jpg"],
            "metadata":
                "{\"tags\": [\"trending\", \"shoe\", \"sports\"], \"type\": \"footwear\"}",
            "is_active": true,
            "created_at": "2026-05-09 09:11:25.250459",
            "updated_at": "2026-05-09 09:11:25.250459",
            "discount": 0,
          },
        ],
      ),
    );
    final entity = OrderEntity.fromOrderModel(result);
    print(entity.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> getOrder() async {
    debugPrint("# Get User's All Orders");
    final result = await orderService.getAll();
    debugPrint(result.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> cancelOrderReq(String orderId) async {
    debugPrint("# Order Cancel Request");
    final result = await orderService.updateStatus(
      id: orderId,
      status: OrderStatus.reqCancel,
    );
    debugPrint(result.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> createTransaction(String userId, double amount) async {
    debugPrint("# Create Transaction");
    final result = await transactionService.create(
      CreateTransactionModel(amount: amount, userId: userId, currency: 'BDT'),
    );
    debugPrint(result.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> getTransaction() async {
    debugPrint("# Get All User's Transaction");
    final result = await transactionService.getAll();
    debugPrint(result.toString());
    Future.delayed(Duration(microseconds: 500));
  }

  Future<void> getCommentsByProduct(String productId) async {
    debugPrint("# Get Comments By Post");

    final result = await commentService.getByProduct(productId);

    debugPrint(result.toString());

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<CommentModel?> createComment(String userId, String productId) async {
    debugPrint("# Create Comment");

    final result = await commentService.create(
      CreateCommentModel(
        authorId: userId,
        productId: productId,
        content: "This is a test comment",
      ),
    );

    debugPrint(result.toString());

    await Future.delayed(const Duration(milliseconds: 500));

    return result;
  }

  Future<void> deleteComment(String id) async {
    debugPrint("# Delete Comment");
    await commentService.delete(id);
    debugPrint("Comment Deleted: $id");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  ///   OTHER TEST   ///
}
