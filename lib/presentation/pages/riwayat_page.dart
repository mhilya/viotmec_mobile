import 'package:flutter/material.dart';
import 'views/riwayat_perebusan_page.dart';
import 'views/riwayat_fermentasi_page.dart';
import 'views/riwayat_pengeringan_page.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang sedikit abu-abu
      appBar: AppBar(
        title: const Text(
          'Riwayat', // Judul diubah
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1, // Sedikit shadow untuk memisahkan dari konten
        centerTitle: false,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF34A853),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF34A853),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.local_fire_department_outlined, size: 20),
              text: 'Perebusan',
            ),
            Tab(
              icon: Icon(Icons.science_outlined, size: 20),
              text: 'Fermentasi',
            ),
            Tab(
              icon: Icon(Icons.ac_unit_outlined, size: 20),
              text: 'Pengeringan',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        // Menggunakan halaman riwayat yang baru
        children: const [
          RiwayatPerebusanPage(),
          RiwayatFermentasiPage(),
          RiwayatPengeringanPage(),
        ],
      ),
    );
  }
}