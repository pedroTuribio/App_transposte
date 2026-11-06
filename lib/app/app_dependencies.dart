import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'shared_prefs_session_storage.dart';

/// Raiz de composição: cria e expõe as dependências compartilhadas do app.
class AppDependencies {
  AppDependencies._({
    required this.sessionStorage,
    required this.apiClient,
    required this.authRepository,
    required this.balanceRepository,
    required this.userRepository,
    required this.themeController,
  });

  /// Padrão: carteira_server local (web/desktop/iOS Simulator).
  /// Emulador Android: `--dart-define=API_BASE_URL=http://10.0.2.2:8080`.
  static const String defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  final SessionStorage sessionStorage;
  final ApiClient apiClient;
  final AuthRepository authRepository;
  final BalanceRepository balanceRepository;
  final UserRepository userRepository;
  final ValueNotifier<ThemeMode> themeController;

  static Future<AppDependencies> create({String? baseUrl}) async {
    final storage = SharedPrefsSessionStorage();
    final api = ApiClient(
      baseUrl: baseUrl ?? defaultBaseUrl,
      storage: storage,
    );
    final savedTheme = await storage.readThemeMode();
    return AppDependencies._(
      sessionStorage: storage,
      apiClient: api,
      authRepository: AuthRepository(api),
      balanceRepository: BalanceRepository(api),
      userRepository: UserRepository(api),
      themeController: ValueNotifier<ThemeMode>(
        savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
