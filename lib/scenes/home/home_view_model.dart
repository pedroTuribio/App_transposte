import 'package:core/core.dart';
import 'package:flutter/foundation.dart' hide Summary;

import 'home_coordinator.dart';
import 'server_home.dart';

enum HomeStatus { loading, ready, error }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ServerHome server,
    required HomeCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator;

  final ServerHome _server;
  final HomeCoordinator _coordinator;

  HomeStatus _status = HomeStatus.loading;
  String? _errorMessage;
  String? _transactionsError;
  Summary? _summary;
  List<Transaction> _all = const [];
  DateTime? _selectedMonth;

  /// Últimos 6 meses (mais recente primeiro) para os chips de filtro.
  late final List<DateTime> months = _buildMonths();

  HomeStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get transactionsError => _transactionsError;
  Summary? get summary => _summary;
  DateTime? get selectedMonth => _selectedMonth;

  String get balanceText =>
      BrFormat.currency(_summary?.balance.amount ?? 0);
  String get greetingName {
    final name = _summary?.holderName.trim() ?? '';
    return name.isEmpty ? 'Estudante' : name.split(' ').first;
  }

  List<Transaction> get transactions {
    final list = _all.where((t) {
      final m = _selectedMonth;
      return m == null || (t.date.year == m.year && t.date.month == m.month);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  static List<DateTime> _buildMonths() {
    final now = DateTime.now();
    return List.generate(6, (i) => DateTime(now.year, now.month - i));
  }

  String monthLabel(DateTime month) => BrFormat.monthLabel(month);

  String formatAmount(Transaction t) =>
      '${t.isRecharge ? '+' : '-'} ${BrFormat.currency(t.amount)}';

  String formatDate(Transaction t) => BrFormat.dateTime(t.date);

  Future<void> load() => _load(showLoading: true);

  Future<void> refresh() => _load(showLoading: false);

  Future<void> _load({required bool showLoading}) async {
    if (showLoading) {
      _status = HomeStatus.loading;
      notifyListeners();
    }
    final summaryFuture = _server.loadSummary();
    final transactionsFuture = _server.loadTransactions();
    final summaryResult = await summaryFuture;
    final transactionsResult = await transactionsFuture;

    final expired = summaryResult.errorOrNull?.isUnauthorized == true ||
        transactionsResult.errorOrNull?.isUnauthorized == true;
    if (expired) {
      await _server.clearSession();
      _coordinator.goToLogin();
      return;
    }

    if (summaryResult.isFailure) {
      _status = HomeStatus.error;
      _errorMessage = summaryResult.errorOrNull?.message ?? 'Erro ao carregar saldo';
      notifyListeners();
      return;
    }

    _summary = summaryResult.dataOrNull;
    _all = transactionsResult.dataOrNull ?? const [];
    _transactionsError = transactionsResult.errorOrNull?.message;
    _errorMessage = null;
    _status = HomeStatus.ready;
    notifyListeners();
  }

  void selectMonth(DateTime? month) {
    _selectedMonth = month;
    notifyListeners();
  }

  /// Retorna a mensagem exibida ao tocar no atalho "Recarga".
  String onRechargeTap() =>
      'Recargas são feitas nos pontos autorizados ou no terminal de integração.';

  void onTabSelected(int index) {
    if (index == 0) return;
    _coordinator.goToTab(index);
  }

  void onProfileTap() => _coordinator.goToProfile();
}
