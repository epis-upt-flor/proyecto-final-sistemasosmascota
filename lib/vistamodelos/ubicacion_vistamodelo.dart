import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class UbicacionVistaModelo extends ChangeNotifier {
  LatLng? _seleccion;
  LatLng? get seleccion => _seleccion;

  CameraPosition _camaraInicial = const CameraPosition(
    target: LatLng(-18.0066, -70.2463), // Tacna por defecto
    zoom: 16,
  );
  CameraPosition get camaraInicial => _camaraInicial;

  /// Carga la ubicación actual del dispositivo al iniciar
  Future<void> cargarUbicacionInicial() async {
    try {
      LocationPermission permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.always ||
          permiso == LocationPermission.whileInUse) {
        final posicion = await Geolocator.getCurrentPosition();
        _seleccion = LatLng(posicion.latitude, posicion.longitude);
        _camaraInicial = CameraPosition(target: _seleccion!, zoom: 17);
        notifyListeners();
      }
    } catch (e) {
      // Si falla, mantiene ubicación por defecto
    }
  }

  /// Actualiza la posición cuando el usuario toca el mapa
  void actualizarSeleccion(LatLng nuevaUbicacion) {
    _seleccion = nuevaUbicacion;
    notifyListeners();
  }
}
