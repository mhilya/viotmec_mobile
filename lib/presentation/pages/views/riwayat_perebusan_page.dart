import 'package:flutter/material.dart';

class RiwayatPerebusanPage extends StatefulWidget {
  const RiwayatPerebusanPage({super.key});

  @override
  State<RiwayatPerebusanPage> createState() => _RiwayatPerebusanPageState();
}

class _RiwayatPerebusanPageState extends State<RiwayatPerebusanPage> {
  int _selectedYear = DateTime.now().year;

  // Daftar bulan untuk ditampilkan
  final List<String> months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  void _changeYear(int amount) {
    setState(() {
      _selectedYear += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        _buildYearSelector(),
        const SizedBox(height: 20),
        ...months.map((month) => _buildMonthlyHistoryCard(month, _selectedYear)).toList(),
      ],
    );
  }

  // Widget untuk filter tahun
  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black54),
            onPressed: () => _changeYear(-1),
          ),
          Text(
            'Tahun $_selectedYear',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.black54),
            onPressed: () => _changeYear(1),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan riwayat bulanan (dropdown)
  Widget _buildMonthlyHistoryCard(String month, int year) {
    const themeColor = Color(0xFF34A853);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        iconColor: themeColor,
        collapsedIconColor: Colors.grey.shade600,
        title: Text(
          '$month $year',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          ...List.generate(4, (index) {
            final week = index + 1;
            return ListTile(
              title: Text('Laporan Minggu ke-$week'),
              subtitle: Text('Lihat detail laporan mingguan'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                // Aksi ketika minggu dipilih, contoh: navigasi atau tampilkan dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Membuka laporan perebusan minggu ke-$week, bulan $month')),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}