import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosmascota/modelos/mascota_modelo.dart';

class MisReportesVistaModelo extends ChangeNotifier {
  List<MascotaModelo> _todos = [];
  List<MascotaModelo> reportes = [];
  bool cargando = false;
  String tipoSeleccionado = 'Todos';

  Future<void> cargarReportes() async {
    cargando = true;
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Usuario no autenticado');

      final consulta =
          await FirebaseFirestore.instance
              .collection('mascotas')
              .where('uidUsuario', isEqualTo: uid)
              .get();

      _todos.clear();
      for (final doc in consulta.docs) {
        _todos.add(MascotaModelo.fromMap(doc.data()));
      }

      // Ordenar por fecha de publicación (más reciente primero)
      _todos.sort((a, b) => b.publicadoEn.compareTo(a.publicadoEn));

      aplicarFiltro();
    } catch (e) {
      print('⚠️ Error al cargar reportes: $e');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void actualizarFiltro(String tipo) {
    tipoSeleccionado = tipo;
    aplicarFiltro();
  }

  void aplicarFiltro() {
    if (tipoSeleccionado == 'Todos') {
      reportes = List.from(_todos);
    } else {
      reportes = _todos.where((r) => r.tipo == tipoSeleccionado).toList();
    }
    notifyListeners();
  }

  Future<void> actualizarEstado(
    MascotaModelo mascota,
    String nuevoEstado,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Usuario no autenticado');

      print(
        '🔍 Buscando mascota con: uid=$uid, nombre=${mascota.nombre}, publicadoEn=${mascota.publicadoEn}',
      );

      final consulta =
          await FirebaseFirestore.instance
              .collection('mascotas')
              .where('uidUsuario', isEqualTo: uid)
              .where('nombre', isEqualTo: mascota.nombre)
              .where(
                'publicadoEn',
                isEqualTo: Timestamp.fromDate(mascota.publicadoEn),
              )
              .get();

      if (consulta.docs.isNotEmpty) {
        final docRef = consulta.docs.first.reference;
        await docRef.update({'estado': nuevoEstado});
        await cargarReportes(); // recargar datos actualizados
      } else {
        print('❌ No se encontró el documento de la mascota.');
      }
    } catch (e) {
      print('⚠️ Error al actualizar estado: $e');
    }
  }
}
