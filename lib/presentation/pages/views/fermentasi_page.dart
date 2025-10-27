import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:iotmcc_mobile/presentation/providers/fermentasi_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/data/models/fermentasi_model.dart';

class FermentasiPage extends StatefulWidget {
  const FermentasiPage({super.key});

  @override
  State<FermentasiPage> createState() => _FermentasiPageState();
}

class _FermentasiPageState extends State<FermentasiPage> {
  String? _lastLoadedGudangId;

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
    return Consumer2<GudangProvider, FermentasiProvider>(
      builder: (context, gudangProvider, fermentasiProvider, child) {
        final data = fermentasiProvider.data;
        final activeId = gudangProvider.activeGudangId;

        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            fermentasiProvider.fetchData(activeId);
          });
        }

        // GUNAKAN DATA 1 JAM UNTUK GRAFIK
        final dataSuhu1Jam = fermentasiProvider.dataSuhu1Jam;
        final dataKelembaban1Jam = fermentasiProvider.dataKelembaban1Jam;
        final dataWaktu1Jam = fermentasiProvider.dataWaktu1Jam;

        // RATA-RATA MASIH PAKAI YANG GLOBAL
        final dataAvgSuhu = fermentasiProvider.dataAvgSuhu;
        final dataAvgKelembaban = fermentasiProvider.dataAvgKelembaban;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (gudangProvider.activeGudangId == null)
                _buildNoActiveGudangWidget(gudangProvider),
              if (gudangProvider.activeGudangId != null) ...[
                _buildHeaderCard(data, fermentasiProvider),
                const SizedBox(height: 20),
                if (fermentasiProvider.isLoading && data == null)
                  _buildLoadingIndicator(),
                if (fermentasiProvider.errorMessage.isNotEmpty && data == null)
                  _buildErrorWidget(fermentasiProvider),
                if (data != null) ...[
                  // GRAFIK SUHU 1 JAM
                  _buildTempChartCard(dataSuhu1Jam, dataWaktu1Jam),
                  const SizedBox(height: 20),

                  // GRAFIK KELEMBABAN 1 JAM
                  _buildHumidityChartCard(dataKelembaban1Jam, dataWaktu1Jam),
                  const SizedBox(height: 20),

                  // CARD INFO RATA-RATA - SUDAH BENAR
                  _buildInfoCards(
                    data.statusRuangan,
                    dataAvgSuhu,
                    dataAvgKelembaban,
                  ),
                  const SizedBox(height: 20),

                  // EVENT LOG DENGAN DATA ASLI (BUKAN 1 JAM)
                  _buildEventLogCard(
                    fermentasiProvider.dataSuhu,
                    fermentasiProvider.dataKelembaban,
                    fermentasiProvider.dataWaktuSuhu,
                    fermentasiProvider.dataWaktuKelembaban,
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  // WIDGET GRAFIK SUHU 1 JAM
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
            'Riwayat Suhu 1 Jam Terakhir',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${dataSuhu.length} data point',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
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
                      interval: 2,
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
                minY: dataSuhu.isNotEmpty ? _getMinValue(dataSuhu) - 1 : 0,
                maxY: dataSuhu.isNotEmpty ? _getMaxValue(dataSuhu) + 1 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFFFFC107),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFC107).withOpacity(0.3),
                          const Color(0xFFFFC107).withOpacity(0.0),
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

  // WIDGET GRAFIK KELEMBABAN 1 JAM
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
            'Riwayat Kelembaban 1 Jam Terakhir',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${dataKelembaban.length} data point',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
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
                      interval: 5,
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
                    ? _getMinValue(dataKelembaban) - 2
                    : 0,
                maxY: dataKelembaban.isNotEmpty
                    ? _getMaxValue(dataKelembaban) + 2
                    : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.3),
                          Colors.blueAccent.withOpacity(0.0),
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

  // METHOD BARU UNTUK GRAFIK DENGAN WAKTU
  List<FlSpot> _prepareChartSpotsWithTime(
      List<double> data, List<String> waktu) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
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
    final range = _getMaxValue(data) - _getMinValue(data);
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    return 5;
  }

  double _calculateTimeInterval(List<String> waktu) {
    if (waktu.length <= 6) return 1;
    if (waktu.length <= 12) return 2;
    return (waktu.length / 6).ceilToDouble();
  }

  // METHOD YANG SUDAH ADA (TIDAK BERUBAH)
  double _getMinValue(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue(List<double> data) {
    if (data.isEmpty) return 100;
    return data.reduce((a, b) => a > b ? a : b);
  }

  // WIDGET-WIDGET LAINNYA TIDAK BERUBAH
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data fermentasi...',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(FermentasiProvider provider) {
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
                _lastLoadedGudangId = null; // Paksa refresh
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

  Widget _buildHeaderCard(FermentasiData? data, FermentasiProvider provider) {
    // Gunakan data?.statusRuangan, default ke non-aktif (0) jika data null
    final isActive = data?.statusRuangan == 1;
    final statusText =
        isActive ? 'Status Fermentasi Optimal' : 'Status Fermentasi Non-Aktif';
    final statusDescription = isActive
        ? 'Proses fermentasi berjalan sesuai tahapan'
        : 'Ruangan fermentasi sedang tidak aktif';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFFFFC107), const Color(0xFFFFA000)]
              : [Colors.grey, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isActive ? const Color(0xFFFFC107) : Colors.grey)
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
              isActive ? Icons.science_outlined : Icons.power_off,
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
          // Tampilkan loading spinner kecil jika sedang refresh data
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
            isActive ? 'OPTIMAL' : 'NON-AKTIF',
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

  Widget _buildInfoCards(
    int? statusRuangan,
    String dataAvgSuhu,
    String dataAvgKelembaban,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.thermostat,
                  title: 'Parameter Utama',
                  children: [
                    _infoRow('Suhu Rata-rata:', '$dataAvgSuhu° C'),
                    _infoRow('Kelembaban Rata-rata:', '$dataAvgKelembaban%'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.power_settings_new,
                  title: 'Status Operasional',
                  children: [
                    _buildOperationalStatus(statusRuangan),
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
                  _infoRow('Suhu Rata-rata:', '$dataAvgSuhu° C'),
                  _infoRow('Kelembaban Rata-rata:', '$dataAvgKelembaban%'),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.power_settings_new,
                title: 'Status Operasional',
                children: [
                  _buildOperationalStatus(statusRuangan),
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
                  color: const Color(0xFFFFC107).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFFFFC107)),
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
            color: isActive ? Colors.green : Colors.grey,
            border: Border.all(
                color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
                width: 3),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          isActive ? 'AKTIF' : 'NON-AKTIF',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.green : Colors.grey,
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
              color: Color(0xFFFFC107),
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
              Icon(Icons.history, color: Color(0xFFFFC107)),
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
          child: Text(
            'Tidak ada data sensor',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ];
    }

    List<Widget> items = [];
    // Tampilkan data berdasarkan jumlah data suhu (asumsi suhu dan kelembaban punya jumlah data yang sama)
    int itemCount = dataSuhu.length;

    // Tampilkan maksimal 4 data terbaru
    for (int i = 0; i < itemCount && i < 4; i++) {
      final suhu = i < dataSuhu.length ? dataSuhu[i] : 0.0;
      final kelembaban =
          i < dataKelembaban.length ? dataKelembaban[i] : 0.0;
      final waktuSuhu =
          i < dataWaktuSuhu.length ? dataWaktuSuhu[i] : '--:--:--';
      final waktuKelembaban = i < dataWaktuKelembaban.length
          ? dataWaktuKelembaban[i]
          : '--:--:--';

      items.add(_sensorDataRow(suhu, kelembaban, waktuSuhu, waktuKelembaban));
      if (i < itemCount - 1 && i < 3) {
        items.add(const SizedBox(height: 8));
      }
    }

    return items;
  }

  Widget _sensorDataRow(
      double suhu, double kelembaban, String waktuSuhu, String waktuKelembaban) {
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
              color: const Color(0xFFFFC107).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sensors,
              color: Color(0xFFFFC107),
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
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      waktuSuhu, // Asumsi waktu suhu dan kelembaban sama
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Hapus duplikasi waktu jika sama
                    if (waktuSuhu != waktuKelembaban) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey.shade600),
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
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
