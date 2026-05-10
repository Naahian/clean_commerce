import 'package:clean_commerce/features/data/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionService {
  final SupabaseClient _client;
  TransactionService(this._client);

  Future<List<TransactionModel>> getAll() async {
    try {
      final res = await _client.from('transactions').select();
      return (res as List).map((e) => TransactionModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error fetching transactions");
    }
  }

  Future<TransactionModel> create(CreateTransactionModel data) async {
    try {
      final res = await _client
          .from('transactions')
          .insert(data.toJson())
          .select()
          .single();

      return TransactionModel.fromJson(res);
    } catch (e) {
      throw Exception("Error creating transaction");
    }
  }

  Future<TransactionModel> updateStatus(String id, String status) async {
    try {
      final res = await _client
          .from('transactions')
          .update({
            "status": status,
            "updated_at": DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return TransactionModel.fromJson(res);
    } catch (e) {
      throw Exception("Error updating transaction");
    }
  }
}
