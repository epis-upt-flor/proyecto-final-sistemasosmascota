import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/vistamodelos/autenticacion_vistamodelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosmascota/modelos/usuario_modelo.dart';

class PantallaVerificacion extends StatefulWidget {
  const PantallaVerificacion({super.key});

  @override
  State<PantallaVerificacion> createState() => _PantallaVerificacionEstado();
}

class _PantallaVerificacionEstado extends State<PantallaVerificacion> {
  bool _verificacionRealizada = false;

  @override
  void initState() {
    super.initState();
    // La verificación se hace en el build usando Consumer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AutenticacionVistaModelo>(
          builder: (context, vistaModelo, child) {
            // Verificar sesión solo una vez
            if (!_verificacionRealizada) {
              _verificacionRealizada = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _verificarSesionConVistaModelo(vistaModelo);
              });
            }
            
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            );
          },
        ),
      ),
    );
  }

  Future<void> _verificarSesionConVistaModelo(AutenticacionVistaModelo vistaModelo) async {
    try {
      final uid = vistaModelo.usuarioActual?.uid ?? vistaModelo.obtenerUID();

      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .get();

        if (doc.exists) {
          final datos = doc.data()!;
          final usuario = UsuarioModelo.fromMap(uid, datos);
          vistaModelo.usuarioActual = usuario;

          // Redirigir según rol
          if (!mounted) return;
          
          switch (usuario.rol) {
            case 'usuario':
              Navigator.pushReplacementNamed(context, '/inicioUsuario');
              break;
            case 'veterinario':
              Navigator.pushReplacementNamed(context, '/inicioVeterinario');
              break;
            case 'admin':
              Navigator.pushReplacementNamed(context, '/inicioAdmin');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/');
          }
        } else {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/');
        }
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      print('Error verificando sesión: $e');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
