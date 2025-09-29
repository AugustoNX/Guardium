class Cliente {
  final String id;
  final String nome;
  final String telefone;
  final String cidade;
  final String rua;
  final String bairro;
  final String numero;
  final String modalidade;
  final double valor;
  final Map<String, bool> statusPagamento;

  Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.cidade,
    required this.rua,
    required this.bairro,
    required this.numero,
    required this.modalidade,
    required this.valor,
    this.statusPagamento = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'cidade': cidade,
      'rua': rua,
      'bairro': bairro,
      'numero': numero,
      'modalidade': modalidade,
      'valor': valor,
      'statusPagamento': statusPagamento,
    };
  }

  factory Cliente.fromMap(String id, Map<String, dynamic> map) {
    return Cliente(
      id: id,
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      cidade: map['cidade'] ?? '',
      rua: map['rua'] ?? '',
      bairro: map['bairro'] ?? '',
      numero: map['numero'] ?? '',
      modalidade: map['modalidade'] ?? '',
      valor: (map['valor'] ?? 0.0).toDouble(),
      statusPagamento: Map<String, bool>.from(map['statusPagamento'] ?? {}),
    );
  }

  Cliente copyWith({
    String? id,
    String? nome,
    String? telefone,
    String? cidade,
    String? rua,
    String? bairro,
    String? numero,
    String? modalidade,
    double? valor,
    Map<String, bool>? statusPagamento,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      cidade: cidade ?? this.cidade,
      rua: rua ?? this.rua,
      bairro: bairro ?? this.bairro,
      numero: numero ?? this.numero,
      modalidade: modalidade ?? this.modalidade,
      valor: valor ?? this.valor,
      statusPagamento: statusPagamento ?? this.statusPagamento,
    );
  }

  String get enderecoCompleto => '$rua, n°$numero - $bairro, $cidade';
  
  bool isAdimplente(String mesAno) {
    return statusPagamento[mesAno] ?? false;
  }
}
