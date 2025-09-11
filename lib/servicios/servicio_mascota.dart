import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosmascota/modelos/mascota_modelo.dart';

class ServicioMascota {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registrarMascota(MascotaModelo mascota) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('Usuario no autenticado');
    }

    final datos = mascota.toMap();
    await _firestore.collection('mascotas').add(datos);
  }

  Future<List<String>> subirImagenes(List<XFile> imagenes) async {
    final urls = <String>[];
    for (var img in imagenes) {
      final ref = _storage
          .ref()
          .child('mascotas')
          .child('${DateTime.now().millisecondsSinceEpoch}_${img.name}');
      await ref.putFile(File(img.path));
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  // ✅ NUEVO: Subir una sola imagen y obtener su URL
  Future<String> subirImagen(XFile imagen) async {
    final ref = _storage
        .ref()
        .child('mascotas')
        .child('${DateTime.now().millisecondsSinceEpoch}_${imagen.name}');
    await ref.putFile(File(imagen.path));
    return await ref.getDownloadURL();
  }

  // ✅ Obtener todas las mascotas
  Future<List<MascotaModelo>> obtenerTodas() async {
    final snapshot = await _firestore.collection('mascotas').get();
    return snapshot.docs
        .map((doc) => MascotaModelo.fromMap(doc.data()))
        .toList();
  }
}
