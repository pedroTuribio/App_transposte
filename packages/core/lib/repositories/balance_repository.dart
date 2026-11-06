import '../api/api_client.dart';
import '../models/result.dart';
import '../models/summary.dart';
import '../models/transaction.dart';

class BalanceRepository {
  const BalanceRepository(this._api);
  final ApiClient _api;

  /// GET /summary
  Future<Result<Summary>> getSummary() async {
    final result = await _api.get('/summary');
    return result.map((data) => Summary.fromJson(data as Map<String, dynamic>));
  }

  /// GET /transactions
  Future<Result<List<Transaction>>> getTransactions() async {
    final result = await _api.get('/transactions');
    return result.map((data) {
      final Object? list = data is Map<String, dynamic>
          ? (data['transactions'] ?? data['data'] ?? data['items'])
          : data;
      if (list is! List) return <Transaction>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Transaction.fromJson)
          .toList();
    });
  }
}
