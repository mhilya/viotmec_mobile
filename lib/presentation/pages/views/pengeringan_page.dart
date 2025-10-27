import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iotmcc_mobile/data/models/pengeringan_model.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/pengeringan_provider.dart';
import 'package:provider/provider.dart';

class PengeringanPage extends StatefulWidget {
  const PengeringanPage({super.key});

  @override
  State<PengeringanPage> createState() => _PengeringanPageState();
}

class _PengeringanPageState extends State<PengeringanPage> {
  String? _lastLoadedGudangId;

  List<bool> _blowerStatusList = List.generate(8, (index) => false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final gudangProvider = Provider.of<GudangProvider>(context, listen: false);
    await gudangProvider.loadGudangList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GudangProvider, PengeringanProvider>(
      builder: (context, gudangProvider, pengeringanProvider, child) {
        final data = pengeringanProvider.data;
        final activeId = gudangProvider.activeGudangId;

        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              pengeringanProvider.fetchData(activeId);
            }
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (gudangProvider.activeGudangId == null)
                _buildNoActiveGudangWidget(gudangProvider),

              if (gudangProvider.activeGudangId != null) ...[
                if (pengeringanProvider.isLoading && data == null)
                  _buildLoadingIndicator(),

                if (pengeringanProvider.errorMessage.isNotEmpty && data == null)
                  _buildErrorWidget(pengeringanProvider),

                if (data != null) ...[
                  _buildHeaderCard(data, pengeringanProvider),
                  const SizedBox(height: 20),
                  _buildBlowerControlCard(),
                  const SizedBox(height: 20),
                  _buildTempChartCard(
                    data.suhuData.dataSuhu
                        .map((e) => double.tryParse(e.toString()) ?? 0.0)
                        .toList(),
                    data.suhuData.dataWaktuSuhu
                        .map((e) => e.toString())
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _buildHumidityChartCard(
                    data.suhuData.dataKelembaban
                        .map((e) => double.tryParse(e.toString()) ?? 0.0)
                        .toList(),
                    data.suhuData.dataWaktuKelembaban
                        .map((e) => e.toString())
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCards(data),
                  const SizedBox(height: 20),
                  _buildEventLogCard(
                    data.suhuData.dataSuhu
                        .map((e) => double.tryParse(e.toString()) ?? 0.0)
                        .toList(),
                    data.suhuData.dataKelembaban
                        .map((e) => double.tryParse(e.toString()) ?? 0.0)
                        .toList(),
                    data.suhuData.dataWaktuSuhu
                        .map((e) => e.toString())
                        .toList(),
                    data.suhuData.dataWaktuKelembaban
                        .map((e) => e.toString())
                        .toList(),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoActiveGudangWidget(GudangProvider gudangProvider) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.warehouse_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Tidak Ada Gudang Aktif',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gudangProvider.gudangList.isEmpty
                ? 'Tidak ada gudang tersedia'
                : 'Pilih gudang dari menu dropdown',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data pengeringan...',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(PengeringanProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 40),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat data',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.red.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.red.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _lastLoadedGudangId = null;
                final activeId = Provider.of<GudangProvider>(
                  context,
                  listen: false,
                ).activeGudangId;
                if (activeId != null) {
                  Provider.of<PengeringanProvider>(
                    context,
                    listen: false,
                  ).fetchData(activeId);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(PengeringanData data, PengeringanProvider provider) {
    final isActive = data.blowerData.statusRuangan == 1;
    final statusText = isActive
        ? 'Status Pengeringan Aktif'
        : 'Status Pengeringan Non-Aktif';
    final statusDescription = isActive
        ? 'Proses pengeringan berjalan optimal'
        : 'Ruangan pengeringan sedang tidak aktif';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFF2196F3), const Color(0xFF1976D2)]
              : [Colors.grey, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isActive ? const Color(0xFF2196F3) : Colors.grey)
                .withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? Icons.air_outlined : Icons.power_off,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusIndicator(isActive),
                const SizedBox(height: 6),
                Text(
                  statusDescription,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (provider.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'AKTIF' : 'NON-AKTIF',
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempChartCard(List<double> dataSuhu, List<String> dataWaktu) {
    final spots = _prepareChartSpotsWithTime(dataSuhu, dataWaktu);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Suhu 1 jam Terakhir',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: _calculateInterval(dataSuhu),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _calculateTimeInterval(dataWaktu),
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < dataWaktu.length) {
                          final time = dataWaktu[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _formatTimeForChart(time),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 5,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}°C',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                minX: 0,
                maxX: dataSuhu.isNotEmpty ? (dataSuhu.length - 1).toDouble() : 0,
                minY: dataSuhu.isNotEmpty ? _getMinValue(dataSuhu) - 2 : 40,
                maxY: dataSuhu.isNotEmpty ? _getMaxValue(dataSuhu) + 2 : 60,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF2196F3),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2196F3).withOpacity(0.3),
                          const Color(0xFF2196F3).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityChartCard(
      List<double> dataKelembaban, List<String> dataWaktu) {
    final spots = _prepareChartSpotsWithTime(dataKelembaban, dataWaktu);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Kelembapan 1 Jam Terakhir',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: _calculateInterval(dataKelembaban),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _calculateTimeInterval(dataWaktu),
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < dataWaktu.length) {
                          final time = dataWaktu[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _formatTimeForChart(time),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 10,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                minX: 0,
                maxX: dataKelembaban.isNotEmpty
                    ? (dataKelembaban.length - 1).toDouble()
                    : 0,
                minY: dataKelembaban.isNotEmpty
                    ? _getMinValue(dataKelembaban) - 5
                    : 40,
                maxY: dataKelembaban.isNotEmpty
                    ? _getMaxValue(dataKelembaban) + 5
                    : 70,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.teal,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.withOpacity(0.3),
                          Colors.teal.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlowerControlCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.air,
                  size: 20,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Kontrol Blower',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              int blowerNumber = index + 1;
              bool isBlowerOn = _getBlowerStatus(blowerNumber);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Blower $blowerNumber',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isBlowerOn ? 'MENYALA' : 'MATI',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isBlowerOn
                                  ? const Color(0xFF2196F3)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isBlowerOn,
                      onChanged: (value) {
                        _toggleBlower(blowerNumber, value);
                      },
                      activeColor: const Color(0xFF2196F3),
                      activeTrackColor: const Color(
                        0xFF2196F3,
                      ).withOpacity(0.5),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Blower berfungsi untuk mengatur sirkulasi udara dalam ruang pengeringan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _getBlowerStatus(int blowerNumber) {
    return _blowerStatusList[blowerNumber - 1];
  }

  void _toggleBlower(int blowerNumber, bool value) {
    setState(() {
      _blowerStatusList[blowerNumber - 1] = value;
    });
    print('Blower $blowerNumber (Dummy): ${value ? 'ON' : 'OFF'}');
  }

  Widget _buildInfoCards(PengeringanData data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.thermostat,
                  title: 'Parameter Utama',
                  children: [
                    _infoRow(
                      'Suhu Rata-rata:',
                      '${data.suhuData.dataAvgSuhu}° C',
                    ),
                    _infoRow(
                      'Kelembapan Rata-rata:',
                      '${data.suhuData.dataAvgKelembaban}%',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.power_settings_new,
                  title: 'Status Operasional',
                  children: [
                    _buildOperationalStatus(data.blowerData.statusRuangan),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildInfoCard(
                icon: Icons.thermostat,
                title: 'Parameter Utama',
                children: [
                  _infoRow(
                    'Suhu Rata-rata:',
                    '${data.suhuData.dataAvgSuhu}° C',
                  ),
                  _infoRow(
                    'Kelembapan Rata-rata:',
                    '${data.suhuData.dataAvgKelembaban}%',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.power_settings_new,
                title: 'Status Operasional',
                children: [
                  _buildOperationalStatus(data.blowerData.statusRuangan),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF2196F3)),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildOperationalStatus(int? statusRuangan) {
    final isActive = statusRuangan == 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue : Colors.grey,
            border: Border.all(
              color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
              width: 3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          isActive ? 'AKTIF' : 'NON-AKTIF',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventLogCard(
    List<double> dataSuhu,
    List<double> dataKelembaban,
    List<String> dataWaktuSuhu,
    List<String> dataWaktuKelembaban,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, color: Color(0xFF2196F3)),
              SizedBox(width: 8),
              Text(
                'Data Sensor Terbaru',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildSensorDataItems(
            dataSuhu,
            dataKelembaban,
            dataWaktuSuhu,
            dataWaktuKelembaban,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSensorDataItems(
    List<double> dataSuhu,
    List<double> dataKelembaban,
    List<String> dataWaktuSuhu,
    List<String> dataWaktuKelembaban,
  ) {
    if (dataSuhu.isEmpty && dataKelembaban.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Tidak ada data sensor',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ];
    }

    List<Widget> items = [];
    int itemCount = dataSuhu.length;

    for (int i = 0; i < itemCount && i < 4; i++) {
      final suhu = i < dataSuhu.length ? dataSuhu[i] : 0.0;
      final kelembaban = i < dataKelembaban.length ? dataKelembaban[i] : 0.0;
      final waktuSuhu =
          i < dataWaktuSuhu.length ? dataWaktuSuhu[i] : '--:--:--';
      final waktuKelembaban =
          i < dataWaktuKelembaban.length && dataWaktuKelembaban[i].isNotEmpty
              ? dataWaktuKelembaban[i]
              : waktuSuhu;

      items.add(_sensorDataRow(suhu, kelembaban, waktuSuhu, waktuKelembaban));
      if (i < itemCount - 1 && i < 3) {
        items.add(const SizedBox(height: 8));
      }
    }

    return items;
  }

  Widget _sensorDataRow(
    double suhu,
    double kelembaban,
    String waktuSuhu,
    String waktuKelembaban,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(
                0xFF2196F3,
              ).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sensors,
              color: Color(0xFF2196F3),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suhu: ${suhu.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Kelembaban: ${kelembaban.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      waktuSuhu,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (waktuSuhu != waktuKelembaban) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        waktuKelembaban,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _prepareChartSpotsWithTime(
      List<double> data, List<String> waktu) {
    List<FlSpot> spots = [];
    // Data dari API (dan model) adalah terbaru -> terlama (index 0 adalah terbaru)
    // Grafik harus tertua -> terbaru (kiri ke kanan)
    // Jadi kita balik (reverse) loopnya
    for (int i = data.length - 1; i >= 0; i--) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }
    if (spots.isEmpty) {
      return [FlSpot(0, 0)];
    }
    return spots;
  }

  String _formatTimeForChart(String time) {
    try {
      final parts = time.split(':');
      if (parts.length == 3) {
        return '${parts[0]}:${parts[1]}'; // Format: HH:mm
      }
    } catch (e) {
      print('Error formatting time: $time');
    }
    return time;
  }

  double _calculateInterval(List<double> data) {
    if (data.isEmpty) return 5;
    final min = _getMinValue(data);
    final max = _getMaxValue(data);
    final range = max - min;
    if (range <= 0) return 2;
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    if (range <= 20) return 5;
    return 10;
  }

  double _calculateTimeInterval(List<String> waktu) {
    if (waktu.isEmpty) return 1;
    if (waktu.length <= 6) return 1;
    if (waktu.length <= 12) return 2;
    return (waktu.length / 5).ceilToDouble();
  }

  double _getMinValue(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue(List<double> data) {
    if (data.isEmpty) return 100;
    return data.reduce((a, b) => a > b ? a : b);
  }
}

