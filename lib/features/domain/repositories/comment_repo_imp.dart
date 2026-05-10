import 'package:clean_commerce/features/data/models/comment_model.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/comment_service.dart';
import 'package:clean_commerce/features/domain/entity/comment_entity.dart';
import 'package:clean_commerce/features/domain/entity/result_entity.dart';

class CommentRepositoryImp implements CommentRepository {
  final CommentService remote;

  CommentRepositoryImp({required this.remote});

  @override
  Future<Result<CommentEntity>> create(CreateCommentEntity comment) async {
    try {
      final result = await remote.create(
        CreateCommentModel.fromEntity(comment),
      );

      final entity = CommentEntity.fromCommentModel(result);

      return Result<CommentEntity>(
        success: true,
        message: "Comment created successfully.",
        data: entity,
      );
    } catch (e) {
      return Result<CommentEntity>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<void>> delete(String commentId) async {
    try {
      await remote.delete(commentId);

      return Result<void>(
        success: true,
        message: "Comment deleted successfully.",
      );
    } catch (e) {
      return Result<void>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<List<CommentEntity>>> getOfProduct(String productId) async {
    try {
      final result = await remote.getByProduct(productId);

      final comments = result
          .map((e) => CommentEntity.fromCommentModel(e))
          .toList();

      return Result<List<CommentEntity>>(
        success: true,
        message: "Comments fetched successfully.",
        data: comments,
      );
    } catch (e) {
      return Result<List<CommentEntity>>(success: false, message: e.toString());
    }
  }
}
