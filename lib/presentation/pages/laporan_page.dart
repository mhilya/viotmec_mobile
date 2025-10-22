import 'package:flutter/material.dart';
import 'views/perebusan_page.dart';
import 'views/fermentasi_page.dart';
import 'views/pengeringan_page.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Gudang',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
              text: 'Bleaching',
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
        children: const [
          PerebusanPage(),
          FermentasiPage(),
          PengeringanPage(),
        ],
      ),
    );
  }
}