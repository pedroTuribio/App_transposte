import 'package:flutter/foundation.dart';

import 'design_system_showcase_coordinator.dart';
import 'server_design_system_showcase.dart';

class DesignSystemShowcaseViewModel extends ChangeNotifier {
  DesignSystemShowcaseViewModel({
    required ServerDesignSystemShowcase server,
    required DesignSystemShowcaseCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator;

  final ServerDesignSystemShowcase _server;
  final DesignSystemShowcaseCoordinator _coordinator;

  ShowcaseData? _data;
  bool _demoLoading = false;
  String _demoText = '';

  ShowcaseData? get data => _data;
  bool get isReady => _data != null;
  bool get demoLoading => _demoLoading;
  String get demoText => _demoText;

  /// Erro de demonstração para o input (exibido quando o texto é muito curto).
  String? get demoError =>
      _demoText.isNotEmpty && _demoText.length < 3 ? 'Mínimo de 3 caracteres.' : null;

  Future<void> load() async {
    _data = await _server.loadShowcase();
    notifyListeners();
  }

  void onDemoTextChanged(String value) {
    _demoText = value;
    notifyListeners();
  }

  /// Simula o estado de loading do botão.
  Future<void> simulateLoading() async {
    _demoLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(seconds: 2));
    _demoLoading = false;
    notifyListeners();
  }

  void onTabSelected(int index) {
    if (index == 2) return;
    _coordinator.goToTab(index);
  }
}
