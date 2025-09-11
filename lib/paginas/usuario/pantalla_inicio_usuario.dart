// lib/paginas/usuario/pantalla_inicio_usuario.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sosmascota/vistamodelos/autenticacion_vistamodelo.dart';
import 'package:sosmascota/paginas/usuario/pagina_reportar_mascota.dart';
import 'package:sosmascota/vistamodelos/mascota_vistamodelo.dart';
import 'package:sosmascota/paginas/usuario/pagina_mascotas_reportadas.dart';
import 'package:sosmascota/vistamodelos/vista_mascotas_vistamodelo.dart';
import 'package:sosmascota/paginas/usuario/pagina_mis_reportes.dart';
import 'package:sosmascota/paginas/usuario/mis_chats_page.dart';
import 'package:sosmascota/paginas/usuario/PaginaPerfilAjustes.dart';

/// 🎨 Paleta alineada al login
const Color kColorFondo = Color(0xFF0E1320); // fondo oscuro como el mockup
const Color kColorCard = Color(0xFF161C2C);
const Color kColorBorde = Color(0xFF242B3D);
const Color kColorPrimario = Color(0xFF667EEA);
const Color kColorMorado = Color(0xFF764BA2);
const Color kTexto = Color(0xFFE6E8EF);
const Color kTextoSec = Color(0xFF9AA3B2);

const LinearGradient kGradienteHeader = LinearGradient(
  colors: [kColorPrimario, kColorMorado],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class PantallaInicioUsuario extends StatefulWidget {
  const PantallaInicioUsuario({super.key});

  @override
  State<PantallaInicioUsuario> createState() => _PantallaInicioUsuarioEstado();
}

class _PantallaInicioUsuarioEstado extends State<PantallaInicioUsuario>
    with WidgetsBindingObserver {
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final vistaModelo = Provider.of<AutenticacionVistaModelo>(
      context,
      listen: false,
    );

    if (state == AppLifecycleState.paused) {
      _temporizador = Timer(const Duration(seconds: 10), () async {
        await vistaModelo.cerrarSesion();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      });
    } else if (state == AppLifecycleState.resumed) {
      _temporizador?.cancel();
    }
  }

  // --------- Navegaciones (acciones) ----------
  VoidCallback _goReportar() => () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider(
              create: (_) => MascotaVistaModelo(),
              child: const PaginaReportarMascota(),
            ),
      ),
    );
  };

  VoidCallback _goVerCerca() => () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider(
              create: (_) => VistaMascotasVistaModelo(),
              child: const PaginaMascotasReportadas(),
            ),
      ),
    );
  };

  VoidCallback _goMisReportes() => () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaginaMisReportes()),
    );
  };

  VoidCallback _goChats() => () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MisChatsPage()),
    );
  };

  VoidCallback _goPerfil() => () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaginaPerfilAjustes()),
    );
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorFondo,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ====== APP BAR + HERO ======
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: kColorFondo,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: const [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: kColorPrimario,
                    child: Icon(Icons.pets, color: Colors.white, size: 16),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'xxxxxxxxx',
                    style: TextStyle(
                      color: kTexto,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: kTexto),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: kTexto),
                  tooltip: 'Cerrar sesión',
                  onPressed: () async {
                    final vm = Provider.of<AutenticacionVistaModelo>(
                      context,
                      listen: false,
                    );
                    await vm.cerrarSesion();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (_) => false,
                      );
                    }
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(190),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: _HeroCard(
                    onReportar: _goReportar(),
                    onVerAlertas: _goVerCerca(),
                  ),
                ),
              ),
            ),

            // ====== ACCIONES RÁPIDAS ======
            SliverToBoxAdapter(child: _SectionTitle('Acciones Rápidas')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionSmallCard(
                        icon: Icons.search,
                        title: 'Buscar Mascota',
                        subtitle: 'Encuentra mascotas cerca de ti',
                        onTap: _goVerCerca(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionSmallCard(
                        icon: Icons.location_on,
                        title: 'Mapa de Avistamientos',
                        subtitle: 'Ver ubicaciones recientes',
                        onTap: _goVerCerca(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ====== ALERTAS RECIENTES ======
            SliverToBoxAdapter(
              child: _SectionTitle(
                'Alertas Recientes',
                trailing: TextButton(
                  onPressed: _goVerCerca(),
                  child: const Text(
                    'Ver todas',
                    style: TextStyle(color: kTexto),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                _AlertItem(
                  avatarUrl:
                      'https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=200&auto=format&fit=crop',
                  titulo: 'Max - Golden Retriever',
                  subtitulo: 'Visto por última vez en Av. Bolognesi',
                  tiempo: 'Hace 2 horas • 2.1 km',
                  estado: 'PERDIDO',
                  estadoColor: const Color(0xFFFF6B6B),
                  onTap: _goVerCerca(),
                ),
                _AlertItem(
                  avatarUrl:
                      'https://images.unsplash.com/photo-1592194996308-7b43878e84a0?q=80&w=200&auto=format&fit=crop',
                  titulo: 'Luna - Gato Atigrado',
                  subtitulo: 'Encontrado en Calle 5ta Norte',
                  tiempo: 'Hace 4 horas • 1.8 km',
                  estado: 'ENCONTRADO',
                  estadoColor: const Color(0xFF2ED573),
                  onTap: _goVerCerca(),
                ),
              ]),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ====== ESTADÍSTICAS ======
            SliverToBoxAdapter(
              child: _SectionTitle('Estadísticas de la Comunidad'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Row(
                  children: const [
                    Expanded(
                      child: _StatCard(numero: '156', etiqueta: 'Rescates'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(numero: '23', etiqueta: 'Casos Activos'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(numero: '892', etiqueta: 'Voluntarios'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ====== Bottom Navigation (estilo mockup) ======
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: const BoxDecoration(
          color: kColorCard,
          border: Border(top: BorderSide(color: kColorBorde)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomItem(
              icon: Icons.home_filled,
              label: 'Inicio',
              activo: true,
              onTap: () {},
            ),
            _BottomItem(
              icon: Icons.search,
              label: 'Buscar',
              onTap: _goVerCerca(),
            ),
            _BottomItem(
              icon: Icons.add_circle_outline,
              label: 'Reportar',
              onTap: _goReportar(),
            ),
            _BottomItem(
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              onTap: _goChats(),
            ),
            _BottomItem(
              icon: Icons.person_outline,
              label: 'Perfil',
              onTap: _goPerfil(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------- Widgets UI -----------------

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onReportar, required this.onVerAlertas});

  final VoidCallback onReportar;
  final VoidCallback onVerAlertas;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: kGradienteHeader,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¡Ayuda a encontrar\nmascotas!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Únete a nuestra comunidad de rescatistas',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onReportar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kColorPrimario,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reportar Perdida',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onVerAlertas,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white70),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ver Alertas',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionSmallCard extends StatelessWidget {
  const _QuickActionSmallCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kColorBorde),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kColorPrimario.withOpacity(.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kColorPrimario.withOpacity(.35)),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: kTexto,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: kTextoSec, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  const _AlertItem({
    required this.avatarUrl,
    required this.titulo,
    required this.subtitulo,
    required this.tiempo,
    required this.estado,
    required this.estadoColor,
    required this.onTap,
  });

  final String avatarUrl;
  final String titulo;
  final String subtitulo;
  final String tiempo;
  final String estado;
  final Color estadoColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kColorCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kColorBorde),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            titulo,
                            style: const TextStyle(
                              color: kTexto,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: estadoColor.withOpacity(.15),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: estadoColor.withOpacity(.45),
                            ),
                          ),
                          child: Text(
                            estado,
                            style: TextStyle(
                              color: estadoColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: const TextStyle(color: kTextoSec, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tiempo,
                      style: const TextStyle(color: kTextoSec, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.numero, required this.etiqueta});

  final String numero;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: kColorCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kColorBorde, width: 1),
      ),
      child: Column(
        children: [
          Text(
            numero,
            style: const TextStyle(
              color: kTexto,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            etiqueta,
            style: const TextStyle(color: kTextoSec, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.texto, {this.trailing});

  final String texto;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: kColorPrimario,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                color: kTexto,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    this.activo = false,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = activo ? Colors.white : kTextoSec;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
