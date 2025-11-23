import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:viotmec_mobile/presentation/providers/blanching_provider.dart';
import 'package:viotmec_mobile/presentation/providers/gudang_provider.dart';
import 'package:viotmec_mobile/data/models/blanching_model.dart';
import 'dart:math' as math;
import 'dart:async';

class BlanchingPage extends StatefulWidget {
  const BlanchingPage({super.key});

  @override
  State<BlanchingPage> createState() => _BlanchingPageState();
}

class _BlanchingPageState extends State<BlanchingPage> {
  String? _lastLoadedGudangId;
  int _currentChartIndex = 0;
  Timer? _backgroundTimer;

  final List<String> _chartTitles = [
    'Data Sensor Suhu',
    'Detail Sensor Suhu 1',
    'Detail Sensor Suhu  2',
  ];

  final Color colorSensor1 = const Color(0xFFFF5252);
  final Color colorSensor2 = const Color(0xFFFF9800);
  final Color colorTimerActive = const Color(0xFF4CAF50);
  final Color colorTimerInactive = const Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      _startBackgroundSync();
    });
  }

  @override
  void dispose() {
    _backgroundTimer?.cancel();
    super.dispose();
  }

  void _startBackgroundSync() {
    _backgroundTimer?.cancel();
    _backgroundTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final provider = Provider.of<BlanchingProvider>(context, listen: false);
      final gudangProvider = Provider.of<GudangProvider>(
        context,
        listen: false,
      );

      if (gudangProvider.activeGudangId != null) {
        provider.refreshDataBackground(gudangProvider.activeGudangId!);
      }
    });
  }

  void _loadInitialData() {
    final gudangProvider = Provider.of<GudangProvider>(context, listen: false);
    if (gudangProvider.activeGudangId != null) {
      _lastLoadedGudangId = gudangProvider.activeGudangId;
      Provider.of<BlanchingProvider>(
        context,
        listen: false,
      ).fetchData(_lastLoadedGudangId!);
    }
  }

  void _nextChart() {
    setState(() {
      _currentChartIndex = (_currentChartIndex + 1) % _chartTitles.length;
    });
  }

  void _previousChart() {
    setState(() {
      _currentChartIndex = (_currentChartIndex - 1) % _chartTitles.length;
    });
  }

  List<String> _getChartDataList(List<String> source) {
    if (source.isEmpty) return [];
    final latest = source.take(15).toList();
    return latest.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GudangProvider, BlanchingProvider>(
      builder: (context, gudangProvider, blanchingProvider, child) {
        final data = blanchingProvider.blanchingData;
        final activeId = gudangProvider.activeGudangId;

        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            blanchingProvider.fetchData(activeId);
          });
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (activeId != null) {
              await blanchingProvider.fetchData(activeId);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (activeId == null) _buildNoActiveGudangWidget(),
                if (activeId != null) ...[
                  _buildHeaderCard(blanchingProvider),
                  const SizedBox(height: 16),

                  if (blanchingProvider.isLoading)
                    _buildLoadingIndicator()
                  else if (blanchingProvider.error != null && data == null)
                    _buildErrorWidget(blanchingProvider.error!)
                  else ...[
                    if (blanchingProvider.timerResponse != null)
                      _buildTimerControlCard(
                        context,
                        blanchingProvider,
                        activeId,
                      ),
                    const SizedBox(height: 16),

                    if (data != null) ...[
                      _buildChartNavigation(),
                      const SizedBox(height: 16),
                      _buildCurrentChart(data),
                      const SizedBox(height: 16),
                      _buildQuickStatsCard(data),
                      const SizedBox(height: 16),
                      _buildSensorDetailsCard(data),
                    ],
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // --- WIDGETS: HEADER ---
  Widget _buildHeaderCard(BlanchingProvider provider) {
    final data = provider.blanchingData;
    final isActive = data?.isRoomActive ?? false;
    final avgSuhu = data?.rataRataSuhu ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFFEF5350), const Color(0xFFE53935)] // Merah
              : [Colors.grey.shade400, Colors.grey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isActive ? Colors.red : Colors.grey).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.soup_kitchen,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Blanching Aktif' : 'Blanching Non-Aktif',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Suhu Rata-rata: ${avgSuhu.toStringAsFixed(2)}°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS: TIMER CONTROL (UPDATED) ---
  Widget _buildTimerControlCard(
    BuildContext context,
    BlanchingProvider provider,
    String gudangId,
  ) {
    final timers = provider.timerResponse?.dataTimer ?? [];
    // Fokus ambil Timer 1
    final timer1 = timers.firstWhere(
      (t) => t.flagSensor == 'timer_1',
      orElse: () => TimerDetail(
        flagSensor: 'timer_1',
        flagTimer: 'stop',
        nilaiTimer: '0',
        limitTimer: '0',
        sisaTimer: 0,
        updatedAt: '',
      ),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20,
        ), // Radius lebih besar agar serasi
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.timer_outlined, size: 22, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    'Kontrol Timer 1',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              // Badge Status Kecil
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: timer1.isRunning
                      ? colorTimerActive.withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: timer1.isRunning
                        ? colorTimerActive.withOpacity(0.3)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  timer1.isRunning ? 'Aktif' : 'Idle',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: timer1.isRunning ? colorTimerActive : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTimerRow(context, provider, gudangId, timer1),
        ],
      ),
    );
  }

  Widget _buildTimerRow(
    BuildContext context,
    BlanchingProvider provider,
    String gudangId,
    TimerDetail timer,
  ) {
    final isRunning = timer.isRunning;
    final progress = timer.progress;

    // Warna utama berdasarkan status
    final activeColor = isRunning ? colorTimerActive : colorSensor2;

    // Limit dalam menit
    final limitMenit = (timer.limitTimerAsDouble / 60).toInt();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // BAGIAN KIRI: Circular Timer Visual
        Stack(
          alignment: Alignment.center,
          children: [
            // Background Circle
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: 1,
                color: Colors.grey.shade100,
                strokeWidth: 8,
              ),
            ),
            // Progress Circle
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: isRunning ? progress : 0.0,
                backgroundColor: Colors.transparent,
                color: activeColor,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
              ),
            ),
            // Text Inside Circle
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isRunning ? Icons.play_arrow_rounded : Icons.stop_rounded,
                  color: isRunning ? activeColor : Colors.grey.shade400,
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  isRunning ? timer.formattedRemainingTime : "${limitMenit}m",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  isRunning ? 'Sisa' : 'Set',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(width: 24),

        // BAGIAN KANAN: Controls & Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Label
              Text(
                isRunning ? 'Proses Blanching' : 'Siap Memulai',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isRunning
                    ? 'Target: $limitMenit Menit'
                    : 'Atur waktu sebelum mulai',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Action
              Row(
                children: [
                  // Tombol Setting (Outlined)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isRunning
                          ? null // Disable setting saat jalan
                          : () => _showSetLimitDialog(
                              context,
                              provider,
                              gudangId,
                              'timer_1',
                            ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(
                        Icons.settings,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Start/Stop (Elevated)
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        provider.toggleTimer(gudangId);
                      },
                      icon: Icon(
                        isRunning
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline,
                        size: 20,
                      ),
                      label: Text(isRunning ? 'Stop' : 'Mulai'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunning
                            ? Colors.red.shade50
                            : colorTimerActive,
                        foregroundColor: isRunning ? Colors.red : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: isRunning ? 0 : 2,
                        shadowColor: colorTimerActive.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- DIALOG: Set Waktu (Beautified) ---
  Future<void> _showSetLimitDialog(
    BuildContext context,
    BlanchingProvider provider,
    String gudangId,
    String flagSensor,
  ) async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.timer_rounded, color: Colors.orange),
                  SizedBox(width: 10),
                  Text(
                    'Atur Durasi Timer',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan target waktu blanching dalam menit.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Durasi (Menit)',
                  hintText: 'Contoh: 15',
                  suffixText: 'Menit',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final limit = int.tryParse(controller.text);
                      if (limit != null && limit > 0) {
                        provider.setLimitTimer(gudangId, limit, flagSensor);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS: CHART ---
  Widget _buildChartNavigation() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _previousChart,
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade50,
              padding: const EdgeInsets.all(8),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Grafik ${(_currentChartIndex + 1)} / ${_chartTitles.length}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _chartTitles[_currentChartIndex],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _nextChart,
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade50,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentChart(BlanchingData data) {
    final suhu1Sensor = data.getSensorByFlag('suhu_1');
    final suhu2Sensor = data.getSensorByFlag('suhu_2');

    // Ambil data waktu dari salah satu sensor (biasanya sama)
    final waktuSensor =
        data.getTimeByFlag('suhu_1') ?? data.getTimeByFlag('suhu_2');

    // Parsing Data menggunakan _getChartDataList (Reversed: Lama -> Baru)
    final listWaktu = _getChartDataList(waktuSensor?.value ?? []);
    final valSuhu1 = _getChartDataList(suhu1Sensor?.value ?? []);
    final valSuhu2 = _getChartDataList(suhu2Sensor?.value ?? []);

    // Convert to double
    final dSuhu1 = valSuhu1.map((e) => double.tryParse(e) ?? 0.0).toList();
    final dSuhu2 = valSuhu2.map((e) => double.tryParse(e) ?? 0.0).toList();

    switch (_currentChartIndex) {
      case 0:
        return _buildComparisonChart(listWaktu, dSuhu1, dSuhu2);
      case 1:
        return _buildSingleChart(listWaktu, dSuhu1, 'Suhu 1', colorSensor1);
      case 2:
        return _buildSingleChart(listWaktu, dSuhu2, 'Suhu 2', colorSensor2);
      default:
        return const SizedBox();
    }
  }

  Widget _buildComparisonChart(
    List<String> waktu,
    List<double> s1,
    List<double> s2,
  ) {
    final allValues = [...s1, ...s2];
    final double minY = _getSafeMin(allValues) - 5;
    final double maxY = _getSafeMax(allValues) + 5;

    return _buildChartContainer(
      'Data Sensor Suhu 1 & 2',
      'Monitoring suhu 15 data terakhir',
      LineChart(
        _mainChartData(
          minY: minY < 0 ? 0 : minY,
          maxY: maxY,
          waktu: waktu,
          lineBarsData: [
            _buildLineBarData(s1, colorSensor1, false),
            _buildLineBarData(s2, colorSensor2, false),
          ],
        ),
      ),
      [
        _LegendItem(color: colorSensor1, text: 'Sensor 1'),
        _LegendItem(color: colorSensor2, text: 'Sensor 2'),
      ],
    );
  }

  Widget _buildSingleChart(
    List<String> waktu,
    List<double> data,
    String label,
    Color color,
  ) {
    final double minY = _getSafeMin(data) - 5;
    final double maxY = _getSafeMax(data) + 5;

    return _buildChartContainer(
      'Detail $label',
      'Grafik pergerakan suhu',
      LineChart(
        _mainChartData(
          minY: minY < 0 ? 0 : minY,
          maxY: maxY,
          waktu: waktu,
          lineBarsData: [_buildLineBarData(data, color, true)],
        ),
      ),
      [_LegendItem(color: color, text: label)],
    );
  }

  LineChartData _mainChartData({
    required double minY,
    required double maxY,
    required List<String> waktu,
    required List<LineChartBarData> lineBarsData,
  }) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.shade200,
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _calculateIntervalX(waktu.length),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < waktu.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _formatTimeShort(waktu[index]),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: (maxY - minY) / 5,
            getTitlesWidget: (value, meta) {
              if (value == minY || value == maxY) return const SizedBox();
              return Text(
                value.toInt().toString(),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: waktu.isNotEmpty ? (waktu.length - 1).toDouble() : 0,
      minY: minY,
      maxY: maxY,
      lineBarsData: lineBarsData,
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => Colors.blueGrey.withOpacity(0.9),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toStringAsFixed(1)}°C',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  LineChartBarData _buildLineBarData(
    List<double> data,
    Color color,
    bool withArea,
  ) {
    return LineChartBarData(
      spots: _prepareChartSpots(data),
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: withArea,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  // --- WIDGETS: STATS (Style matches FermentasiPage) ---
  Widget _buildQuickStatsCard(BlanchingData data) {
    final s1 = data.getSensorByFlag('suhu_1');
    final s2 = data.getSensorByFlag('suhu_2');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_rounded, size: 20, color: Color(0xFFFFC107)),
              SizedBox(width: 8),
              Text(
                'Rata-Rata & Data Terbaru',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildStatItem(
                'Suhu S1',
                '${s1?.avgAsDouble.toStringAsFixed(1) ?? "0.0"}°C',
                'Terbaru: ${s1?.latestValue.toStringAsFixed(1) ?? "0.0"}°C',
                Icons.thermostat,
                colorSensor1,
              ),
              _buildStatItem(
                'Suhu S2',
                '${s2?.avgAsDouble.toStringAsFixed(1) ?? "0.0"}°C',
                'Terbaru: ${s2?.latestValue.toStringAsFixed(1) ?? "0.0"}°C',
                Icons.thermostat,
                colorSensor2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.2), blurRadius: 4),
              ],
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS: LOGS (Style matches FermentasiPage) ---
  Widget _buildSensorDetailsCard(BlanchingData data) {
    final s1 = data.getSensorByFlag('suhu_1');
    final s2 = data.getSensorByFlag('suhu_2');
    final w1 = data.getTimeByFlag('suhu_1');

    // Data dari API sudah urut Terbaru -> Terlama (index 0 = terbaru)
    // Kita ambil 5 data pertama (terbaru)
    final int length = s1?.value.length ?? 0;
    List<Map<String, String>> logs = [];

    if (length > 0) {
      // Ambil max 5 data teratas (terbaru)
      final count = math.min(length, 5);
      for (int i = 0; i < count; i++) {
        logs.add({
          'waktu': w1?.value[i] ?? '-',
          's1': s1?.value[i] ?? '0',
          's2': s2?.value[i] ?? '0',
        });
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '5 Log Data Terakhir',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          if (logs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('Belum ada data')),
            )
          else
            Column(children: logs.map((log) => _buildDataItem(log)).toList()),
        ],
      ),
    );
  }

  Widget _buildDataItem(Map<String, String> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(
            log['waktu']!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const Spacer(),
          Icon(Icons.thermostat, size: 14, color: colorSensor1),
          const SizedBox(width: 4),
          Text('${log['s1']}°C', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 12),
          Icon(Icons.thermostat, size: 14, color: colorSensor2),
          const SizedBox(width: 4),
          Text('${log['s2']}°C', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // --- UTILS WIDGETS ---
  Widget _buildChartContainer(
    String title,
    String subtitle,
    Widget chart,
    List<Widget> legend,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 220, child: chart),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: legend,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateIntervalX(int length) {
    if (length <= 5) return 1;
    if (length <= 10) return 2;
    return 3;
  }

  String _formatTimeShort(String time) {
    if (time.length < 3) return time;
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  List<FlSpot> _prepareChartSpots(List<double> data) {
    return data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }

  double _getSafeMin(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce(math.min);
  }

  double _getSafeMax(List<double> data) {
    if (data.isEmpty) return 100;
    return data.reduce(math.max);
  }

  Widget _buildNoActiveGudangWidget() => Center(
    child: Column(
      children: [
        Icon(Icons.warehouse_outlined, size: 50, color: Colors.grey.shade300),
        const SizedBox(height: 10),
        Text(
          'Pilih Gudang Terlebih Dahulu',
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ],
    ),
  );

  Widget _buildLoadingIndicator() => const Padding(
    padding: EdgeInsets.all(20),
    child: Center(child: CircularProgressIndicator()),
  );

  Widget _buildErrorWidget(String msg) => Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        msg,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
