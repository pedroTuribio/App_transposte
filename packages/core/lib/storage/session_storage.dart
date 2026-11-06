import '../models/auth_session.dart';

/// Contrato de persistência local (implementado no app com shared_preferences).
abstract class SessionStorage {
  Future<AuthSession?> readSession();
  Future<void> saveSession(AuthSession session);
  Future<void> clearSession();
  Future<String?> readToken();
  Future<String?> readThemeMode();
  Future<void> saveThemeMode(String mode);
}
