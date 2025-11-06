import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iotmcc_mobile/data/models/riwayat_model.dart';
import 'package:iotmcc_mobile/presentation/providers/riwayat_perebusan_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

class RiwayatPerebusanPage extends StatefulWidget {
  const RiwayatPerebusanPage({super.key});

  @override
  State<RiwayatPerebusanPage> createState() => _RiwayatPerebusanPageState();
}

class _RiwayatPerebusanPageState extends State<RiwayatPerebusanPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Menyimpan state tab

  @override
  void initState() {
    super.initState();
    // Inisialisasi locale untuk formatting tanggal
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Diperlukan untuk AutomaticKeepAliveClientMixin
    final provider = context.watch<RiwayatPerebusanProvider>();
    const themeColor = Color(0xFF34A853);

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

  // Widget untuk memilih tanggal
  Widget _buildDatePicker(
      BuildContext context, RiwayatPerebusanProvider provider, Color themeColor) {
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

  // Widget untuk menampilkan konten (loading, error, atau data)
  Widget _buildContent(
      BuildContext context, RiwayatPerebusanProvider provider, Color themeColor) {
    // Tampilkan loading besar hanya jika data belum ada sama sekali
    if (provider.isLoading && provider.data == null) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ));
    }

    // Tampilkan error jika ada
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

    // Tampilkan jika data kosong
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

    // Tampilkan data jika berhasil dimuat
    // PERBARUI: Dapatkan sensor spesifik
    final suhuSensor = provider.data!.getSensorByFlag('suhu');

    return Column(
      children: [
        // BARU: Tampilkan kartu rata-rata
        if (suhuSensor != null)
          _buildAverageCard(
            suhuSensor.displayName, // Gunakan 'Suhu'
            '${suhuSensor.avg} ${suhuSensor.unit}', // Gunakan 'avg' dan 'unit'
            themeColor,
            Icons.thermostat_outlined,
          ),
        const SizedBox(height: 16),
        // PERBARUI: Kirim data sensor ke tabel
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

    // 2. Tentukan jumlah baris (berdasarkan timeLabel dari sensor pertama)
    final timeLabels = suhuSensor?.timeLabel ?? [];
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
      // Gunakan .numericValues dari model
      final suhu = getValue(suhuSensor?.numericValues, index);

      return DataRow(cells: [
        DataCell(Text(waktu)),
        DataCell(Text(suhu?.toStringAsFixed(1) ?? '-')),
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
          ],
          rows: rows, // Masukkan baris yang sudah dibuat
        ),
      ),
    );
  }
}