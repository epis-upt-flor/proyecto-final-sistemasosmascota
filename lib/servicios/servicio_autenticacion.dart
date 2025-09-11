import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registrar usuario
  Future<String?> registrarUsuario({
    required String nombre,
    required String apellido,
    required String correo,
    required String clave,
    required String rol,
  }) async {
    try {
      final credenciales = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: clave,
      );

      // Guardar en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credenciales.user!.uid)
          .set({
            'nombre': nombre,
            'apellido': apellido,
            'correo': correo,
            'rol': rol,
            'fechaRegistro': FieldValue.serverTimestamp(),
          });

      return null; // todo ok
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido: $e';
    }
  }

  Future<void> actualizarNombreUsuario(String nuevoNombre) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('usuarios').doc(uid).update({
        'nombre': nuevoNombre,
      });
    }
  }

  // Iniciar sesión
  Future<String?> iniciarSesion({
    required String correo,
    required String clave,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: correo, password: clave);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'El correo ingresado no es válido.';
        case 'user-disabled':
          return 'Tu cuenta ha sido deshabilitada.';
        case 'user-not-found':
          return 'No existe un usuario con ese correo.';
        case 'wrong-password':
          return 'La contraseña es incorrecta.';
        default:
          return 'Error al iniciar sesión: ${e.message}';
      }
    } catch (_) {
      return 'Ocurrió un error inesperado. Intenta nuevamente.';
    }
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // Obtener UID actual
  String? obtenerUID() {
    return _auth.currentUser?.uid;
  }

  Future<User?> iniciarSesionConGoogle() async {
    try {
      final GoogleSignInAccount? cuentaGoogle = await GoogleSignIn().signIn();

      if (cuentaGoogle == null) return null; // cancelado

      final GoogleSignInAuthentication credenciales =
          await cuentaGoogle.authentication;

      final credencial = GoogleAuthProvider.credential(
        accessToken: credenciales.accessToken,
        idToken: credenciales.idToken,
      );

      final resultado = await _auth.signInWithCredential(credencial);
      final usuario = resultado.user;

      // Si es un nuevo usuario, guardarlo en Firestore
      final existe =
          await _firestore.collection('usuarios').doc(usuario!.uid).get();
      if (!existe.exists) {
        await _firestore.collection('usuarios').doc(usuario.uid).set({
          'nombre': usuario.displayName ?? '',
          'correo': usuario.email ?? '',
          'rol': 'usuario',
        });
      }

      return usuario;
    } catch (e) {
      print('Error en login con Google: $e');
      return null;
    }
  }
}
