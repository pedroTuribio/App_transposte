class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.cpf = '',
    this.registration = '',
  });

  final String id;
  final String name;
  final String email;
  final String cpf;
  final String registration;

  factory User.fromJson(Map<String, dynamic> json) {
    final raw = json['user'];
    final data = raw is Map<String, dynamic> ? raw : json;
    return User(
      id: '${data['id'] ?? ''}',
      name: '${data['name'] ?? data['nome'] ?? ''}',
      email: '${data['email'] ?? ''}',
      cpf: '${data['cpf'] ?? ''}',
      registration:
          '${data['registration'] ?? data['matricula'] ?? data['student_id'] ?? ''}',
    );
  }

  User copyWith({String? cpf}) => User(
        id: id,
        name: name,
        email: email,
        cpf: cpf ?? this.cpf,
        registration: registration,
      );
}
