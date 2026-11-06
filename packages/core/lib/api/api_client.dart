import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/result.dart';
import '../storage/session_storage.dart';

/// "Interceptor": injeta `Authorization: Bearer <token>` em toda requisição.
class BearerTokenClient extends http.BaseClient {
  BearerTokenClient({
    required http.Client inner,
    required Future<String?> Function() tokenProvider,
  })  : _inner = inner,
        _tokenProvider = tokenProvider;

  final http.Client _inner;
  final Future<String?> Function() _tokenProvider;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _tokenProvider();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers.putIfAbsent('Accept', () => 'application/json');
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required SessionStorage storage,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 15),
  }) : _client = BearerTokenClient(
          inner: httpClient ?? http.Client(),
          tokenProvider: storage.readToken,
        );

  final String baseUrl;
  final Duration timeout;
  final BearerTokenClient _client;

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$base$path').replace(queryParameters: query);
  }

  Future<Result<dynamic>> get(String path, {Map<String, String>? query}) =>
      _execute(() => _client.get(_uri(path, query)));

  Future<Result<dynamic>> post(String path, {Map<String, dynamic>? body}) =>
      _execute(() => _client.post(
            _uri(path),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body ?? <String, dynamic>{}),
          ));

  Future<Result<dynamic>> _execute(
      Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(timeout);
      final decoded = _decode(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success<dynamic>(decoded);
      }
      return Failure<dynamic>(AppException(
        _messageFor(response.statusCode, decoded),
        statusCode: response.statusCode,
      ));
    } on TimeoutException {
      return const Failure<dynamic>(
          AppException('Tempo esgotado. Verifique sua conexão.'));
    } on http.ClientException {
      return Failure<dynamic>(
          AppException('Não foi possível conectar ao servidor ($baseUrl).'));
    } catch (_) {
      return const Failure<dynamic>(
          AppException('Ocorreu um erro inesperado.'));
    }
  }

  dynamic _decode(http.Response response) {
    if (response.bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      return null;
    }
  }

  String _messageFor(int status, dynamic body) {
    if (body is Map<String, dynamic>) {
      final msg = body['message'] ?? body['error'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return switch (status) {
      401 => 'Credenciais inválidas ou sessão expirada.',
      404 => 'Recurso não encontrado.',
      409 => 'Cadastro já existente.',
      >= 500 => 'Servidor indisponível. Tente novamente.',
      _ => 'Falha na requisição ($status).',
    };
  }

  void close() => _client.close();
}
