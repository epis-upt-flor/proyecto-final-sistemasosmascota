import 'package:cloud_firestore/cloud_firestore.dart';

class MascotaModelo {
  final String nombre;
  final String descripcion;
  final String tipo;
  final String estado;
  final double latitud;
  final double longitud;
  final DateTime fecha;
  final List<String> urlImagenes;
  final String uidUsuario;
  final DateTime publicadoEn; // ✅ nuevo campo

  MascotaModelo({
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.estado,
    required this.latitud,
    required this.longitud,
    required this.fecha,
    required this.urlImagenes,
    required this.uidUsuario,
    required this.publicadoEn, // ✅ constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'tipo': tipo,
      'estado': estado,
      'latitud': latitud,
      'longitud': longitud,
      'fecha': Timestamp.fromDate(fecha),
      'urlImagenes': urlImagenes,
      'uidUsuario': uidUsuario,
      'publicadoEn': Timestamp.fromDate(publicadoEn), // ✅ guardar
    };
  }

  factory MascotaModelo.fromMap(Map<String, dynamic> map) {
    return MascotaModelo(
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      tipo: map['tipo'] ?? '',
      estado: map['estado'] ?? '',
      latitud: map['latitud']?.toDouble() ?? 0.0,
      longitud: map['longitud']?.toDouble() ?? 0.0,
      fecha: (map['fecha'] as Timestamp).toDate(),
      urlImagenes: List<String>.from(map['urlImagenes'] ?? []),
      uidUsuario: map['uidUsuario'] ?? '',
      publicadoEn: map['publicadoEn'] != null
          ? (map['publicadoEn'] as Timestamp).toDate()
          : DateTime.now(), // Por compatibilidad con datos antiguos
    );
  }
}
