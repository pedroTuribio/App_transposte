import 'package:core/core.dart';

abstract class ServerHome {
  Future<Result<Summary>> loadSummary();
  Future<Result<List<Transaction>>> loadTransactions();
  Future<void> clearSession();
}

class ServerHomeImpl implements ServerHome {
  const ServerHomeImpl({
    required BalanceRepository balanceRepository,
    required SessionStorage sessionStorage,
  })  : _balance = balanceRepository,
        _storage = sessionStorage;

  final BalanceRepository _balance;
  final SessionStorage _storage;

  @override
  Future<Result<Summary>> loadSummary() => _balance.getSummary();

  @override
  Future<Result<List<Transaction>>> loadTransactions() =>
      _balance.getTransactions();

  @override
  Future<void> clearSession() => _storage.clearSession();
}
