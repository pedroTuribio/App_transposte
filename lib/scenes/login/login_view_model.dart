import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

import 'login_coordinator.dart';
import 'server_login.dart';

enum LoginMode { signIn, register }

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required ServerLogin server,
    required LoginCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator;

  final ServerLogin _server;
  final LoginCoordinator _coordinator;

  LoginMode _mode = LoginMode.signIn;
  String _cpf = '';
  String _password = '';
  String _name = '';
  bool _isLoading = false;
  bool _submitted = false;
  String? _formError;

  LoginMode get mode => _mode;
  bool get isRegister => _mode == LoginMode.register;
  bool get isLoading => _isLoading;
  String? get formError => _formError;

  String get title => isRegister ? 'Primeiro acesso' : 'Bem-vindo de volta';
  String get subtitle => isRegister
      ? 'Cadastre-se com o CPF do aluno para consultar seu cartão.'
      : 'Entre com o CPF do aluno para ver o saldo do seu cartão.';
  String get submitLabel => isRegister ? 'Cadastrar e entrar' : 'Entrar';
  String get toggleLabel => isRegister
      ? 'Já tenho conta — Entrar'
      : 'Primeiro acesso / Cadastrar';

  String? get nameError {
    if (!_submitted || !isRegister) return null;
    return _name.trim().length < 3 ? 'Informe o nome completo.' : null;
  }

  String? get cpfError {
    if (!_submitted) return null;
    if (_cpf.isEmpty) return 'Informe o CPF.';
    return CpfUtils.isValid(_cpf) ? null : 'CPF inválido.';
  }

  String? get passwordError {
    if (!_submitted) return null;
    if (_password.isEmpty) return 'Informe a senha.';
    return _password.length < 6 ? 'A senha deve ter ao menos 6 caracteres.' : null;
  }

  void onNameChanged(String value) {
    _name = value;
    if (_submitted) notifyListeners();
  }

  void onCpfChanged(String value) {
    _cpf = value;
    if (_submitted) notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    if (_submitted) notifyListeners();
  }

  void toggleMode() {
    _mode = isRegister ? LoginMode.signIn : LoginMode.register;
    _submitted = false;
    _formError = null;
    notifyListeners();
  }

  bool get _isValid =>
      nameError == null && cpfError == null && passwordError == null;

  Future<void> submit() async {
    if (_isLoading) return;
    _submitted = true;
    _formError = null;
    if (!_isValid) {
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    final Result<void> result = isRegister
        ? await _server.register(
            name: _name.trim(), cpf: _cpf, password: _password)
        : await _server.login(cpf: _cpf, password: _password);

    _isLoading = false;
    if (result is Failure<void>) {
      _formError = result.error.message;
      notifyListeners();
      return;
    }
    notifyListeners();
    _coordinator.goToHome();
  }
}
