import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viotmec_mobile/data/models/riwayat_model.dart';
import 'package:viotmec_mobile/presentation/providers/riwayat_pengeringan_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

class RiwayatPengeringanPage extends StatefulWidget {
  const RiwayatPengeringanPage({super.key});

  @override
  State<RiwayatPengeringanPage> createState() => _RiwayatPengeringanPageState();
}

class _RiwayatPengeringanPageState extends State<RiwayatPengeringanPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<RiwayatPengeringanProvider>();
    const themeColor = Color(0xFF2196F3); // Warna tema Pengeringan

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDatePicker(context, provider, themeColor),
          const SizedBox(height: 20),
          _buildContent(context, provider, themeColor),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
      BuildContext context, RiwayatPengeringanProvider provider, Color themeColor) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: provider.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: themeColor,
                    ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null && pickedDate != provider.selectedDate) {
          provider.setSelectedDate(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.calendar_today_outlined, color: themeColor, size: 20),
            Text(
              DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                  .format(provider.selectedDate),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, RiwayatPengeringanProvider provider, Color themeColor) {
    if (provider.isLoading && provider.data == null) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ));
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchData(),
              child: const Text('Coba Lagi'),
            )
          ],
        ),
      );
    }

    if (provider.data == null || !provider.data!.hasData) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, color: Colors.grey, size: 48),
            SizedBox(height: 16),
            Text(
              'Tidak ada data pada tanggal ini',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // PERBARUI: Dapatkan sensor spesifik
    final suhuSensor = provider.data!.getSensorByFlag('suhu');
    final lembabSensor = provider.data!.getSensorByFlag('kelembaban');

    return Column(
      children: [
        // BARU: Tampilkan kartu rata-rata
        if (suhuSensor != null)
          _buildAverageCard(
            suhuSensor.displayName,
            '${suhuSensor.avg} ${suhuSensor.unit}',
            themeColor,
            Icons.thermostat_outlined,
          ),
        if (lembabSensor != null) ...[
          const SizedBox(height: 8),
          _buildAverageCard(
            lembabSensor.displayName,
            '${lembabSensor.avg} ${lembabSensor.unit}',
            themeColor,
            Icons.water_drop_outlined,
          ),
        ],
        const SizedBox(height: 16),
        _buildDataTable(provider.data!, themeColor),
      ],
    );
  }

  // BARU: Widget untuk menampilkan kartu rata-rata
  Widget _buildAverageCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      color: color.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tabel data (DIPERBARUI TOTAL)
  Widget _buildDataTable(RiwayatData data, Color themeColor) {
    // 1. Dapatkan data sensor
    final suhuSensor = data.getSensorByFlag('suhu');
    final lembabSensor = data.getSensorByFlag('kelembaban');

    // 2. Tentukan jumlah baris (berdasarkan timeLabel dari sensor pertama)
    final timeLabels =
        suhuSensor?.timeLabel ?? lembabSensor?.timeLabel ?? [];
    final int rowCount = timeLabels.length;

    if (rowCount == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Data sensor ada, namun tidak ada catatan waktu.'),
        ),
      );
    }

    // 3. Helper untuk mendapatkan nilai dengan aman
    dynamic getValue(List<double>? values, int index) {
      if (values != null && index >= 0 && index < values.length) {
        return values[index];
      }
      return null;
    }

    // 4. Buat baris data
    final rows = List.generate(rowCount, (index) {
      final waktu = timeLabels[index];
      final suhu = getValue(suhuSensor?.numericValues, index);
      final kelembaban = getValue(lembabSensor?.numericValues, index);

      return DataRow(cells: [
        DataCell(Text(waktu)),
        DataCell(Text(suhu?.toStringAsFixed(1) ?? '-')),
        DataCell(Text(kelembaban?.toStringAsFixed(1) ?? '-')),
      ]);
    });

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              WidgetStateProperty.all(themeColor.withOpacity(0.1)),
          columns: const [
            DataColumn(
              label: Text(
                'Waktu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Suhu (°C)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Lembab (%)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
          rows: rows,
        ),
      ),
    );
  }
}