import 'package:flutter/foundation.dart';

import 'server_splash.dart';
import 'splash_coordinator.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({
    required ServerSplash server,
    required SplashCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator;

  final ServerSplash _server;
  final SplashCoordinator _coordinator;

  bool _isChecking = true;
  bool get isChecking => _isChecking;

  /// Decide o destino: token salvo => /home, senão => /login.
  Future<void> start() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final hasSession = await _server.hasSavedSession();
    _isChecking = false;
    notifyListeners();
    if (hasSession) {
      _coordinator.goToHome();
    } else {
      _coordinator.goToLogin();
    }
  }
}
