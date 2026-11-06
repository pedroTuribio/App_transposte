import '../api/api_client.dart';
import '../models/result.dart';
import '../models/user.dart';

class UserRepository {
  const UserRepository(this._api);
  final ApiClient _api;

  /// GET /me
  Future<Result<User>> getMe() async {
    final result = await _api.get('/me');
    return result.map((data) => User.fromJson(data as Map<String, dynamic>));
  }
}
