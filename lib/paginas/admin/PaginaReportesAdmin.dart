import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sosmascota/servicios/servicio_mascota.dart';
import 'package:sosmascota/modelos/mascota_modelo.dart';

/// Polígonos aproximados de algunos distritos de Tacna
/// Cada lista cierra el polígono repitiendo el primer punto al final.
final Map<String, List<LatLng>> poligonosDistritos = {
  'Gregorio Albarracín': [
    const LatLng(-18.037625, -70.269285),
    const LatLng(-18.028035, -70.251088),
    const LatLng(-18.026566, -70.243793),
    const LatLng(-18.054232, -70.228129),
    const LatLng(-18.089065, -70.284956),
    const LatLng(-18.085047, -70.232560),
    const LatLng(-18.037625, -70.269285),
  ],
  'Tacna': [
    const LatLng(-18.037935, -70.269944),
    const LatLng(-18.089305, -70.289657),
    const LatLng(-18.027413, -70.291385),
    const LatLng(-18.006662, -70.262197),
    const LatLng(-17.997460, -70.246760),
    const LatLng(-17.997026, -70.239409),
    const LatLng(-17.996742, -70.237760),
    const LatLng(-18.016732, -70.220873),
    const LatLng(-18.027803, -70.251055),
    const LatLng(-18.037935, -70.269944),
  ],
  'Alto de la Alianza': [
    const LatLng(-18.006020, -70.262963),
    const LatLng(-17.997196, -70.247310),
    const LatLng(-17.993378, -70.228013),
    const LatLng(-17.980030, -70.246838),
    const LatLng(-17.989721, -70.266539),
    const LatLng(-18.006020, -70.262963),
  ],
  'Ciudad Nueva': [
    const LatLng(-17.990298, -70.229194),
    const LatLng(-17.985325, -70.222683),
    const LatLng(-17.972072, -70.234760),
    const LatLng(-17.978201, -70.246365),
    const LatLng(-17.990298, -70.229194),
  ],
  'Pocollay': [
    const LatLng(-17.990715, -70.228620),
    const LatLng(-17.983367, -70.217015),
    const LatLng(-17.967676, -70.230138),
    const LatLng(-17.962734, -70.221468),
    const LatLng(-17.967772, -70.201362),
    const LatLng(-17.979035, -70.187834),
    const LatLng(-17.994020, -70.199608),
    const LatLng(-18.012629, -70.222717),
    const LatLng(-18.007335, -70.228688),
    const LatLng(-17.996747, -70.237459),
    const LatLng(-17.990715, -70.228620),
  ],
};

/// Algoritmo ray-casting para determinar si un punto está dentro de un polígono.
bool puntoEnPoligono(LatLng p, List<LatLng> poly) {
  bool dentro = false;
  for (int i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final xi = poly[i].latitude, yi = poly[i].longitude;
    final xj = poly[j].latitude, yj = poly[j].longitude;
    final intersect =
        ((yi > p.longitude) != (yj > p.longitude)) &&
        (p.latitude < (xj - xi) * (p.longitude - yi) / (yj - yi) + xi);
    if (intersect) dentro = !dentro;
  }
  return dentro;
}

class PaginaReportesAdmin extends StatefulWidget {
  const PaginaReportesAdmin({super.key});

  @override
  State<PaginaReportesAdmin> createState() => _PaginaReportesAdminState();
}

class _PaginaReportesAdminState extends State<PaginaReportesAdmin> {
  final ServicioMascota _servicio = ServicioMascota();
  bool _cargando = true;

  // Contadores por estado
  int perdidas = 0, encontradas = 0;
  int adopcion = 0, adoptadas = 0;
  int ayuda = 0, atendidas = 0;

  // Contador por distrito usando polígonos
  Map<String, int> _conteoDistritos = {};

  // Filtros de fecha
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  Future<void> _cargarTodo() async {
    setState(() => _cargando = true);
    final mascotas = await _servicio.obtenerTodas();
    await _procesarListados(mascotas);
  }

  Future<void> _cargarPorFecha() async {
    if (_fechaInicio == null || _fechaFin == null) return;
    setState(() => _cargando = true);
    final todas = await _servicio.obtenerTodas();
    final filtradas =
        todas.where((m) {
          return m.publicadoEn.isAfter(_fechaInicio!) &&
              m.publicadoEn.isBefore(_fechaFin!.add(const Duration(days: 1)));
        }).toList();
    await _procesarListados(filtradas);
  }

  Future<void> _procesarListados(List<MascotaModelo> mascotas) async {
    _contarPorEstado(mascotas);
    _contarPorDistritoManual(mascotas);
    setState(() => _cargando = false);
  }

  void _contarPorEstado(List<MascotaModelo> mascotas) {
    perdidas = encontradas = 0;
    adopcion = adoptadas = 0;
    ayuda = atendidas = 0;
    for (var m in mascotas) {
      switch (m.estado.toLowerCase()) {
        case 'perdida':
          perdidas++;
          break;
        case 'encontrada':
          encontradas++;
          break;
        case 'adopcion':
          adopcion++;
          break;
        case 'adoptada':
          adoptadas++;
          break;
        case 'ayuda':
        case 'necesita ayuda':
          ayuda++;
          break;
        case 'atendida':
          atendidas++;
          break;
      }
    }
  }

  /// Cuenta distritos usando polígonos definidos manualmente
  void _contarPorDistritoManual(List<MascotaModelo> mascotas) {
    final Map<String, int> temp = {};
    for (var m in mascotas) {
      final punto = LatLng(m.latitud, m.longitud);
      String distrito = 'Sin distrito';
      poligonosDistritos.forEach((nombre, poly) {
        if (distrito == 'Sin distrito' && puntoEnPoligono(punto, poly)) {
          distrito = nombre;
        }
      });
      temp[distrito] = (temp[distrito] ?? 0) + 1;
    }
    _conteoDistritos = temp;
  }

  Widget _crearGrafico(
    String titulo,
    int total,
    int resultado,
    Color c1,
    Color c2,
    String t1,
    String t2,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              // Configuramos los ejes
              titlesData: FlTitlesData(
                // ─── EJE Y IZQUIERDO: sólo enteros cada 1 unidad ───
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      // Sólo mostramos etiquetas en valores enteros
                      if (value % 1 != 0) return const SizedBox();
                      return Text(value.toInt().toString());
                    },
                    reservedSize: 30,
                  ),
                ),
                // ─── EJE Y DERECHO: oculto ───
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                // ─── EJE X INFERIOR ───
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      // asumimos sólo dos barras: x=0 y x=1
                      switch (value.toInt()) {
                        case 0:
                          return Text(t1);
                        case 1:
                          return Text(t2);
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
                // ─── EJE X SUPERIOR: oculto ───
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              // Sin bordes extra
              borderData: FlBorderData(show: false),
              // Tus barras
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: total.toDouble(),
                      color: c1,
                      width: 30,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: resultado.toDouble(),
                      color: c2,
                      width: 30,
                    ),
                  ],
                ),
              ],
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1, // líneas de la cuadrícula cada 1
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _seleccionarFecha(BuildContext ctx, bool esInicio) async {
    final sel = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (sel != null) {
      setState(() {
        if (esInicio)
          _fechaInicio = sel;
        else
          _fechaFin = sel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    if (_cargando) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FFFE),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cargando reportes...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF667eea),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Ordena distritos de mayor a menor
    final listaDistritos =
        _conteoDistritos.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Reportes Generales',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FFFE), Color(0xFFF0F9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Reportes por distrito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4facfe).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  'Reportes por Distrito',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: listaDistritos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final e = listaDistritos[i];
                    final colors = [
                      [const Color(0xFF667eea), const Color(0xFF764ba2)],
                      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
                      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
                      [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
                      [const Color(0xFF667eea), const Color(0xFF764ba2)],
                    ];
                    final colorIndex = i % colors.length;
                    
                    return Container(
                      width: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors[colorIndex],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colors[colorIndex][0].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${e.value} reportes',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                height: 2,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Color(0xFF667eea), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),

              // Filtros de fecha
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _cargarTodo,
                              child: const Text(
                                'Mostrar todo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF667eea)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF667eea),
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () => _seleccionarFecha(context, true),
                              child: Text(
                                _fechaInicio == null
                                    ? 'Desde'
                                    : 'Desde: ${fmt.format(_fechaInicio!)}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF667eea)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF667eea),
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () => _seleccionarFecha(context, false),
                              child: Text(
                                _fechaFin == null
                                    ? 'Hasta'
                                    : 'Hasta: ${fmt.format(_fechaFin!)}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: _cargarPorFecha,
                            icon: const Icon(Icons.search, color: Colors.white),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Gráficos de estado
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _crearGrafico(
                        'Mascotas Perdidas y Encontradas',
                        perdidas + encontradas,
                        encontradas,
                        Colors.red,
                        Colors.green,
                        'Perdidas',
                        'Encontradas',
                      ),
                      _crearGrafico(
                        'Mascotas en Adopción y Adoptadas',
                        adopcion + adoptadas,
                        adoptadas,
                        Colors.orange,
                        Colors.teal,
                        'En Adopción',
                        'Adoptadas',
                      ),
                      _crearGrafico(
                        'Mascotas que Necesitaron Ayuda y Atendidas',
                        ayuda + atendidas,
                        atendidas,
                        Colors.purple,
                        Colors.blue,
                        'Ayuda',
                        'Atendidas',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
