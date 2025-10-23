import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iotmcc_mobile/presentation/providers/user_provider.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   bool isBlowerOn = true;
//   bool isTimerRunning = false;

//   @override
//   void initState() {
//     super.initState();
//     // Load user data ketika halaman dibuka
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.getUserProfile();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);

//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(20.0),
//           children: [
//             _buildHeader(userProvider),
//             const SizedBox(height: 24),
//             _buildRoomCard(
//               title: 'Ruang Perebusan',
//               statusColor: const Color(0xFF34A853),
//               icon: Icons.local_fire_department_outlined,
//               children: [
//                 _buildInfoRow('Suhu', '95° C'),
//                 _buildInfoRow('Timer', '02:30:15'),
//                 _buildTimerControls(),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildRoomCard(
//               title: 'Ruang Fermentasi',
//               statusColor: const Color(0xFFFFC107),
//               icon: Icons.science_outlined,
//               children: [
//                 _buildInfoRow('Suhu', '32° C'),
//                 _buildInfoRow('Kelembapan', '85%'),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildRoomCard(
//               title: 'Ruang Pengeringan',
//               statusColor: const Color(0xFF2196F3),
//               icon: Icons.air_outlined,
//               children: [
//                 _buildInfoRow('Suhu', '45° C'),
//                 _buildInfoRow('Kelembapan', '55%'),
//                 _buildBlowerSwitchRow(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(UserProvider userProvider) {
//     return Row(
//       children: [
//         const CircleAvatar(
//           radius: 26,
//           backgroundImage: AssetImage('assets/images/icon.jpg'),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Halo, ${userProvider.user?.name ?? 'Loading...'}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 2),
//               const Text(
//                 'Selamat Datang Kembali!',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.grey.shade200, width: 1.5),
//           ),
//           child: IconButton(
//             icon: const Icon(
//               Icons.notifications_none_outlined,
//               size: 24,
//               color: Colors.black54,
//             ),
//             onPressed: () {},
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRoomCard({
//     required String title,
//     required Color statusColor,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardTheme.color,
//         borderRadius: BorderRadius.circular(20.0),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: statusColor, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 width: 12,
//                 height: 12,
//                 decoration: BoxDecoration(
//                   color: statusColor,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ],
//           ),
//           const Divider(height: 28, thickness: 1, color: Color(0xFFF0F0F0)),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBlowerSwitchRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Blower',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           Switch(
//             value: isBlowerOn,
//             onChanged: (value) {
//               setState(() {
//                 isBlowerOn = value;
//               });
//             },
//             activeColor: Theme.of(context).colorScheme.primary,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimerControls() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12.0),
//       child: isTimerRunning
//           ? OutlinedButton.icon(
//               icon: const Icon(Icons.stop_rounded),
//               label: const Text('Hentikan Timer'),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: Colors.red.shade700,
//                 side: BorderSide(color: Colors.red.shade300, width: 1.5),
//                 minimumSize: const Size(double.infinity, 42),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 setState(() {
//                   isTimerRunning = false;
//                 });
//                 // TODO: Tambahkan logika untuk MENGHENTIKAN timer
//               },
//             )
//           : ElevatedButton.icon(
//               icon: const Icon(Icons.play_arrow_rounded),
//               label: const Text('Mulai Timer'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 42),
//                 // Menggunakan style dari theme, tidak perlu kustomisasi berlebih
//               ),
//               onPressed: () {
//                 setState(() {
//                   isTimerRunning = true;
//                 });
//                 // TODO: Tambahkan logika untuk MEMULAI timer
//               },
//             ),
//     );
//   }
// }

import 'package:iotmcc_mobile/presentation/providers/fermentasi_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/pengeringan_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/perebusan_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:iotmcc_mobile/presentation/providers/user_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Variabel lokal untuk timer, karena provider belum menanganinya
  bool isTimerRunning = false;

  // Variabel untuk melacak ID gudang yang terakhir diambil datanya
  // Ini penting untuk mencegah fetch berulang kali saat build
  String? _lastFetchedGudangId;

  @override
  void initState() {
    super.initState();
    // Load data awal saat halaman pertama kali dibuka
    // (setelah frame pertama selesai di-render)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  /// Memuat data yang tidak bergantung pada gudang (User)
  /// dan data gudang itu sendiri (GudangProvider).
  Future<void> _loadInitialData() async {
    // Gunakan context.read di dalam initState/metode helper
    final userProvider = context.read<UserProvider>();
    final gudangProvider = context.read<GudangProvider>();

    // Ambil profil user dan daftar gudang secara bersamaan
    await Future.wait([
      userProvider.getUserProfile(),
      gudangProvider.loadGudangList(),
    ]);
    // Setelah ini, GudangProvider akan memiliki activeGudangId
    // yang akan memicu pengambilan data ruangan di metode build.
  }

  /// Mengambil data untuk semua ruangan berdasarkan gudangId yang aktif.
  /// Dipanggil dari metode build() ketika activeGudangId berubah.
  void _fetchRoomData(String activeGudangId) {
    // Gunakan context.read untuk memanggil fungsi
    final perebusanProvider = context.read<PerebusanProvider>();
    final fermentasiProvider = context.read<FermentasiProvider>();
    final pengeringanProvider = context.read<PengeringanProvider>();

    // Ambil data untuk semua ruangan secara paralel
    Future.wait([
      perebusanProvider.fetchData(activeGudangId),
      fermentasiProvider.fetchData(activeGudangId),
      pengeringanProvider.fetchData(activeGudangId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan context.watch untuk mendengarkan perubahan state
    final userProvider = context.watch<UserProvider>();
    final gudangProvider = context.watch<GudangProvider>();
    final perebusanProvider = context.watch<PerebusanProvider>();
    final fermentasiProvider = context.watch<FermentasiProvider>();
    final pengeringanProvider = context.watch<PengeringanProvider>();

    // LOGIKA INTI:
    // Dapatkan ID gudang yang aktif saat ini dari GudangProvider
    final activeGudangId = gudangProvider.activeGudangId;

    // Jika gudangId aktif berubah (atau baru saja dimuat),
    // ambil data baru untuk semua ruangan.
    if (activeGudangId != null && activeGudangId != _lastFetchedGudangId) {
      _lastFetchedGudangId = activeGudangId;
      // Kita panggil ini di post-frame callback agar tidak menyebabkan
      // error "setState/notifyListeners during build"
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _fetchRoomData(activeGudangId));
    }

    // Tampilkan loading spinner utama jika daftar gudang sedang dimuat
    // (karena semua data lain bergantung padanya)
    if (gudangProvider.isLoading && !gudangProvider.hasActiveGudang) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Tampilan dashboard utama
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildHeader(userProvider),
            const SizedBox(height: 24),
            // --- KARTU PEREBUSAN (DINAMIS) ---
            _buildRoomCard(
              title: 'Ruang Blanching',
              statusColor: const Color(0xFF34A853),
              icon: Icons.local_fire_department_outlined,
              children: [
                _buildInfoRow(
                  'Suhu',
                  '${perebusanProvider.dataAvgSuhu}° C',
                  isLoading: perebusanProvider.isLoading,
                ),
                // Timer data tidak ada di model baru, jadi saya komentari
                // _buildInfoRow('Timer', '02:30:15'), 
                _buildTimerControls(), // Tombol tetap ada
              ],
            ),
            const SizedBox(height: 16),
            // --- KARTU FERMENTASI (DINAMIS) ---
            _buildRoomCard(
              title: 'Ruang Fermentasi',
              statusColor: const Color(0xFFFFC107),
              icon: Icons.science_outlined,
              children: [
                _buildInfoRow(
                  'Suhu',
                  '${fermentasiProvider.dataAvgSuhu}° C',
                  isLoading: fermentasiProvider.isLoading,
                ),
                _buildInfoRow(
                  'Kelembapan',
                  '${fermentasiProvider.dataAvgKelembaban}%',
                  isLoading: fermentasiProvider.isLoading,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // --- KARTU PENGERINGAN (DINAMIS) ---
            _buildRoomCard(
              title: 'Ruang Pengeringan',
              statusColor: const Color(0xFF2196F3),
              icon: Icons.air_outlined,
              children: [
                _buildInfoRow(
                  'Suhu',
                  // Data pengeringan punya struktur model yang sedikit berbeda
                  '${pengeringanProvider.data?.suhuData.dataAvgSuhu ?? '...'}° C',
                  isLoading: pengeringanProvider.isLoading,
                ),
                _buildInfoRow(
                  'Kelembapan',
                  '${pengeringanProvider.data?.suhuData.dataAvgKelembaban ?? '...'}%',
                  isLoading: pengeringanProvider.isLoading,
                ),
                // Kirim provider dan gudangId ke widget switch
                _buildBlowerSwitchRow(pengeringanProvider, activeGudangId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(UserProvider userProvider) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage('assets/images/icon.jpg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Data user dinamis dari UserProvider
                'Halo, ${userProvider.user?.name ?? 'Loading...'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              const Text(
                'Selamat Datang Kembali!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 24,
              color: Colors.black54,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildRoomCard({
    required String title,
    required Color statusColor,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20.0),
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
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
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
          const Divider(height: 28, thickness: 1, color: Color(0xFFF0F0F0)),
          ...children,
        ],
      ),
    );
  }

  // Tambahkan parameter isLoading
  Widget _buildInfoRow(String label, String value,
      {bool isLoading = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            // Tampilkan '...' jika loading, jika tidak tampilkan value
            isLoading ? '...' : value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Modifikasi untuk menerima PengeringanProvider
  Widget _buildBlowerSwitchRow(
      PengeringanProvider provider, String? gudangId) {
    // Ambil state dari provider
    final bool isBlowerLoading = provider.isTogglingBlower;
    final bool isBlowerOn = provider.data?.blowerData.statusBlower == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Blower',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Switch(
            value: isBlowerOn,
            onChanged: (isBlowerLoading || gudangId == null)
                ? null // Nonaktifkan switch jika sedang loading atau gudangId null
                : (value) {
                    // Panggil method toggleBlower dari provider
                    provider.toggleBlower(gudangId);
                  },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // Widget ini tetap menggunakan state lokal karena
  // logika start/stop timer belum ada di provider
  Widget _buildTimerControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: isTimerRunning
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
                // TODO: Tambahkan logika untuk MENGHENTIKAN timer via API
              },
            )
          : ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Mulai Timer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 42),
              ),
              onPressed: () {
                setState(() {
                  isTimerRunning = true;
                });
                // TODO: Tambahkan logika untuk MEMULAI timer via API
              },
            ),
    );
  }
}
