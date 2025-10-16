import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/presentation/pages/dashboard_page.dart';
import 'package:iotmcc_mobile/presentation/pages/laporan_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Daftar semua halaman utama yang akan ditampilkan
  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    LaporanPage(),
    // Placeholder untuk Riwayat dan Profil
    Center(child: Text('Halaman Riwayat')), 
    Center(child: Text('Halaman Profil')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan IndexedStack agar state setiap halaman tetap terjaga
      // saat berpindah tab.
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Pindahkan widget BottomNavigationBar ke sini
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}