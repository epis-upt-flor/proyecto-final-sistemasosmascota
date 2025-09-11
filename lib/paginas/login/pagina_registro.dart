import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/vistamodelos/autenticacion_vistamodelo.dart';

class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  State<PaginaRegistro> createState() => _PaginaRegistroState();
}

class _PaginaRegistroState extends State<PaginaRegistro> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellido = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _clave = TextEditingController();
  bool _cargando = false;

  void _registrarUsuario(BuildContext context) async {
    setState(() => _cargando = true);

    final vm = Provider.of<AutenticacionVistaModelo>(context, listen: false);
    await vm.registrarUsuario(
      _nombre.text.trim(),
      _apellido.text.trim(),
      _correo.text.trim(),
      _clave.text.trim(),
    );

    if (!mounted) return;

    setState(() => _cargando = false);

    if (vm.mensajeError != null) {
      _mostrarError(context, vm.mensajeError!);
    } else {
      Navigator.pushReplacementNamed(context, '/inicioUsuario');
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
                  'Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Regístrate para ayudar a mascotas perdidas',
                  style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // INPUTS
                _buildCampo('Nombre', Icons.person, _nombre),
                const SizedBox(height: 16),
                _buildCampo('Apellido', Icons.person_outline, _apellido),
                const SizedBox(height: 16),
                _buildCampo(
                  'Correo electrónico',
                  Icons.email,
                  _correo,
                  tipo: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildCampo('Contraseña', Icons.lock, _clave, esPassword: true),

                const SizedBox(height: 24),

                // BOTÓN REGISTRAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        _cargando ? null : () => _registrarUsuario(context),
                    icon: const Icon(Icons.app_registration),
                    label:
                        _cargando
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Registrarse',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF667EEA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ENLACE LOGIN
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Color(0xFF667EEA)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCampo(
    String label,
    IconData icono,
    TextEditingController controlador, {
    bool esPassword = false,
    TextInputType tipo = TextInputType.text,
  }) {
    return TextField(
      controller: controlador,
      obscureText: esPassword,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
