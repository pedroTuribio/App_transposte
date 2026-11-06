import 'package:core/core.dart';

abstract class ServerSplash {
  /// true se já existe token salvo de um login anterior.
  Future<bool> hasSavedSession();
}

class ServerSplashImpl implements ServerSplash {
  const ServerSplashImpl(this._storage);
  final SessionStorage _storage;

  @override
  Future<bool> hasSavedSession() async {
    final token = await _storage.readToken();
    return token != null && token.isNotEmpty;
  }
}
