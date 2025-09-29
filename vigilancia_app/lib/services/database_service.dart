import 'package:firebase_database/firebase_database.dart';
import 'package:vigilancia_app/models/cliente.dart';
import 'package:vigilancia_app/models/usuario.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Usuário
  Future<void> createUser(Usuario usuario) async {
    await _database.child('usuarios').child(usuario.uid).set(usuario.toMap());
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final snapshot = await _database.child('usuarios').child(uid).get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  // Clientes
  Future<String> createCliente(String uid, Cliente cliente) async {
    final clienteRef = _database.child('usuarios').child(uid).child('clientes').push();
    await clienteRef.set(cliente.toMap());
    return clienteRef.key!;
  }

  Future<void> updateCliente(String uid, String clienteId, Cliente cliente) async {
    await _database
        .child('usuarios')
        .child(uid)
        .child('clientes')
        .child(clienteId)
        .update(cliente.toMap());
  }

  Future<void> deleteCliente(String uid, String clienteId) async {
    await _database
        .child('usuarios')
        .child(uid)
        .child('clientes')
        .child(clienteId)
        .remove();
  }

  Future<List<Cliente>> getClientes(String uid) async {
    final snapshot = await _database.child('usuarios').child(uid).child('clientes').get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> clientesMap = Map<dynamic, dynamic>.from(snapshot.value as Map);
      return clientesMap.entries
          .map((entry) => Cliente.fromMap(entry.key, Map<String, dynamic>.from(entry.value)))
          .toList();
    }
    return [];
  }

  Stream<List<Cliente>> getClientesStream(String uid) {
    return _database
        .child('usuarios')
        .child(uid)
        .child('clientes')
        .onValue
        .map((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> clientesMap = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        return clientesMap.entries
            .map((entry) => Cliente.fromMap(entry.key, Map<String, dynamic>.from(entry.value)))
            .toList();
      }
      return <Cliente>[];
    });
  }

  // Pagamentos
  Future<void> updateStatusPagamento(String uid, String clienteId, String mesAno, bool pago) async {
    await _database
        .child('usuarios')
        .child(uid)
        .child('clientes')
        .child(clienteId)
        .child('statusPagamento')
        .child(mesAno)
        .set(pago);
  }

  // Relatórios
  Future<Map<String, dynamic>> getRelatorioMes(String uid, String mesAno) async {
    final clientes = await getClientes(uid);
    
    int totalClientes = clientes.length;
    int clientesAdimplentes = clientes.where((c) => c.isAdimplente(mesAno)).length;
    int clientesInadimplentes = totalClientes - clientesAdimplentes;
    
    double valorTotal = clientes.fold(0.0, (sum, c) => sum + c.valor);
    double valorRecebido = clientes
        .where((c) => c.isAdimplente(mesAno))
        .fold(0.0, (sum, c) => sum + c.valor);
    double valorPendente = valorTotal - valorRecebido;

    return {
      'totalClientes': totalClientes,
      'clientesAdimplentes': clientesAdimplentes,
      'clientesInadimplentes': clientesInadimplentes,
      'valorTotal': valorTotal,
      'valorRecebido': valorRecebido,
      'valorPendente': valorPendente,
    };
  }

  Future<List<Cliente>> getClientesInadimplentes(String uid, String mesAno) async {
    final clientes = await getClientes(uid);
    return clientes.where((c) => !c.isAdimplente(mesAno)).toList();
  }
}
