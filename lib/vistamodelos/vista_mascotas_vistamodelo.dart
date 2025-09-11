import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosmascota/modelos/mascota_modelo.dart';

class VistaMascotasVistaModelo extends ChangeNotifier {
  final List<MascotaModelo> _todas = [];
  bool _cargando = false;

  List<MascotaModelo> get mascotas => _todas;
  bool get cargando => _cargando;

  Future<void> cargarMascotas() async {
    _cargando = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('mascotas')
              .orderBy('fecha', descending: true)
              .get();

      _todas.clear();
      for (var doc in snapshot.docs) {
        _todas.add(MascotaModelo.fromMap(doc.data()));
      }
    } catch (e) {
      print('Error al cargar mascotas: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
