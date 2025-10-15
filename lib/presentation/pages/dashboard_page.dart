import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isBlowerOn = true;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF2), // Warna background utama
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildRoomCard(
              title: 'Ruang Perebusan',
              statusColor: Colors.green,
              children: [
                _buildInfoRow('Suhu', '00° C'),
                _buildInfoRow('Timer', '00:00:00'),
              ],
            ),
            const SizedBox(height: 16),
            _buildRoomCard(
              title: 'Ruang Fermentasi',
              statusColor: Colors.amber,
              children: [
                _buildInfoRow('Suhu', '00° C'),
                _buildInfoRow('Kelembapan', '000%'),
              ],
            ),
            const SizedBox(height: 16),
            _buildRoomCard(
              title: 'Ruang Pengeringan',
              statusColor: Colors.red,
              children: [
                _buildInfoRow('Suhu', '00° C'),
                _buildInfoRow('Kelembapan', '000%'),
                _buildBlowerSwitchRow(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Widget untuk header/app bar kustom
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'), // Placeholder gambar profil
        ),
        const Text(
          'Halo Mahayoga Bahtiar 👋',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 28),
          onPressed: () {
            // Aksi ketika ikon notifikasi ditekan
          },
        ),
      ],
    );
  }

  // Widget untuk kartu informasi ruangan (reusable)
  Widget _buildRoomCard({
    required String title,
    required Color statusColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children, // Menampilkan semua baris info yang diberikan
        ],
      ),
    );
  }

  // Widget untuk baris info (Suhu, Timer, Kelembapan)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget khusus untuk baris Blower dengan Switch
  Widget _buildBlowerSwitchRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Blower',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Switch(
            value: isBlowerOn,
            onChanged: (value) {
              setState(() {
                isBlowerOn = value;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
          ),
        ],
      ),
    );
  }

  // Widget untuk Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF34A853),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent, // Transparan agar rounded corner container terlihat
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
