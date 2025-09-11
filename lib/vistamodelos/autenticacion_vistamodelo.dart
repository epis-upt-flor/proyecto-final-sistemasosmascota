import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../modelos/usuario_modelo.dart';
import '../servicios/servicio_autenticacion.dart';

class AutenticacionVistaModelo extends ChangeNotifier {
  final ServicioAutenticacion _servicio = ServicioAutenticacion();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UsuarioModelo? usuarioActual;
  String? mensajeError;

  Future<void> iniciarSesion(String correo, String clave) async {
    mensajeError = await _servicio.iniciarSesion(correo: correo, clave: clave);

    if (mensajeError == null) {
      final uid = _servicio.obtenerUID();
      final doc = await _firestore.collection('usuarios').doc(uid).get();

      if (doc.exists) {
        usuarioActual = UsuarioModelo.fromMap(uid!, doc.data()!);
        await _guardarTokenNotificacion(uid); // ✅ guardar token FCM
      } else {
        mensajeError = 'No se encontró información del usuario';
      }
    }

    notifyListeners();
  }

  Future<void> registrarUsuario(
    String nombre,
    String apellido,
    String correo,
    String clave,
  ) async {
    mensajeError = await _servicio.registrarUsuario(
      nombre: nombre,
      apellido: apellido,
      correo: correo,
      clave: clave,
      rol: 'usuario', // puedes cambiar esto si tienes otro sistema de roles
    );

    if (mensajeError == null) {
      final uid = _servicio.obtenerUID();
      final doc = await _firestore.collection('usuarios').doc(uid).get();

      if (doc.exists) {
        usuarioActual = UsuarioModelo.fromMap(uid!, doc.data()!);
        await _guardarTokenNotificacion(uid);
      }
    }

    notifyListeners();
  }

  Future<void> actualizarNombre(String nuevoNombre) async {
    await _servicio.actualizarNombreUsuario(nuevoNombre);

    if (usuarioActual != null) {
      usuarioActual = UsuarioModelo(
        uid: usuarioActual!.uid,
        nombre: nuevoNombre,
        apellido: usuarioActual!.apellido, // ✅ agregar apellido actual
        correo: usuarioActual!.correo,
        rol: usuarioActual!.rol,
      );
      notifyListeners();
    }
  }

  Future<void> cerrarSesion() async {
    await _servicio.cerrarSesion();
    usuarioActual = null;
    notifyListeners();
  }

  String? obtenerUID() {
    return _servicio.obtenerUID();
  }

  Future<User?> iniciarConGoogle() async {
    final usuario = await _servicio.iniciarSesionConGoogle();

    if (usuario != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(usuario.uid)
              .get();

      usuarioActual = UsuarioModelo.fromMap(usuario.uid, doc.data()!);
      await _guardarTokenNotificacion(usuario.uid); // ✅ guardar token FCM
      notifyListeners();
    }

    return usuario;
  }

  /// ✅ Guarda el token FCM en Firestore
  Future<void> _guardarTokenNotificacion(String uid) async {
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      await _firestore.collection('usuarios').doc(uid).set({
        'token': token,
      }, SetOptions(merge: true));

      print('✅ Token FCM guardado para $uid: $token');
    } else {
      print('⚠️ No se pudo obtener el token FCM');
    }
  }
}
