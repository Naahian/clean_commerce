import 'package:clean_commerce/features/data/models/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentService {
  final SupabaseClient _client;
  CommentService(this._client);

  Future<List<CommentModel>> getByProduct(String productId) async {
    try {
      final res = await _client
          .from('comments')
          .select()
          .eq('product_id', productId)
          .order('created_at');

      return (res as List).map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error fetching comments ");
    }
  }

  Future<CommentModel> create(CreateCommentModel data) async {
    try {
      final res = await _client
          .from('comments')
          .insert(data.toJson())
          .select()
          .single();

      return CommentModel.fromJson(res);
    } catch (e) {
      throw Exception("Error creating comment ");
    }
  }

  Future<void> delete(String id) async {
    try {
      await _client.from('comments').delete().eq('id', id);
    } catch (e) {
      throw Exception("Error deleting comment ");
    }
  }
}
