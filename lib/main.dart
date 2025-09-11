import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'controladores/tema_controller.dart';

import 'vistamodelos/autenticacion_vistamodelo.dart';
import 'paginas/login/pagina_login.dart';
import 'paginas/login/pagina_registro.dart';
import 'paginas/login/pantalla_verificacion.dart';
import 'paginas/login/pagina_intro.dart';
import 'paginas/usuario/pantalla_inicio_usuario.dart';
import 'paginas/veterinario/pantalla_inicio_veterinario.dart';
import 'paginas/admin/pantalla_inicio_admin.dart';

// 🔧 Handler para notificaciones en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📨 [Background] Mensaje: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔧 Inicializar handler de fondo
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MiAplicacion());
}

class MiAplicacion extends StatefulWidget {
  const MiAplicacion({super.key});

  @override
  State<MiAplicacion> createState() => _MiAplicacionState();
}

class _MiAplicacionState extends State<MiAplicacion> {
  @override
  void initState() {
    super.initState();

    // 🔔 Notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("🔔 [Foreground] Notificación recibida:");
        print("Título: ${message.notification!.title}");
        print("Cuerpo: ${message.notification!.body}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaActual,
      builder: (context, modo, _) {
        return ChangeNotifierProvider(
          create: (_) => AutenticacionVistaModelo(),
          child: MaterialApp(
            title: 'SOSMascota',
            debugShowCheckedModeBanner: false,
            themeMode: modo,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.teal,
              scaffoldBackgroundColor: Colors.grey.shade100,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                centerTitle: true,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(primary: Colors.teal),
              scaffoldBackgroundColor: Colors.grey[900],
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                centerTitle: true,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
            initialRoute: '/intro',
            routes: {
              '/verificar': (context) => const PantallaVerificacion(),
              '/': (context) => const PaginaLogin(),
              '/registro': (context) => const PaginaRegistro(),
              '/inicioUsuario': (context) => const PantallaInicioUsuario(),
              '/inicioVeterinario':
                  (context) => const PantallaInicioVeterinario(),
              '/inicioAdmin': (context) => const PantallaInicioAdmin(),
              '/intro': (context) => const PaginaIntro(),
            },
          ),
        );
      },
    );
  }
}
