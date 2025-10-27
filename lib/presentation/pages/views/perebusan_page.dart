import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:iotmcc_mobile/presentation/providers/perebusan_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/data/models/perebusan_model.dart';

class PerebusanPage extends StatefulWidget {
  const PerebusanPage({super.key});

  @override
  State<PerebusanPage> createState() => _PerebusanPageState();
}

class _PerebusanPageState extends State<PerebusanPage> {
  bool isTimerRunning = false;
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
    return Consumer2<GudangProvider, PerebusanProvider>(
      builder: (context, gudangProvider, perebusanProvider, child) {
        final data = perebusanProvider.data;
        final activeId = gudangProvider.activeGudangId;

        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            perebusanProvider.fetchData(activeId);
          });
        }

        // Ekstraksi data sensor suhu
        final SensorData? suhuSensor = data?.dataSensor
            .where((s) => s.flagSensor.startsWith('suhu'))
            .firstOrNull;

        // Ekstraksi data waktu untuk sensor suhu yang sesuai
        final WaktuSensorData? suhuWaktu = data?.dataWaktuSensor
            .where((w) => w.flagSensor == suhuSensor?.flagSensor)
            .firstOrNull;

        // Siapkan list data untuk dioper ke widget
        final List<double> suhuValues = suhuSensor?.value ?? [];
        final List<String> waktuValues = suhuWaktu?.value ?? [];
        final String avgSuhu = (suhuSensor?.avg ?? 0).toStringAsFixed(1);
        
        // <-- 1. AMBIL DATA AVG PAGI DI SINI
        final String avgSuhuPagi = (suhuSensor?.avgPagi ?? 0).toStringAsFixed(1);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (gudangProvider.activeGudangId == null)
                _buildNoActiveGudangWidget(gudangProvider),
              if (gudangProvider.activeGudangId != null) ...[
                _buildHeaderCard(data, perebusanProvider),
                const SizedBox(height: 20),
                if (perebusanProvider.isLoading && data == null)
                  _buildLoadingIndicator(),
                if (perebusanProvider.errorMessage.isNotEmpty && data == null)
                  _buildErrorWidget(perebusanProvider),
                if (data != null) ...[
                  // Oper data yang sudah diekstrak ke widget
                  _buildChartCard(data, suhuValues, waktuValues),
                  const SizedBox(height: 20),
                  
                  // <-- 2. PASS DATA AVG PAGI KE WIDGET INFO CARD
                  _buildInfoCards(data, avgSuhu, avgSuhuPagi),
                  
                  const SizedBox(height: 20),
                  _buildEventLogCard(data, suhuValues, waktuValues),
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34A853)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data perebusan...',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(PerebusanProvider provider) {
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

  Widget _buildHeaderCard(PerebusanData? data, PerebusanProvider provider) {
    final isActive = data?.statusRuangan == 1;
    final statusText = isActive
        ? 'Status Perebusan Stabil'
        : 'Status Perebusan Non-Aktif';
    final statusDescription = isActive
        ? 'Suhu terkendali dalam range optimal'
        : 'Ruangan perebusan sedang tidak aktif';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFF34A853), const Color(0xFF2E8B46)]
              : [Colors.grey, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isActive ? const Color(0xFF34A853) : Colors.grey)
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
              isActive ? Icons.thermostat_auto_outlined : Icons.power_off,
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
            isActive ? 'STABIL' : 'NON-AKTIF',
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

  // Terima data suhu/waktu yang sudah diekstrak
  Widget _buildChartCard(
    PerebusanData data,
    List<double> suhuData,
    List<String> waktuData,
  ) {
    final spots = _prepareChartSpots(suhuData, waktuData);

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
            'Riwayat Suhu 24 Jam Terakhir', // Diubah dari 30 data
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${suhuData.length} data point', // Menampilkan jumlah data
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
                  horizontalInterval: 10, // Disesuaikan untuk suhu
                  verticalInterval: _calculateTimeInterval(waktuData) /
                      2, // Disesuaikan untuk waktu
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                      dashArray: [4],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                      dashArray: [4],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      // PERBAIKAN: Gunakan interval dinamis untuk waktu
                      interval: _calculateTimeInterval(waktuData),
                      getTitlesWidget: (value, meta) {
                        // PERBAIKAN: Tampilkan Waktu (HH:mm)
                        if (value >= 0 && value < waktuData.length) {
                          final time = waktuData[value.toInt()];
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
                      // Disesuaikan untuk range suhu perebusan
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}°C',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      },
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
                // Gunakan parameter suhuData
                maxX: suhuData.isNotEmpty
                    ? (suhuData.length - 1).toDouble()
                    : 0,
                // Sesuaikan Min/Max Y untuk perebusan (misal 0 - 110)
                minY: 0,
                maxY: 110,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF34A853),
                    barWidth: 3, // Dibuat lebih tipis
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF34A853).withOpacity(0.3),
                          const Color(0xFF34A853).withOpacity(0.0),
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

  List<FlSpot> _prepareChartSpots(
    List<double> suhuData,
    List<String> waktuData,
  ) {
    List<FlSpot> spots = [];
    for (int i = 0; i < suhuData.length; i++) {
      spots.add(FlSpot(i.toDouble(), suhuData[i]));
    }
    return spots;
  }

  double _getMinValue(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue(List<double> data) {
    if (data.isEmpty) return 100;
    return data.reduce((a, b) => a > b ? a : b);
  }

  // <-- 3. UPDATE SIGNATURE UNTUK MENERIMA avgSuhuPagi
  Widget _buildInfoCards(
      PerebusanData data, String avgSuhu, String avgSuhuPagi) {
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
                    // Gunakan parameter avgSuhu
                    // _infoRow('Suhu Rata-rata (24j):', '$avgSuhu° C'),
                    
                    // <-- 4. TAMPILKAN DATA BARU DI SINI
                    _infoRow('Suhu Rata-rata:', '$avgSuhuPagi° C'),
                    
                    _infoRow('Timer:', '00:00:00'),
                  ],
                  actionButton: _buildTimerControls(data),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.power_settings_new,
                  title: 'Status Operasional',
                  children: [_buildOperationalStatus(data.statusRuangan)],
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
                  // Gunakan parameter avgSuhu
                  _infoRow('Suhu Rata-rata (24j):', '$avgSuhu° C'),
                  
                  // <-- 5. TAMPILKAN DATA BARU DI SINI JUGA (untuk layout mobile)
                  _infoRow('Rata-rata Pagi (7-10):', '$avgSuhuPagi° C'),

                  _infoRow('Timer:', '00:00:00'),
                ],
                actionButton: _buildTimerControls(data),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.power_settings_new,
                title: 'Status Operasional',
                children: [_buildOperationalStatus(data.statusRuangan)],
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
    Widget? actionButton,
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
                  color: const Color(0xFF34A853).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF34A853)),
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
          if (actionButton != null) ...[
            const SizedBox(height: 16),
            actionButton,
          ],
        ],
      ),
    );
  }

  Widget _buildTimerControls(PerebusanData data) {
    return isTimerRunning
        ? OutlinedButton.icon(
            icon: const Icon(Icons.stop_rounded),
            label: const Text('Hentikan Timer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade300, width: 1.5),
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              setState(() {
                isTimerRunning = false;
              });
              // TODO: Tambahkan logika untuk MENGHENTIKAN timer
            },
          )
        : ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Mulai Timer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34A853),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: data.statusRuangan == 1
                ? () {
                    setState(() {
                      isTimerRunning = true;
                    });
                    // TODO: Tambahkan logika untuk MEMULAI timer
                  }
                : null,
          );
  }

  Widget _buildOperationalStatus(int statusRuangan) {
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
              color: Color(0xFF34A853),
            ),
          ),
        ],
      ),
    );
  }

  // Terima data suhu/waktu yang sudah diekstrak
  Widget _buildEventLogCard(
    PerebusanData data,
    List<double> suhuData,
    List<String> waktuData,
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
              Icon(Icons.history, color: Color(0xFF34A853)),
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
          // Oper data yang sudah diekstrak
          ..._buildSensorDataItems(data, suhuData, waktuData),
        ],
      ),
    );
  }

  // Terima data suhu/waktu yang sudah diekstrak
  List<Widget> _buildSensorDataItems(
    PerebusanData data,
    List<double> suhuData,
    List<String> waktuData,
  ) {
    // Cek list yang baru
    if (suhuData.isEmpty) {
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
    // Gunakan list yang baru
    int itemCount = suhuData.length;

    // Tampilkan 4 data terbaru
    for (int i = 0; i < itemCount && i < 4; i++) {
      final suhu = i < suhuData.length ? suhuData[i] : 0.0;
      final waktu = i < waktuData.length ? waktuData[i] : '--:--:--';

      items.add(_sensorDataRow(suhu, waktu));
      if (i < itemCount - 1 && i < 3) {
        items.add(const SizedBox(height: 8));
      }
    }

    return items;
  }

  // Widget ini sekarang hanya menerima suhu dan waktu
  Widget _sensorDataRow(double suhu, String waktu) {
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
              color: const Color(0xFF34A853).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sensors,
              color: Color(0xFF34A853),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row di sini tidak lagi memerlukan spaceBetween
                Row(
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
                      waktu,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Methods untuk Grafik ---

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

  double _calculateTimeInterval(List<String> waktu) {
    // Menghitung interval agar tidak terlalu padat
    if (waktu.length <= 6) return 1; // Tampilkan setiap data
    if (waktu.length <= 12) return 2; // Tampilkan setiap 2 data
    if (waktu.length <= 60) return 10; // Tampilkan setiap 10 data (jika 1 jam)
    // Untuk 288 data (24 jam)
    if (waktu.length <= 288) return 48; // Tampilkan sekitar 6 label (288 / 6)
    return (waktu.length / 6).ceilToDouble(); // Default: 6 label
  }
}
