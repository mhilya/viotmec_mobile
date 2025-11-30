import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:viotmec_mobile/presentation/providers/riwayat_provider.dart';
import 'package:viotmec_mobile/data/models/riwayat_model.dart';
import 'dart:math' as math;

class RiwayatPengeringanPage extends StatefulWidget {
  const RiwayatPengeringanPage({super.key});

  @override
  State<RiwayatPengeringanPage> createState() => _RiwayatPengeringanPageState();
}

class _RiwayatPengeringanPageState extends State<RiwayatPengeringanPage> {
  int _currentChartIndex = 0;
  final List<String> _chartTitles = ['Grafik Suhu', 'Grafik Kelembaban'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RiwayatProvider>(context, listen: false);
      provider.resetState();
      provider.getGudangList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final provider = Provider.of<RiwayatProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF34A853),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != provider.selectedDate) {
      provider.setSelectedDate(picked);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<RiwayatProvider>(
      builder: (context, provider, child) {
        final data = provider.riwayatData;

        return RefreshIndicator(
          onRefresh: () async {
            if (provider.selectedGudangId != null) {
              await provider.getRiwayatByGudangAndType(3);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterCard(context, provider),
                const SizedBox(height: 16),
                if (provider.isLoading)
                  const Center(
                      child: CircularProgressIndicator(color: Color(0xFF34A853)))
                else if (provider.errorMessage != null)
                  _buildErrorState(provider.errorMessage!)
                else if (data != null && data.hasData) ...[
                  _buildChartNavigation(),
                  const SizedBox(height: 16),
                  _buildCurrentChart(data),
                  const SizedBox(height: 16),
                  _buildStatsCard(data),
                  const SizedBox(height: 16),
                  _buildDetailsList(data),
                ] else if (data != null && !data.hasData)
                  const Center(child: Text("Tidak ada data pada tanggal ini"))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterCard(BuildContext context, RiwayatProvider provider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Data (Pengeringan)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: provider.selectedGudangId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Pilih Gudang',
                labelStyle: TextStyle(
                    fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items:
                  provider.listGudang.map<DropdownMenuItem<String>>((gudang) {
                return DropdownMenuItem<String>(
                  value: gudang['id_gudang'].toString(),
                  child: Text(
                    gudang['nama_gudang'],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                provider.setSelectedGudangId(val);
              },
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  labelStyle: TextStyle(
                      fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Color(0xFF34A853)),
                ),
                child: Text(
                  DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(provider.selectedDate),
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.selectedGudangId == null
                    ? null
                    : () {
                        provider.getRiwayatByGudangAndType(3); // 3
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Tampilkan Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartNavigation() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousChart,
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          Text(
            _chartTitles[_currentChartIndex],
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          IconButton(
            onPressed: _nextChart,
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentChart(RiwayatData data) {
    if (_currentChartIndex == 0) {
      final sensors = data.dataSensor
          .where((s) => s.flagSensor.toLowerCase().contains('suhu'))
          .toList();
      if (sensors.isEmpty) return const Center(child: Text("Data Suhu Kosong"));
      return _buildGenericChart(
          "Grafik Suhu", sensors, const Color(0xFFFF6B6B), '°C');
    } else {
      final sensors = data.dataSensor
          .where((s) => s.flagSensor.toLowerCase().contains('kelembaban'))
          .toList();
      if (sensors.isEmpty) return const Center(child: Text("Data Kelembaban Kosong"));
      return _buildGenericChart(
          "Grafik Kelembaban", sensors, const Color(0xFF45B7D1), '%');
    }
  }

  Widget _buildGenericChart(String title, List<RiwayatSensorData> sensors,
      Color baseColor, String unit) {
    if (sensors.isEmpty) return const SizedBox();

    final List<String> waktu = sensors.first.timeLabel;
    
    List<double> allValues = [];
    for (var s in sensors) {
      allValues.addAll(s.numericValues);
    }

    double minY = 0;
    double maxY = 100;
    
    if (allValues.isNotEmpty) {
      minY = allValues.reduce(math.min) - 5;
      maxY = allValues.reduce(math.max) + 5;
      if (minY < 0) minY = 0;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (waktu.length / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < waktu.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              waktu[index],
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 10),
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
                      reservedSize: 40,
                      interval: (maxY - minY) / 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}$unit',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (waktu.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: sensors.asMap().entries.map((entry) {
                  final index = entry.key;
                  final sensor = entry.value;
                  final color = index == 0 ? baseColor : const Color(0xFFFFA07A); 
                  
                  return LineChartBarData(
                    spots: sensor.numericValues.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.1),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: sensors.asMap().entries.map((entry) {
               final index = entry.key;
               final s = entry.value;
               final color = index == 0 ? baseColor : const Color(0xFFFFA07A);
               return Chip(
                label: Text(s.displayName, style: const TextStyle(fontSize: 10)),
                backgroundColor: color.withOpacity(0.1),
                side: BorderSide.none,
              );
            }).toList(),
          )
        ],
      ),
    );
  }

Widget _buildStatsCard(RiwayatData data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: data.dataSensor.length,
      itemBuilder: (context, index) {
        final sensor = data.dataSensor[index];
        final isSuhu = sensor.flagSensor.toLowerCase().contains('suhu');
        final color = isSuhu ? const Color(0xFFFF6B6B) : const Color(0xFF45B7D1);
        final icon = isSuhu ? Icons.thermostat : Icons.water_drop;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sensor.displayName,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade600, fontFamily: 'Poppins'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Avg: ${sensor.avg} ${sensor.unit}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: color, fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsList(RiwayatData data) {
    if (data.dataSensor.isEmpty) return const SizedBox();
    final refSensor = data.dataSensor.first;
    final int dataCount = refSensor.value.length;

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
            'Log Data Lengkap',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          if (dataCount == 0)
            const Center(child: Text("Belum ada data detail."))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataCount,
              itemBuilder: (context, index) {
                final realIndex = dataCount - 1 - index;
                final time = refSensor.timeLabel[realIndex];

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Wrap(
                          alignment:
                              WrapAlignment.end, 
                          spacing: 12,
                          runSpacing:
                              4,
                          children: data.dataSensor.map((sensor) {
                            final val = sensor.value[realIndex];
                            final isSuhu = sensor.flagSensor
                                .toLowerCase()
                                .contains('suhu');

                            final icon = isSuhu
                                ? Icons.thermostat
                                : Icons.water_drop;
                            final color = isSuhu
                                ? Colors.red.shade300
                                : Colors.blue.shade300;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, size: 14, color: color),
                                const SizedBox(width: 4),
                                Text(
                                  '$val${sensor.unit}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}