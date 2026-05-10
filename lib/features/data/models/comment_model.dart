import 'package:clean_commerce/features/domain/entity/comment_entity.dart';

class CreateCommentModel {
  final String authorId;
  final String? postId;
  final String? productId;
  final String content;
  final String? parentId;
  final int likeCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CreateCommentModel({
    required this.authorId,
    this.postId,
    this.productId,
    required this.content,
    this.parentId,
    this.likeCount = 0,
    this.createdAt,
    this.updatedAt,
  });
  Map<String, dynamic> toJson() {
    return {
      'author_id': authorId,
      'post_id': postId,
      'product_id': productId,
      'content': content,
      'parent_id': parentId,
      'like_count': likeCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory CreateCommentModel.fromEntity(CreateCommentEntity entity) {
    return CreateCommentModel(
      authorId: entity.authorId,
      postId: entity.postId,
      productId: entity.productId,
      content: entity.content,
      parentId: entity.parentId,
    );
  }
}

class CommentModel extends CreateCommentModel {
  final String id;
  CommentModel({
    required this.id,
    required super.authorId,
    super.postId,
    super.productId,
    required super.content,
    super.parentId,
    super.likeCount = 0,
    super.createdAt,
    super.updatedAt,
  });

  /// JSON → Model
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      authorId: json['author_id'],
      postId: json['post_id'],
      productId: json['product_id'],
      content: json['content'],
      parentId: json['parent_id'],
      likeCount: json['like_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Model → JSON
  @override
  Map<String, dynamic> toJson() {
    return {'id': id, ...super.toJson()};
  }

  /// Copy helper (useful for likes, edits, replies)
  CommentModel copyWith({
    String? id,
    String? authorId,
    String? postId,
    String? productId,
    String? content,
    String? parentId,
    int? likeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      postId: postId ?? this.postId,
      productId: productId ?? this.productId,
      content: content ?? this.content,
      parentId: parentId ?? this.parentId,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CommentModel('
        'id: $id, '
        'authorId: $authorId, '
        'postId: $postId, '
        'productId: $productId, '
        'content: $content, '
        'parentId: $parentId, '
        'likeCount: $likeCount'
        ')';
  }
}
