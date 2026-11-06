import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local da sessão (token JWT) e preferências via shared_preferences.
class SharedPrefsSessionStorage implements SessionStorage {
  static const _tokenKey = 'session.token';
  static const _emailKey = 'session.email';
  static const _cpfKey = 'session.cpf';
  static const _themeKey = 'prefs.theme_mode';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<AuthSession?> readSession() async {
    final prefs = await _prefs;
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    return AuthSession(
      token: token,
      email: prefs.getString(_emailKey) ?? '',
      cpf: prefs.getString(_cpfKey) ?? '',
    );
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, session.token);
    await prefs.setString(_emailKey, session.email);
    await prefs.setString(_cpfKey, session.cpf);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_cpfKey);
  }

  @override
  Future<String?> readToken() async => (await _prefs).getString(_tokenKey);

  @override
  Future<String?> readThemeMode() async => (await _prefs).getString(_themeKey);

  @override
  Future<void> saveThemeMode(String mode) async =>
      (await _prefs).setString(_themeKey, mode);
}
