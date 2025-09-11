import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmascota/paginas/usuario/mis_chats_page.dart';
import 'package:sosmascota/paginas/veterinario/pagina_mascotas_ayuda.dart';
import 'package:sosmascota/paginas/usuario/PaginaPerfilAjustes.dart';
import 'package:sosmascota/vistamodelos/autenticacion_vistamodelo.dart';

class PantallaInicioVeterinario extends StatelessWidget {
  const PantallaInicioVeterinario({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = [
      {
        'icono': Icons.volunteer_activism,
        'texto': 'Mascotas que necesitan ayuda',
        'descripcion': 'Ayuda a mascotas en situación vulnerable',
        'gradiente': [const Color(0xFF667eea), const Color(0xFF764ba2)],
        'accion': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PaginaMascotasAyuda()),
          );
        },
      },
      {
        'icono': Icons.chat_bubble_outline,
        'texto': 'Mis Chats',
        'descripcion': 'Conversaciones con dueños de mascotas',
        'gradiente': [const Color(0xFF2196F3), const Color(0xFF21CBF3)],
        'accion': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MisChatsPage()),
          );
        },
      },
      {
        'icono': Icons.account_circle_outlined,
        'texto': 'Perfil / Ajustes',
        'descripcion': 'Configuración de tu cuenta',
        'gradiente': [const Color(0xFF10B981), const Color(0xFF059669)],
        'accion': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PaginaPerfilAjustes()),
          );
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel Veterinario',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              _mostrarDialogoCerrarSesion(context);
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Color(0xFFE3F2FD)],
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFF8FAFB)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Bienvenido Doctor!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tu ayuda es fundamental para el bienestar de las mascotas',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: opciones.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) {
                    final item = opciones[index];
                    return GestureDetector(
                      onTap: item['accion'] as VoidCallback,
                      child: Card(
                        elevation: 12,
                        shadowColor: Colors.black.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Color(0xFFFAFBFC)],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: item['gradiente'] as List<Color>,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (item['gradiente']
                                                as List<Color>)[0]
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    item['icono'] as IconData,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  item['texto'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['descripcion'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('¿Deseas cerrar sesión?'),
            content: const Text('Se cerrará tu cuenta actual.'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await Provider.of<AutenticacionVistaModelo>(
                    context,
                    listen: false,
                  ).cerrarSesion();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (_) => false,
                    );
                  }
                },
              ),
            ],
          ),
    );
  }
}
