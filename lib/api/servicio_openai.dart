import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicioOpenAI {
  final String _apiKey = 'TU_API_KEY'; // Tu API key aquí

  Future<bool> verificarImagenMascota(String urlImagen) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');

    final body = {
      "model": "gpt-4o", // o gpt-4-vision-preview
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text":
                  "¿La siguiente imagen muestra una mascota (perro, gato u otro animal doméstico)? Responde solo con 'sí' o 'no'.",
            },
            {
              "type": "image_url",
              "image_url": {"url": urlImagen},
            },
          ],
        },
      ],
      "max_tokens": 10,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final texto =
            data["choices"][0]["message"]["content"].toString().toLowerCase();
        return texto.contains("sí");
      } else {
        print("Error OpenAI: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Excepción al verificar imagen con OpenAI: $e");
      return false;
    }
  }
}
