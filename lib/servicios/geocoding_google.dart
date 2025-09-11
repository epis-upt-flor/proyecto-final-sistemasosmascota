import 'dart:convert';
import 'package:http/http.dart' as http;

// Reemplaza con tu clave de API de Google (la que ya pusiste en AndroidManifest)
const String _googleApiKey = 'AIzaSyAVopVCLlwmQYmsqmTe7sKRp8hxUq-nYVUM';

/// Devuelve el nombre del distrito (administrative_area_level_3) o un fallback.
Future<String> obtenerDistritoGoogle(double lat, double lng) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json'
    '?latlng=$lat,$lng'
    '&key=$_googleApiKey'
    '&language=es',
  );

  final resp = await http.get(url);
  if (resp.statusCode != 200) return 'Sin distrito';

  final Map<String, dynamic> data = json.decode(resp.body);
  final results = data['results'] as List<dynamic>;
  if (results.isEmpty) return 'Sin distrito';

  final components = results[0]['address_components'] as List<dynamic>;

  // 1) Busca administrative_area_level_3
  for (final c in components) {
    final types = (c['types'] as List<dynamic>).cast<String>();
    if (types.contains('administrative_area_level_3')) {
      return c['long_name'] as String;
    }
  }
  // 2) Fallback a administrative_area_level_2 (provincia)
  for (final c in components) {
    final types = (c['types'] as List<dynamic>).cast<String>();
    if (types.contains('administrative_area_level_2')) {
      return c['long_name'] as String;
    }
  }
  return 'Sin distrito';
}
