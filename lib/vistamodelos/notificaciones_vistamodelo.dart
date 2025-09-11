// lib/vistamodelos/notificaciones_vistamodelo.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificacionesVistaModelo extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _localNotifs;
  int _badge = 0;
  final Map<String, StreamSubscription> _subs = {};

  NotificacionesVistaModelo(this._localNotifs);

  int get badge => _badge;

  void _incrementarBadge() {
    _badge++;
    notifyListeners();
  }

  void listenToReporte(String reporteId) {
    if (_subs.containsKey(reporteId)) return;
    final sub = FirebaseFirestore.instance
        .collection('reportes')
        .doc(reporteId)
        .snapshots()
        .listen((snap) {
          if (!snap.exists) return;
          final estado = (snap.data()?['estado'] ?? '').toString();
          _showLocal('Reporte actualizado', 'Estado: $estado');
          _incrementarBadge();
        });
    _subs[reporteId] = sub;
  }

  void listenToChat(String chatId, String miUid) {
    if (_subs.containsKey(chatId)) return;
    final sub = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('mensajes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snap) {
          for (final change in snap.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data()!;
              if (data['de'] != miUid) {
                _showLocal('Nuevo mensaje', data['texto'] as String);
                _incrementarBadge();
              }
            }
          }
        });
    _subs[chatId] = sub;
  }

  Future<void> _showLocal(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'canal_inapp',
      'In-App',
      channelDescription: 'Notificaciones in-app',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iOSDetails = DarwinNotificationDetails();
    await _localNotifs.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iOSDetails),
    );
  }

  void clearAll() {
    for (final sub in _subs.values) sub.cancel();
    _subs.clear();
    _badge = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    clearAll();
    super.dispose();
  }
}
