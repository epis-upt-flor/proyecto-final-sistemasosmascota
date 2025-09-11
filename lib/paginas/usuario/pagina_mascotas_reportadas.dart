import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/vistamodelos/vista_mascotas_vistamodelo.dart';
import 'detalle_mascota.dart';

class PaginaMascotasReportadas extends StatelessWidget {
  const PaginaMascotasReportadas({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VistaMascotasVistaModelo()..cargarMascotas(),
      child: Consumer<VistaMascotasVistaModelo>(
        builder: (context, vm, _) {
          final mascotasFiltradas =
              vm.mascotas
                  .where((m) => m.estado == 'perdida' || m.estado == 'adopcion')
                  .toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Mascotas Reportadas',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
                ),
              ),
              child: vm.cargando
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando mascotas...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A5568),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : mascotasFiltradas.isEmpty
                      ? Center(
                          child: Card(
                            margin: const EdgeInsets.all(32),
                            elevation: 8,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, Color(0xFFF8FAFB)],
                                ),
                              ),
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF667eea).withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    "No hay mascotas disponibles",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Las mascotas reportadas\naparecerán aquí",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            // Header informativo
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, Color(0xFFF8FAFB)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.pets,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Mascotas disponibles',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                      Text(
                                        '${mascotasFiltradas.length} mascota${mascotasFiltradas.length == 1 ? '' : 's'} reportada${mascotasFiltradas.length == 1 ? '' : 's'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF718096),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Lista de mascotas
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: mascotasFiltradas.length,
                                itemBuilder: (context, index) {
                                  final mascota = mascotasFiltradas[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DetalleMascotaPage(mascota: mascota),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 8,
                                        shadowColor: Colors.black12,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Colors.white, Color(0xFFFAFBFC)],
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              children: [
                                                // Imagen de la mascota
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.15),
                                                        blurRadius: 10,
                                                        offset: const Offset(0, 5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: mascota.urlImagenes.isNotEmpty
                                                        ? Image.network(
                                                            mascota.urlImagenes.first,
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Container(
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                colors: _getTipoGradient(mascota.tipo),
                                                              ),
                                                              borderRadius: BorderRadius.circular(16),
                                                            ),
                                                            child: const Icon(
                                                              Icons.pets,
                                                              size: 50,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                // Información de la mascota
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        mascota.nombre,
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF2D3748),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        mascota.descripcion,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Color(0xFF4A5568),
                                                          fontSize: 14,
                                                          height: 1.4,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                            decoration: BoxDecoration(
                                                              color: _getTipoColor(mascota.tipo).withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(
                                                                color: _getTipoColor(mascota.tipo).withOpacity(0.3),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  _getTipoIcon(mascota.tipo),
                                                                  size: 14,
                                                                  color: _getTipoColor(mascota.tipo),
                                                                ),
                                                                const SizedBox(width: 4),
                                                                Text(
                                                                  mascota.tipo.capitalize(),
                                                                  style: TextStyle(
                                                                    color: _getTipoColor(mascota.tipo),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                colors: _getEstadoGradient(mascota.estado),
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: _getEstadoGradient(mascota.estado)[0].withOpacity(0.3),
                                                                  blurRadius: 4,
                                                                  offset: const Offset(0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Text(
                                                              _getEstadoText(mascota.estado),
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Indicador de navegación
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF667eea).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16,
                                                    color: Color(0xFF667eea),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
          );
        },
      ),
    );
  }

  // Métodos helper para colores y iconos
  Color _getTipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'perro':
        return const Color(0xFF8B5CF6);
      case 'gato':
        return const Color(0xFFEC4899);
      case 'ave':
        return const Color(0xFF06B6D4);
      case 'reptil':
        return const Color(0xFF10B981);
      case 'roedor':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'perro':
        return Icons.pets;
      case 'gato':
        return Icons.pets;
      case 'ave':
        return Icons.flutter_dash;
      case 'reptil':
        return Icons.bug_report;
      case 'roedor':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }

  List<Color> _getTipoGradient(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'perro':
        return [const Color(0xFF8B5CF6), const Color(0xFFA855F7)];
      case 'gato':
        return [const Color(0xFFEC4899), const Color(0xFFF472B6)];
      case 'ave':
        return [const Color(0xFF06B6D4), const Color(0xFF0891B2)];
      case 'reptil':
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case 'roedor':
        return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      default:
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)];
    }
  }

  List<Color> _getEstadoGradient(String estado) {
    switch (estado.toLowerCase()) {
      case 'perdida':
        return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
      case 'adopcion':
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case 'encontrada':
        return [const Color(0xFF3B82F6), const Color(0xFF2563EB)];
      default:
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)];
    }
  }

  String _getEstadoText(String estado) {
    switch (estado.toLowerCase()) {
      case 'perdida':
        return 'PERDIDA';
      case 'adopcion':
        return 'ADOPCIÓN';
      case 'encontrada':
        return 'ENCONTRADA';
      default:
        return estado.toUpperCase();
    }
  }
}
