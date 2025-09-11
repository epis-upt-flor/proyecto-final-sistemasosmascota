import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/vistamodelos/autenticacion_vistamodelo.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginEstado();
}

class _PaginaLoginEstado extends State<PaginaLogin> {
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _clave = TextEditingController();
  bool _cargando = false;

  void _iniciarSesion(BuildContext context) async {
    setState(() => _cargando = true);

    final vm = Provider.of<AutenticacionVistaModelo>(context, listen: false);
    await vm.iniciarSesion(_correo.text.trim(), _clave.text.trim());

    if (!mounted) return;

    setState(() => _cargando = false);

    if (vm.mensajeError != null) {
      _mostrarError(context, vm.mensajeError!);
    } else {
      final rol = vm.usuarioActual?.rol;
      switch (rol) {
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
          _mostrarError(context, 'Rol desconocido');
      }
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOGO
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 56,
                    color: Color(0xFF667EEA),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bienvenido a SOSMascota',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
                ),
                const SizedBox(height: 32),

                // INPUT: Correo
                TextField(
                  controller: _correo,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // INPUT: Contraseña
                TextField(
                  controller: _clave,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // BOTÓN INGRESAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : () => _iniciarSesion(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF667EEA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _cargando
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),

                // ENLACE REGISTRO
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/registro'),
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Color(0xFF667EEA)),
                  ),
                ),
                const SizedBox(height: 16),

                // DIVISOR
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('O', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 16),

                // BOTÓN GOOGLE
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.login, color: Color(0xFF4285F4)),
                    label: const Text(
                      'Ingresar con Google',
                      style: TextStyle(fontSize: 15, color: Color(0xFF2D3748)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFCBD5E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final vm = Provider.of<AutenticacionVistaModelo>(
                        context,
                        listen: false,
                      );
                      final usuario = await vm.iniciarConGoogle();

                      if (!context.mounted) return;

                      final rol = vm.usuarioActual?.rol ?? 'usuario';
                      final ruta =
                          {
                            'usuario': '/inicioUsuario',
                            'veterinario': '/inicioVeterinario',
                            'admin': '/inicioAdmin',
                          }[rol] ??
                          '/';

                      Navigator.pushReplacementNamed(context, ruta);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
