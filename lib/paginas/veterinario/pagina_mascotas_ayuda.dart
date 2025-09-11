import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/vistamodelos/vista_mascotas_vistamodelo.dart';
import 'package:sosmascota/paginas/usuario/detalle_mascota.dart';

class PaginaMascotasAyuda extends StatelessWidget {
  const PaginaMascotasAyuda({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VistaMascotasVistaModelo()..cargarMascotas(),
      child: Consumer<VistaMascotasVistaModelo>(
        builder: (context, vm, _) {
          final mascotasAyuda = vm.mascotas
              .where((m) => m.estado == 'ayuda')
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Mascotas que Necesitan Ayuda',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                  ),
                ),
              ),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFE3F2FD),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header informativo médico
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
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Casos Médicos Urgentes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              Text(
                                '${mascotasAyuda.length} mascota${mascotasAyuda.length == 1 ? '' : 's'} necesita${mascotasAyuda.length == 1 ? '' : 'n'} atención médica',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contenido principal
                  Expanded(
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
                                    blurRadius: 15,
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
                                    'Buscando casos médicos...',
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
                        : mascotasAyuda.isEmpty
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
                                              colors: [Color(0xFF10B981), Color(0xFF059669)],
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF10B981).withOpacity(0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.health_and_safety,
                                            size: 48,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        const Text(
                                          "¡Excelentes noticias!",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "No hay mascotas que necesiten\natención médica urgente",
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
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: mascotasAyuda.length,
                                itemBuilder: (context, index) {
                                  final mascota = mascotasAyuda[index];
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
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Header con nombre y badge urgente
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        mascota.nombre,
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF2D3748),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                                                        ),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: const Text(
                                                        'URGENTE',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                // Contenido principal
                                                Row(
                                                  children: [
                                                    // Imagen de la mascota
                                                    Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.1),
                                                            blurRadius: 8,
                                                            offset: const Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: mascota.urlImagenes.isNotEmpty
                                                            ? Image.network(
                                                                mascota.urlImagenes.first,
                                                                width: 80,
                                                                height: 80,
                                                                fit: BoxFit.cover,
                                                              )
                                                            : Container(
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    colors: _getTipoGradient(mascota.tipo),
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: const Icon(
                                                                  Icons.medical_services,
                                                                  size: 40,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    // Información expandida
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            mascota.descripcion,
                                                            maxLines: 3,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              color: Color(0xFF4A5568),
                                                              fontSize: 14,
                                                              height: 1.4,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 12),
                                                          // Badges de tipo y tiempo
                                                          Wrap(
                                                            spacing: 8,
                                                            runSpacing: 8,
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                                decoration: BoxDecoration(
                                                                  color: _getTipoColor(mascota.tipo).withOpacity(0.1),
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  border: Border.all(
                                                                    color: _getTipoColor(mascota.tipo).withOpacity(0.3),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Icon(
                                                                      _getTipoIcon(mascota.tipo),
                                                                      size: 12,
                                                                      color: _getTipoColor(mascota.tipo),
                                                                    ),
                                                                    const SizedBox(width: 4),
                                                                    Text(
                                                                      mascota.tipo,
                                                                      style: TextStyle(
                                                                        color: _getTipoColor(mascota.tipo),
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 11,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(0xFF718096).withOpacity(0.1),
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: const Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.access_time,
                                                                      size: 12,
                                                                      color: Color(0xFF718096),
                                                                    ),
                                                                    SizedBox(width: 4),
                                                                    Text(
                                                                      'Inmediata',
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        color: Color(0xFF718096),
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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

  // Métodos helper para colores y iconos médicos
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
        return [const Color(0xFFEF4444), const Color(0xFFDC2626)]; // Rojo médico por defecto
    }
  }
}
