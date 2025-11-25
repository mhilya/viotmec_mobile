import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:viotmec_mobile/presentation/providers/fermentasi_provider.dart';
import 'package:viotmec_mobile/presentation/providers/gudang_provider.dart';
import 'dart:math' as math;

class FermentasiPage extends StatefulWidget {
  const FermentasiPage({super.key});

  @override
  State<FermentasiPage> createState() => _FermentasiPageState();
}

class _FermentasiPageState extends State<FermentasiPage> {
  String? _lastLoadedGudangId;
  int _currentChartIndex = 0;

  final List<String> _chartTitles = [
    'Data Suhu & Kelembaban',
    'Data Sensor Suhu',
    'Data Sensor Kelembaban',
    'Standard Deviation Suhu',
    'Standard Deviation Kelembaban',
  ];

  final Color colorSensor1 = const Color(0xFFFF6B6B);
  final Color colorSensor2 = const Color(0xFFFFA07A);
  final Color colorKelembaban1 = const Color(0xFF45B7D1);
  final Color colorKelembaban2 = const Color(0xFF20B2AA);
  final Color colorThreshold = const Color(0xFFd40624);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final gudangProvider = Provider.of<GudangProvider>(context, listen: false);
    if (gudangProvider.activeGudangId != null) {
      _lastLoadedGudangId = gudangProvider.activeGudangId;
      Provider.of<FermentasiProvider>(context, listen: false)
          .fetchData(_lastLoadedGudangId);
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

  List<Map<String, dynamic>> _getLatest15Data(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return [];
    if (data.length <= 15) return List.from(data.reversed);
    return data.sublist(data.length - 15).reversed.toList();
  }

@override
  Widget build(BuildContext context) {
    return Consumer2<GudangProvider, FermentasiProvider>(
      builder: (context, gudangProvider, fermentasiProvider, child) {
        final data = fermentasiProvider.data;
        final activeId = gudangProvider.activeGudangId;

        // Logic existing untuk load data saat ganti gudang
        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            fermentasiProvider.fetchData(activeId);
          });
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            if (activeId != null) {
              await fermentasiProvider.fetchData(activeId);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(), 
            child: Column(
              children: [
                if (activeId == null) _buildNoActiveGudangWidget(),
                if (activeId != null) ...[
                  _buildHeaderCard(fermentasiProvider),
                  const SizedBox(height: 16),
                  if (fermentasiProvider.isLoading)
                    _buildLoadingIndicator() 
                  else if (fermentasiProvider.errorMessage.isNotEmpty && data == null)
                    _buildErrorWidget(fermentasiProvider)
                  else if (data != null) ...[
                    _buildChartNavigation(),
                    const SizedBox(height: 16),
                    _buildCurrentChart(fermentasiProvider),
                    const SizedBox(height: 16),
                    _buildQuickStatsCard(fermentasiProvider),
                    const SizedBox(height: 16),
                    _buildSensorDetailsCard(fermentasiProvider),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildCurrentChart(FermentasiProvider provider) {
    switch (_currentChartIndex) {
      case 0:
        return _buildSuhuVsKelembabanChart(provider);
      case 1:
        return _buildSuhuComparisonChart(provider);
      case 2:
        return _buildKelembabanComparisonChart(provider);
      case 3:
        return _buildStdDevSuhuChart(provider);
      case 4:
        return _buildStdDevKelembabanChart(provider);
      default:
        return _buildSuhuComparisonChart(provider);
    }
  }

  Widget _buildSuhuVsKelembabanChart(FermentasiProvider provider) {
    final sensor1Data = _getLatest15Data(provider.chartDataSensor1);
    final sensor2Data = _getLatest15Data(provider.chartDataSensor2);

    final suhu1 = provider.getSuhuValues(sensor1Data);
    final suhu2 = provider.getSuhuValues(sensor2Data);
    final kel1 = provider.getKelembabanValues(sensor1Data);
    final kel2 = provider.getKelembabanValues(sensor2Data);
    final waktu = provider.referenceList(sensor1Data, sensor2Data);

    return _buildChartContainer(
      'Data Suhu dan Kelembaban',
      'Monitoring Gabungan (S1 & S2)',
      LineChart(
        _mainChartData(
          minY: 0,
          maxY: 100,
          waktu: waktu,
          lineBarsData: [
            _buildLineBarData(suhu1, colorSensor1, false),
            _buildLineBarData(suhu2, colorSensor2, false),
            _buildLineBarData(kel1, colorKelembaban1, false),
            _buildLineBarData(kel2, colorKelembaban2, false),
          ],
          leftTitleSuffix: '',
          intervalY: 20,
        ),
      ),
      [
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LegendItem(color: colorSensor1, text: 'Suhu 1'),
                _LegendItem(color: colorSensor2, text: 'Suhu 2'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LegendItem(color: colorKelembaban1, text: 'Kelembaban 1'),
                _LegendItem(color: colorKelembaban2, text: 'Kelembaban 2'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuhuComparisonChart(FermentasiProvider provider) {
    final sensor1Data = _getLatest15Data(provider.chartDataSensor1);
    final sensor2Data = _getLatest15Data(provider.chartDataSensor2);

    final suhu1 = provider.getSuhuValues(sensor1Data);
    final suhu2 = provider.getSuhuValues(sensor2Data);
    final waktu = provider.getWaktuValues(sensor1Data);

    final allValues = [...suhu1, ...suhu2];
    final double minY = _getSafeMin(allValues) - 2;
    final double maxY = _getSafeMax(allValues) + 2;

    return _buildChartContainer(
      'Data Sensor Suhu 1 & 2',
      'Monitoring suhu 15 data terakhir',
      LineChart(
        _mainChartData(
          minY: minY < 0 ? 0 : minY,
          maxY: maxY,
          waktu: waktu,
          lineBarsData: [
            _buildLineBarData(suhu1, colorSensor1, true),
            _buildLineBarData(suhu2, colorSensor2, true),
          ],
          leftTitleSuffix: '°C',
        ),
      ),
      [
        _LegendItem(color: colorSensor1, text: 'Sensor 1'),
        _LegendItem(color: colorSensor2, text: 'Sensor 2'),
      ],
    );
  }

  Widget _buildKelembabanComparisonChart(FermentasiProvider provider) {
    final sensor1Data = _getLatest15Data(provider.chartDataSensor1);
    final sensor2Data = _getLatest15Data(provider.chartDataSensor2);

    final kel1 = provider.getKelembabanValues(sensor1Data);
    final kel2 = provider.getKelembabanValues(sensor2Data);
    final waktu = provider.getWaktuValues(sensor1Data);

    return _buildChartContainer(
      'Data Sensor Kelembaban 1 & 2',
      'Monitoring kelembaban 15 data terakhir',
      LineChart(
        _mainChartData(
          minY: 0,
          maxY: 100,
          waktu: waktu,
          lineBarsData: [
            _buildLineBarData(kel1, colorKelembaban1, true),
            _buildLineBarData(kel2, colorKelembaban2, true),
          ],
          leftTitleSuffix: '%',
          intervalY: 20,
        ),
      ),
      [
        _LegendItem(color: colorKelembaban1, text: 'Sensor 1'),
        _LegendItem(color: colorKelembaban2, text: 'Sensor 2'),
      ],
    );
  }

  Widget _buildStdDevSuhuChart(FermentasiProvider provider) {
    var list1 = provider.stddevSuhu1.map((e) => e.value).toList();
    var list2 = provider.stddevSuhu2.map((e) => e.value).toList();

    if (list1.length > 15) list1 = list1.sublist(list1.length - 15);
    if (list2.length > 15) list2 = list2.sublist(list2.length - 15);

    list1 = list1.reversed.toList();
    list2 = list2.reversed.toList();

    final List<String> waktu = List.generate(
      math.max(list1.length, list2.length),
      (index) => (index + 1).toString(),
    );

    final double dataMax = _getSafeMax([...list1, ...list2]);
    final maxY = (dataMax > 1.2 ? dataMax : 1.2) + 0.5;

    final thresholdLine = HorizontalLine(
      y: 1.0,
      color: colorThreshold,
      strokeWidth: 1.5,
      dashArray: [5, 5],
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        style: TextStyle(
          color: colorThreshold,
          fontWeight: FontWeight.bold,
          fontSize: 9,
          fontFamily: 'Poppins',
        ),
        labelResolver: (line) => 'Batas (1.0)',
      ),
    );

    return _buildChartContainer(
      'Standard Deviation Suhu',
      'Variabilitas data suhu (Batas Aman: 1.0)',
      LineChart(
        _mainChartData(
          minY: 0,
          maxY: maxY,
          waktu: waktu,
          lineBarsData: [
            _buildLineBarData(list1, colorSensor1, true),
            _buildLineBarData(list2, colorSensor2, true),
          ],
          leftTitleSuffix: '',
          showDot: true,
          extraHorizontalLines: [thresholdLine],
        ),
      ),
      [
        _LegendItem(color: colorSensor1, text: 'StdDev S1'),
        _LegendItem(color: colorSensor2, text: 'StdDev S2'),
        _LegendItem(color: colorThreshold, text: 'Batas Kestabilan'),
      ],
    );
  }

  Widget _buildStdDevKelembabanChart(FermentasiProvider provider) {
    var list1 = provider.stddevKelembaban1.map((e) => e.value).toList();
    var list2 = provider.stddevKelembaban2.map((e) => e.value).toList();

    if (list1.length > 15) list1 = list1.sublist(list1.length - 15);
    if (list2.length > 15) list2 = list2.sublist(list2.length - 15);

    final List<String> waktu = List.generate(
      math.max(list1.length, list2.length),
      (index) => (index + 1).toString(),
    );

    final double dataMax = _getSafeMax([...list1, ...list2]);
    final maxY = (dataMax > 5.5 ? dataMax : 5.5) + 1.0;

    final thresholdLine = HorizontalLine(
      y: 5.0,
      color: colorThreshold,
      strokeWidth: 1.5,
      dashArray: [5, 5],
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        style: TextStyle(
          color: colorThreshold,
          fontWeight: FontWeight.bold,
          fontSize: 9,
          fontFamily: 'Poppins',
        ),
        labelResolver: (line) => 'Batas (5.0)',
      ),
    );

    return _buildChartContainer(
      'Standard Deviation Kelembaban',
      'Variabilitas data kelembaban (Batas Aman: 5.0)',
      LineChart(
        _mainChartData(
          minY: 0,
          maxY: maxY,
          waktu: waktu,
          lineBarsData: [
            _buildLineBarData(list1, colorKelembaban1, true),
            _buildLineBarData(list2, colorKelembaban2, true),
          ],
          leftTitleSuffix: '',
          showDot: true,
          extraHorizontalLines: [thresholdLine],
        ),
      ),
      [
        _LegendItem(color: colorKelembaban1, text: 'StdDev K1'),
        _LegendItem(color: colorKelembaban2, text: 'StdDev K2'),
        _LegendItem(color: colorThreshold, text: 'Batas Kestabilan'),
      ],
    );
  }

  LineChartData _mainChartData({
    required double minY,
    required double maxY,
    required List<String> waktu,
    required List<LineChartBarData> lineBarsData,
    required String leftTitleSuffix,
    double? intervalY,
    bool showDot = false,
    List<HorizontalLine>? extraHorizontalLines,
  }) {
    return LineChartData(
      extraLinesData: ExtraLinesData(
        horizontalLines: extraHorizontalLines ?? [],
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: intervalY,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
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
            interval: intervalY ?? (maxY - minY) / 4,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              if (value == minY || value == maxY) return const SizedBox();
              return Text(
                '${value.toInt()}$leftTitleSuffix',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                textAlign: TextAlign.left,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
          top: BorderSide.none,
          right: BorderSide.none,
        ),
      ),
      minX: 0,
      maxX: waktu.isNotEmpty ? (waktu.length - 1).toDouble() : 0,
      minY: minY,
      maxY: maxY,
      lineBarsData: lineBarsData,
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.9),
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              String label = '';
              String unit = leftTitleSuffix;
              final color = barSpot.bar.color;

              if (color == colorSensor1) {
                label = 'Sensor 1';
                unit = '°C';
              } else if (color == colorSensor2) {
                label = 'Sensor 2';
                unit = '°C';
              } else if (color == colorKelembaban1) {
                label = 'Kelembaban 1';
                unit = '%';
              } else if (color == colorKelembaban2) {
                label = 'Kelembaban 2';
                unit = '%';
              }

              return LineTooltipItem(
                '$label: ${barSpot.y.toStringAsFixed(2)} $unit',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
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
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: withArea,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
        ),
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

  Widget _buildQuickStatsCard(FermentasiProvider provider) {
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
                '${provider.avgSuhu1.toStringAsFixed(1)}°C',
                'Terbaru: ${provider.latestSuhu1.toStringAsFixed(1)}°C',
                Icons.thermostat,
                colorSensor1,
              ),
              _buildStatItem(
                'Suhu S2',
                '${provider.avgSuhu2.toStringAsFixed(1)}°C',
                'Terbaru: ${provider.latestSuhu2.toStringAsFixed(1)}°C',
                Icons.thermostat,
                colorSensor2,
              ),
              _buildStatItem(
                'Kelembaban S1',
                '${provider.avgKelembaban1.toStringAsFixed(1)}%',
                'Terbaru: ${provider.latestKelembaban1.toStringAsFixed(1)}%',
                Icons.water_drop,
                colorKelembaban1,
              ),
              _buildStatItem(
                'Kelembaban S2',
                '${provider.avgKelembaban2.toStringAsFixed(1)}%',
                'Terbaru: ${provider.latestKelembaban2.toStringAsFixed(1)}%',
                Icons.water_drop,
                colorKelembaban2,
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

  Widget _buildSensorDetailsCard(FermentasiProvider provider) {
    final rawData = provider.allChartData;
    final latestSegment = _getLatest15Data(rawData);
    final listToShow = latestSegment.reversed.take(5).toList();

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
          if (listToShow.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('Belum ada data')),
            )
          else
            Column(
              children: listToShow.map((data) => _buildDataItem(data)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDataItem(Map<String, dynamic> data) {
    final suhu = (data['suhu'] as num?)?.toDouble() ?? 0.0;
    final kelembaban = (data['kelembaban'] as num?)?.toDouble() ?? 0.0;
    final waktu = data['waktu']?.toString() ?? '--:--';

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
            waktu,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const Spacer(),
          Icon(Icons.thermostat, size: 14, color: Colors.red.shade300),
          const SizedBox(width: 4),
          Text(
            '${suhu.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 12),
          Icon(Icons.water_drop, size: 14, color: Colors.blue.shade300),
          const SizedBox(width: 4),
          Text(
            '${kelembaban.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(FermentasiProvider provider) {
    final isActive = provider.statusRuangan == 1;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFFFFA726), const Color(0xFFFF7043)]
              : [Colors.grey.shade400, Colors.grey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isActive ? Colors.orange : Colors.grey).withOpacity(0.4),
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
              Icons.notifications_active,
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
                  isActive ? 'Fermentasi Aktif' : 'Fermentasi Non-Aktif',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Suhu Rata-rata: ${provider.currentSuhu}°C',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  'Kelembaban Rata-rata: ${provider.currentKelembaban}%',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildErrorWidget(FermentasiProvider p) => Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        p.errorMessage,
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