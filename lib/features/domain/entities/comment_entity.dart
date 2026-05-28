import 'package:clean_commerce/features/data/models/comment_model.dart';

class CreateCommentEntity {
  final String authorId;
  final String? postId;
  final String? productId;
  final String content;
  final String? parentId;

  const CreateCommentEntity({
    required this.authorId,
    this.postId,
    this.productId,
    required this.content,
    this.parentId,
  });
}

class CommentEntity extends CreateCommentEntity {
  final String id;
  final int likeCount;

  const CommentEntity({
    required this.id,
    required super.authorId,
    super.postId,
    super.productId,
    required super.content,
    super.parentId,
    this.likeCount = 0,
  });
  factory CommentEntity.fromCommentModel(CommentModel model) {
    return CommentEntity(
      id: model.id,
      authorId: model.authorId,
      postId: model.postId,
      productId: model.productId,
      content: model.content,
      parentId: model.parentId,
      likeCount: model.likeCount,
    );
  }
}
