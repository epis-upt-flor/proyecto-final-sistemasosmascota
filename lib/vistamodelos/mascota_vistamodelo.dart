import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosmascota/modelos/mascota_modelo.dart';
import 'package:sosmascota/servicios/servicio_mascota.dart';

class MascotaVistaModelo extends ChangeNotifier {
  final ServicioMascota _servicio = ServicioMascota();

  final List<XFile> _imagenes = [];
  List<XFile> get imagenes => _imagenes;

  Position? _ubicacion;
  Position? get ubicacion => _ubicacion;

  bool _cargando = false;
  bool get cargando => _cargando;

  final ImagePicker _picker = ImagePicker();

  Future<void> tomarFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      _imagenes.add(foto);
      notifyListeners();
    }
  }

  Future<void> seleccionarDesdeGaleria() async {
    final List<XFile>? seleccionadas = await _picker.pickMultiImage();
    if (seleccionadas != null && seleccionadas.isNotEmpty) {
      _imagenes.addAll(seleccionadas);
      notifyListeners();
    }
  }

  Future<void> obtenerUbicacion() async {
    final permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.always ||
        permiso == LocationPermission.whileInUse) {
      _ubicacion = await Geolocator.getCurrentPosition();
      notifyListeners();
    }
  }

  Future<bool> guardarReporte({
    required String nombre,
    required String descripcion,
    required String? tipo,
    required String estado,
  }) async {
    if (_imagenes.isEmpty || _ubicacion == null || tipo == null) return false;

    _cargando = true;
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return false;

      final urls = await _servicio.subirImagenes(_imagenes);

      final now = DateTime.now(); // ✅ Obtener fecha y hora actual

      final mascota = MascotaModelo(
        nombre: nombre,
        descripcion: descripcion,
        tipo: tipo,
        estado: estado,
        latitud: _ubicacion!.latitude,
        longitud: _ubicacion!.longitude,
        fecha: now,
        urlImagenes: urls,
        uidUsuario: uid,
        publicadoEn: now, // ✅ Fecha y hora de publicación
      );

      await _servicio.registrarMascota(mascota);
      return true;
    } catch (e) {
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<String> subirImagenYObtenerURL(XFile imagen) async {
    return await _servicio.subirImagen(imagen);
  }

  void setUbicacionManual(double lat, double lng) {
    _ubicacion = Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 1.0,
      headingAccuracy: 1.0,
      isMocked: false,
    );
    notifyListeners();
  }

  void eliminarImagen(int index) {
    _imagenes.removeAt(index);
    notifyListeners();
  }
}
