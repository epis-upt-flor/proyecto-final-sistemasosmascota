import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sosmascota/vistamodelos/mascota_vistamodelo.dart';
import 'package:sosmascota/paginas/usuario/pagina_ubicacion.dart';
import 'package:sosmascota/vistamodelos/ubicacion_vistamodelo.dart';
import 'package:sosmascota/api/servicio_openai.dart';

class PaginaReportarMascota extends StatefulWidget {
  const PaginaReportarMascota({super.key});

  @override
  State<PaginaReportarMascota> createState() => _PaginaReportarMascotaEstado();
}

class _PaginaReportarMascotaEstado extends State<PaginaReportarMascota> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  String? _tipoSeleccionado;
  String _estadoSeleccionado = 'perdida';

  @override
  Widget build(BuildContext context) {
    final vistaModelo = Provider.of<MascotaVistaModelo>(context);
    final imagenes = vistaModelo.imagenes;
    final ubicacion = vistaModelo.ubicacion;
    final cargando = vistaModelo.cargando;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reportar Mascota',
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
          ),
        ),
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: cargando,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sección de imágenes
                    Card(
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF667eea),
                                        Color(0xFF764ba2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF667eea,
                                        ).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Fotos de la Mascota',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap:
                                  () => _mostrarOpcionesImagen(
                                    context,
                                    vistaModelo,
                                  ),
                              child: Container(
                                height: 200,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF667eea).withOpacity(0.1),
                                      const Color(0xFF764ba2).withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF667eea,
                                    ).withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child:
                                    imagenes.isEmpty
                                        ? const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_photo_alternate,
                                                size: 48,
                                                color: Color(0xFF667eea),
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                'Toca para agregar imágenes',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF4A5568),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: imagenes.length,
                                          separatorBuilder:
                                              (_, __) =>
                                                  const SizedBox(width: 12),
                                          itemBuilder:
                                              (_, index) => Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                            0,
                                                            4,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Image.file(
                                                        File(
                                                          imagenes[index].path,
                                                        ),
                                                        width: 150,
                                                        height: 170,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 8,
                                                    right: 8,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFFE53E3E,
                                                                ),
                                                                Color(
                                                                  0xFFC53030,
                                                                ),
                                                              ],
                                                            ),
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  2,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                        onPressed:
                                                            () => vistaModelo
                                                                .eliminarImagen(
                                                                  index,
                                                                ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Información básica
                    Card(
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4299E1),
                                        Color(0xFF3182CE),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF4299E1,
                                        ).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Información Básica',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _nombre,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre de la mascota',
                                  prefixIcon: Icon(
                                    Icons.badge,
                                    color: Color(0xFF4299E1),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _descripcion,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Descripción',
                                  prefixIcon: Icon(
                                    Icons.description,
                                    color: Color(0xFF4299E1),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de mascota',
                                  prefixIcon: Icon(
                                    Icons.category,
                                    color: Color(0xFF4299E1),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                                value: _tipoSeleccionado,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'perro',
                                    child: Text('Perro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'gato',
                                    child: Text('Gato'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'otro',
                                    child: Text('Otro'),
                                  ),
                                ],
                                onChanged:
                                    (valor) => setState(
                                      () => _tipoSeleccionado = valor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Estado de la mascota
                    Card(
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFED8936),
                                        Color(0xFFDD6B20),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFED8936,
                                        ).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.help_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Estado de la Mascota',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      color:
                                          _estadoSeleccionado == 'perdida'
                                              ? const Color(
                                                0xFFE53E3E,
                                              ).withOpacity(0.1)
                                              : Colors.transparent,
                                    ),
                                    child: RadioListTile<String>(
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.search,
                                            color: Color(0xFFE53E3E),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Perdida',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 'perdida',
                                      groupValue: _estadoSeleccionado,
                                      activeColor: const Color(0xFFE53E3E),
                                      onChanged:
                                          (value) => setState(
                                            () => _estadoSeleccionado = value!,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    color:
                                        _estadoSeleccionado == 'adopcion'
                                            ? const Color(
                                              0xFF38A169,
                                            ).withOpacity(0.1)
                                            : Colors.transparent,
                                    child: RadioListTile<String>(
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Color(0xFF38A169),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'En adopción',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 'adopcion',
                                      groupValue: _estadoSeleccionado,
                                      activeColor: const Color(0xFF38A169),
                                      onChanged:
                                          (value) => setState(
                                            () => _estadoSeleccionado = value!,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(12),
                                      ),
                                      color:
                                          _estadoSeleccionado == 'ayuda'
                                              ? const Color(
                                                0xFFED8936,
                                              ).withOpacity(0.1)
                                              : Colors.transparent,
                                    ),
                                    child: RadioListTile<String>(
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.healing,
                                            color: Color(0xFFED8936),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Necesita ayuda',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 'ayuda',
                                      groupValue: _estadoSeleccionado,
                                      activeColor: const Color(0xFFED8936),
                                      onChanged:
                                          (value) => setState(
                                            () => _estadoSeleccionado = value!,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Ubicación
                    Card(
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF48BB78),
                                        Color(0xFF38A169),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF48BB78,
                                        ).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Ubicación',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ubicacion == null
                                              ? 'Ubicación no detectada'
                                              : 'Ubicación detectada',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                        if (ubicacion != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            'Lat: ${ubicacion.latitude.toStringAsFixed(6)}\nLng: ${ubicacion.longitude.toStringAsFixed(6)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF718096),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF48BB78),
                                          Color(0xFF38A169),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        final resultado = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => ChangeNotifierProvider(
                                                  create:
                                                      (_) =>
                                                          UbicacionVistaModelo(),
                                                  child:
                                                      const PaginaUbicacion(),
                                                ),
                                          ),
                                        );
                                        if (resultado != null &&
                                            resultado is LatLng) {
                                          vistaModelo.setUbicacionManual(
                                            resultado.latitude,
                                            resultado.longitude,
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Seleccionar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botón de registrar
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667eea).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Registrar Reporte',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (imagenes.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Debe agregar al menos una imagen',
                                ),
                                backgroundColor: Color(0xFFE53E3E),
                              ),
                            );
                            return;
                          }

                          final urlImagen = await vistaModelo
                              .subirImagenYObtenerURL(imagenes[0]);

                          final verificador = ServicioOpenAI();
                          final esValida = await verificador
                              .verificarImagenMascota(urlImagen);

                          if (!esValida) {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Color(0xFFED8936),
                                        ),
                                        SizedBox(width: 8),
                                        Text("Imagen no válida"),
                                      ],
                                    ),
                                    content: const Text(
                                      "La imagen registrada no es de una mascota",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    actions: [
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF667eea),
                                              Color(0xFF764ba2),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text(
                                            "Aceptar",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                            return;
                          }

                          final ok = await vistaModelo.guardarReporte(
                            nombre: _nombre.text.trim(),
                            descripcion: _descripcion.text.trim(),
                            tipo: _tipoSeleccionado,
                            estado: _estadoSeleccionado,
                          );

                          if (ok && mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reporte registrado con éxito'),
                                backgroundColor: Color(0xFF38A169),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al registrar'),
                                backgroundColor: Color(0xFFE53E3E),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            if (cargando)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF667eea),
                          ),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Registrando reporte...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _mostrarOpcionesImagen(
    BuildContext context,
    MascotaVistaModelo vistaModelo,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8FAFB)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Seleccionar imagen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Tomar foto',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await vistaModelo.tomarFoto();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4299E1), Color(0xFF3182CE)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4299E1).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.photo, color: Colors.white),
                      title: const Text(
                        'Elegir desde galería',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await vistaModelo.seleccionarDesdeGaleria();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
