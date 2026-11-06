import 'package:core/core.dart';
import 'package:flutter/material.dart';

abstract class ServerProfile {
  Future<Result<User>> loadUser();

  /// POST /auth/logout + limpeza da sessão local.
  Future<Result<void>> logout();

  bool get isDarkTheme;
  Future<void> setDarkTheme(bool value);
}

class ServerProfileImpl implements ServerProfile {
  const ServerProfileImpl({
    required UserRepository userRepository,
    required AuthRepository authRepository,
    required SessionStorage sessionStorage,
    required ValueNotifier<ThemeMode> themeController,
  })  : _users = userRepository,
        _auth = authRepository,
        _storage = sessionStorage,
        _theme = themeController;

  final UserRepository _users;
  final AuthRepository _auth;
  final SessionStorage _storage;
  final ValueNotifier<ThemeMode> _theme;

  @override
  Future<Result<User>> loadUser() async {
    final result = await _users.getMe();
    if (result is Success<User> && result.data.cpf.isEmpty) {
      // O servidor pode não devolver CPF; usa o salvo no login.
      final session = await _storage.readSession();
      return Success<User>(result.data.copyWith(cpf: session?.cpf ?? ''));
    }
    return result;
  }

  @override
  Future<Result<void>> logout() async {
    final result = await _auth.logout();
    // A sessão local é sempre limpa, mesmo se o servidor estiver offline.
    await _storage.clearSession();
    return result;
  }

  @override
  bool get isDarkTheme => _theme.value == ThemeMode.dark;

  @override
  Future<void> setDarkTheme(bool value) async {
    _theme.value = value ? ThemeMode.dark : ThemeMode.light;
    await _storage.saveThemeMode(value ? 'dark' : 'light');
  }
}
