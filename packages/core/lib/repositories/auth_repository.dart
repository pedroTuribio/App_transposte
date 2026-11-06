import '../api/api_client.dart';
import '../models/auth_session.dart';
import '../models/result.dart';

class AuthRepository {
  const AuthRepository(this._api);
  final ApiClient _api;

  /// POST /auth/login  {"email": "...", "password": "..."}
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    final result = await _api
        .post('/auth/login', body: {'email': email, 'password': password});
    return result.map((data) {
      final map = data as Map<String, dynamic>;
      final token =
          '${map['token'] ?? map['access_token'] ?? map['jwt'] ?? ''}';
      if (token.isEmpty) throw const FormatException('token ausente');
      return AuthSession(token: token, email: email);
    });
  }

  /// POST /auth/register  {"name","email","password"}
  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _api.post('/auth/register',
        body: {'name': name, 'email': email, 'password': password});
    return result.map<void>((_) {});
  }

  /// POST /auth/logout
  Future<Result<void>> logout() async {
    final result = await _api.post('/auth/logout');
    return result.map<void>((_) {});
  }
}
