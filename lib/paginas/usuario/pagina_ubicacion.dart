import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/vistamodelos/ubicacion_vistamodelo.dart';

class PaginaUbicacion extends StatefulWidget {
  const PaginaUbicacion({super.key});

  @override
  State<PaginaUbicacion> createState() => _PaginaUbicacionEstado();
}

class _PaginaUbicacionEstado extends State<PaginaUbicacion> {
  @override
  void initState() {
    super.initState();
    Provider.of<UbicacionVistaModelo>(
      context,
      listen: false,
    ).cargarUbicacionInicial();
  }

  @override
  Widget build(BuildContext context) {
    final ubicacionVM = Provider.of<UbicacionVistaModelo>(context);
    final posicion = ubicacionVM.seleccion;
    final camaraInicial = ubicacionVM.camaraInicial;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Seleccionar ubicación')),
        body:
            posicion == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: GoogleMap(
                    initialCameraPosition: camaraInicial,
                    onTap: (LatLng nuevaPosicion) {
                      ubicacionVM.actualizarSeleccion(nuevaPosicion);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('seleccion'),
                        position: posicion,
                      ),
                    },
                  ),
                ),
        floatingActionButton:
            posicion != null
                ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context, posicion);
                  },
                  child: const Icon(Icons.check),
                )
                : null,
      ),
    );
  }
}
