class AuthSession {
  const AuthSession({required this.token, required this.email, this.cpf = ''});

  final String token;
  final String email;
  final String cpf;

  AuthSession copyWith({String? token, String? email, String? cpf}) =>
      AuthSession(
        token: token ?? this.token,
        email: email ?? this.email,
        cpf: cpf ?? this.cpf,
      );
}
