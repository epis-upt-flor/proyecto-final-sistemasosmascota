import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:geolocator/geolocator.dart';

class PaginaIntro extends StatefulWidget {
  const PaginaIntro({super.key});

  @override
  State<PaginaIntro> createState() => _PaginaIntroEstado();
}

class _PaginaIntroEstado extends State<PaginaIntro> {
  final PageController _controladorPagina = PageController();

  Future<void> _verificarYActivarGPS() async {
    final permiso = await Permission.location.request();

    if (!mounted) return;

    if (permiso.isGranted) {
      final gpsActivo = await Geolocator.isLocationServiceEnabled();

      if (gpsActivo) {
        _irALogin();
      } else {
        await Geolocator.openLocationSettings();
        await Future.delayed(const Duration(seconds: 2));

        if (await Geolocator.isLocationServiceEnabled()) {
          _irALogin();
        } else {
          _mostrarMensaje('Por favor, activa el GPS para continuar');
        }
      }
    } else {
      _mostrarMensaje('Se necesita permiso de ubicación');
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _irALogin() {
    Navigator.pushReplacementNamed(context, '/verificar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controladorPagina,
              children: [
                _buildSlide(
                  titulo: 'Reporta mascotas',
                  descripcion:
                      'Registra mascotas perdidas o encontradas en tu zona.',
                  icono: Icons.pets,
                ),
                _buildSlide(
                  titulo: 'Encuentra ayuda',
                  descripcion:
                      'Explora mascotas reportadas cerca de ti y ayuda a sus dueños.',
                  icono: Icons.search,
                ),
                _buildSlide(
                  titulo: 'Activa tu ubicación',
                  descripcion:
                      'Activa el GPS para mejorar las búsquedas y reportes.',
                  icono: Icons.location_on,
                  mostrarBoton: true,
                  onBotonPresionado: _verificarYActivarGPS,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SmoothPageIndicator(
              controller: _controladorPagina,
              count: 3,
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Color(0xFF667EEA),
                dotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required String titulo,
    required String descripcion,
    required IconData icono,
    bool mostrarBoton = false,
    VoidCallback? onBotonPresionado,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icono, size: 56, color: Color(0xFF667EEA)),
          ),
          const SizedBox(height: 40),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            descripcion,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (mostrarBoton)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton.icon(
                onPressed: onBotonPresionado,
                icon: const Icon(Icons.gps_fixed),
                label: const Text(
                  'Activar GPS y Continuar',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
