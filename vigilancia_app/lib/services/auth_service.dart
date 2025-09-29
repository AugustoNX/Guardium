import 'package:firebase_auth/firebase_auth.dart';
import 'package:vigilancia_app/models/usuario.dart';
import 'package:vigilancia_app/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<Usuario?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        return await _getUserData(result.user!.uid);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<Usuario?> createUserWithEmailAndPassword(
    String email, 
    String password, 
    String nome
  ) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        final usuario = Usuario(
          uid: result.user!.uid,
          nome: nome,
          email: email,
        );
        
        await DatabaseService().createUser(usuario);
        return usuario;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao criar conta: $e');
    }
  }

  Future<Usuario?> _getUserData(String uid) async {
    try {
      final userData = await DatabaseService().getUser(uid);
      if (userData != null) {
        return Usuario.fromMap(uid, userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Erro ao enviar email de recuperação: $e');
    }
  }
}
