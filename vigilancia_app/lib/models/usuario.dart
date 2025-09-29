class Usuario {
  final String uid;
  final String nome;
  final String email;

  Usuario({
    required this.uid,
    required this.nome,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
    };
  }

  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
