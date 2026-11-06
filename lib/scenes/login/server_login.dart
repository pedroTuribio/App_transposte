import 'package:core/core.dart';

/// Mapeia o CPF do aluno para o e-mail aceito pelo `carteira_server`.
/// - CPF de demonstração 123.456.789-09 => ana@carteira.dev
/// - CPF de demonstração 111.444.777-35 => bruno@carteira.dev
/// - Demais CPFs => <cpf apenas dígitos>@transporte.dev
String emailFromCpf(String cpf) {
  const demoUsers = {
    '12345678909': 'ana@carteira.dev',
    '11144477735': 'bruno@carteira.dev',
  };
  final digits = CpfUtils.digitsOnly(cpf);
  return demoUsers[digits] ?? '$digits@transporte.dev';
}

abstract class ServerLogin {
  Future<Result<void>> login({required String cpf, required String password});

  Future<Result<void>> register({
    required String name,
    required String cpf,
    required String password,
  });
}

class ServerLoginImpl implements ServerLogin {
  const ServerLoginImpl({
    required AuthRepository authRepository,
    required SessionStorage sessionStorage,
  })  : _auth = authRepository,
        _storage = sessionStorage;

  final AuthRepository _auth;
  final SessionStorage _storage;

  @override
  Future<Result<void>> login({
    required String cpf,
    required String password,
  }) async {
    final digits = CpfUtils.digitsOnly(cpf);
    final result =
        await _auth.login(email: emailFromCpf(digits), password: password);
    if (result is Success<AuthSession>) {
      // Persiste token JWT + sessão no shared_preferences.
      await _storage.saveSession(result.data.copyWith(cpf: digits));
      return const Success<void>(null);
    }
    final error = result.errorOrNull!;
    return Failure<void>(
      error.isUnauthorized
          ? const AppException('CPF ou senha inválidos.', statusCode: 401)
          : error,
    );
  }

  @override
  Future<Result<void>> register({
    required String name,
    required String cpf,
    required String password,
  }) async {
    final registered = await _auth.register(
      name: name,
      email: emailFromCpf(cpf),
      password: password,
    );
    if (registered is Failure<void>) return registered;
    return login(cpf: cpf, password: password);
  }
}
