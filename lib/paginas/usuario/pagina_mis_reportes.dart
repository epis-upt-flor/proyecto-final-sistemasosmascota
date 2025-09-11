import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/vistamodelos/mis_reportes_vistamodelo.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class PaginaMisReportes extends StatelessWidget {
  const PaginaMisReportes({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MisReportesVistaModelo()..cargarReportes(),
      child: Consumer<MisReportesVistaModelo>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Mis Reportes',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
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
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando mis reportes...',
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
                  : Column(
                      children: [
                        // Filtro moderno
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
                                    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Filtrar por tipo:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButton<String>(
                                    value: vm.tipoSeleccionado,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A90E2)),
                                    items: ['Todos', 'perro', 'gato', 'otro'].map((tipo) {
                                      return DropdownMenuItem(
                                        value: tipo,
                                        child: Text(
                                          tipo == 'Todos' ? 'Todos los tipos' : tipo.capitalize(),
                                          style: const TextStyle(
                                            color: Color(0xFF4A5568),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (valor) {
                                      if (valor != null) {
                                        vm.actualizarFiltro(valor);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: vm.reportes.isEmpty
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
                                                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.pets,
                                              size: 48,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          const Text(
                                            "No tienes reportes aún",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2D3748),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            "Tus reportes de mascotas\naparecerán aquí",
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
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  itemCount: vm.reportes.length,
                                  itemBuilder: (context, index) {
                                    final mascota = vm.reportes[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
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
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: mascota.urlImagenes.isNotEmpty
                                                        ? Image.network(
                                                            mascota.urlImagenes.first,
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Container(
                                                            decoration: BoxDecoration(
                                                              gradient: const LinearGradient(
                                                                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                                              ),
                                                              borderRadius: BorderRadius.circular(16),
                                                            ),
                                                            child: const Icon(
                                                              Icons.pets,
                                                              size: 40,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                // Información de la mascota
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        mascota.nombre,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
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
                                                      const SizedBox(height: 8),
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
                                                              size: 16,
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
                                                    ],
                                                  ),
                                                ),
                                                // Estado y acciones
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: _getEstadoGradient(mascota.estado),
                                                        ),
                                                        borderRadius: BorderRadius.circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: _getEstadoGradient(mascota.estado)[0].withOpacity(0.3),
                                                            blurRadius: 6,
                                                            offset: const Offset(0, 3),
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
                                                    const SizedBox(height: 12),
                                                    if (_canEditEstado(mascota.estado))
                                                      GestureDetector(
                                                        onTap: () async {
                                                          String nuevoEstado = '';
                                                          String mensaje = '';

                                                          if (mascota.estado == 'perdida') {
                                                            nuevoEstado = 'encontrada';
                                                            mensaje = "¿Deseas marcar esta mascota como 'encontrada'?";
                                                          } else if (mascota.estado == 'adopcion') {
                                                            nuevoEstado = 'adoptada';
                                                            mensaje = "¿Deseas marcar esta mascota como 'adoptada'?";
                                                          } else if (mascota.estado == 'necesita ayuda' || mascota.estado == 'ayuda') {
                                                            nuevoEstado = 'atendida';
                                                            mensaje = "¿Deseas marcar esta mascota como 'atendida'?";
                                                          } else {
                                                            return;
                                                          }

                                                          final confirmar = await showDialog<bool>(
                                                            context: context,
                                                            builder: (_) => AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              title: const Row(
                                                                children: [
                                                                  Icon(Icons.edit, color: Color(0xFF4A90E2)),
                                                                  SizedBox(width: 8),
                                                                  Text("Cambiar estado"),
                                                                ],
                                                              ),
                                                              content: Text(
                                                                mensaje,
                                                                style: const TextStyle(fontSize: 16),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () => Navigator.pop(context, false),
                                                                  child: const Text(
                                                                    "Cancelar",
                                                                    style: TextStyle(color: Color(0xFF718096)),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    gradient: const LinearGradient(
                                                                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  child: TextButton(
                                                                    onPressed: () => Navigator.pop(context, true),
                                                                    child: const Text(
                                                                      "Confirmar",
                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          if (confirmar == true) {
                                                            await vm.actualizarEstado(mascota, nuevoEstado);
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFF4A90E2).withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: const Icon(
                                                            Icons.edit,
                                                            size: 20,
                                                            color: Color(0xFF4A90E2),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
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

  // Métodos helper para el diseño
  Color _getTipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'perro':
        return const Color(0xFF4A90E2);
      case 'gato':
        return const Color(0xFF48BB78);
      case 'otro':
        return const Color(0xFFED8936);
      default:
        return const Color(0xFF718096);
    }
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'perro':
        return Icons.pets;
      case 'gato':
        return Icons.pets;
      case 'otro':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }

  List<Color> _getEstadoGradient(String estado) {
    switch (estado.toLowerCase()) {
      case 'perdida':
        return [const Color(0xFFE53E3E), const Color(0xFFC53030)];
      case 'adopcion':
      case 'en adopción':
        return [const Color(0xFFED8936), const Color(0xFFDD6B20)];
      case 'ayuda':
      case 'necesita ayuda':
        return [const Color(0xFF9F7AEA), const Color(0xFF805AD5)];
      case 'encontrada':
        return [const Color(0xFF48BB78), const Color(0xFF38A169)];
      case 'adoptada':
        return [const Color(0xFF4299E1), const Color(0xFF3182CE)];
      case 'atendida':
        return [const Color(0xFF38A169), const Color(0xFF2F855A)];
      default:
        return [const Color(0xFF718096), const Color(0xFF4A5568)];
    }
  }

  String _getEstadoText(String estado) {
    switch (estado.toLowerCase()) {
      case 'perdida':
        return 'PERDIDA';
      case 'adopcion':
      case 'en adopción':
        return 'ADOPCIÓN';
      case 'ayuda':
      case 'necesita ayuda':
        return 'AYUDA';
      case 'encontrada':
        return 'ENCONTRADA';
      case 'adoptada':
        return 'ADOPTADA';
      case 'atendida':
        return 'ATENDIDA';
      default:
        return estado.toUpperCase();
    }
  }

  bool _canEditEstado(String estado) {
    return ['perdida', 'adopcion', 'en adopción', 'ayuda', 'necesita ayuda'].contains(estado.toLowerCase());
  }
}
