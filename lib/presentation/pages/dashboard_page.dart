import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viotmec_mobile/presentation/providers/user_provider.dart';
import 'package:viotmec_mobile/presentation/providers/fermentasi_provider.dart';
import 'package:viotmec_mobile/presentation/providers/gudang_provider.dart';
import 'package:viotmec_mobile/presentation/providers/pengeringan_provider.dart';
import 'package:viotmec_mobile/presentation/providers/blanching_provider.dart';
import 'package:viotmec_mobile/core/network/fcm_service.dart';
import 'package:viotmec_mobile/presentation/pages/notifikasi_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _lastLoadedGudangId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      FcmService().initNotifications();
    });
  }

  Future<void> _loadInitialData() async {
    final userProvider = context.read<UserProvider>();
    final gudangProvider = context.read<GudangProvider>();

    await userProvider.getUserProfile();
    await gudangProvider.loadGudangList();

    if (gudangProvider.activeGudangId != null) {
      _fetchRoomData(gudangProvider.activeGudangId!);
    }
  }

  Future<void> _fetchRoomData(String activeGudangId) async {
    if (!mounted) return;
    _lastLoadedGudangId = activeGudangId;
    
    final blanchingProvider = context.read<BlanchingProvider>();
    final fermentasiProvider = context.read<FermentasiProvider>();
    final pengeringanProvider = context.read<PengeringanProvider>();

    await Future.wait([
      blanchingProvider.fetchData(activeGudangId),
      fermentasiProvider.fetchData(activeGudangId),
      pengeringanProvider.fetchData(activeGudangId),
    ]);
  }

  Future<void> _onRefresh() async {
    final gudangProvider = context.read<GudangProvider>();
    if (gudangProvider.activeGudangId != null) {
      await _fetchRoomData(gudangProvider.activeGudangId!);
    } else {
      await gudangProvider.loadGudangList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, 
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Consumer5<UserProvider, GudangProvider, BlanchingProvider,
                FermentasiProvider, PengeringanProvider>(
              builder: (context, userProv, gudangProv, blanchingProv,
                  fermentasiProv, pengeringanProv, _) {
                if (gudangProv.activeGudangId != null && 
                    gudangProv.activeGudangId != _lastLoadedGudangId) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _fetchRoomData(gudangProv.activeGudangId!);
                    });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(userProv, context),
                    const SizedBox(height: 24),
                    _buildGudangDropdown(gudangProv),
                    const SizedBox(height: 24),
                    
                    if (gudangProv.isLoading && !gudangProv.hasActiveGudang)
                      const Center(child: CircularProgressIndicator())
                    else if (!gudangProv.hasActiveGudang)
                       _buildNoGudangState()
                    else ...[
                      _buildBlanchingCard(blanchingProv, gudangProv.activeGudangId),
                      const SizedBox(height: 20),
                      _buildFermentasiCard(fermentasiProv),
                      const SizedBox(height: 20),
                      _buildPengeringanCard(pengeringanProv, gudangProv.activeGudangId),
                      const SizedBox(height: 30),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserProvider userProvider, BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue.shade100, width: 2),
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/icon.jpg'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, ${userProvider.user?.name ?? 'Pengguna'}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Selamat Datang Kembali!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HalamanNotifikasi(),
              ),
            );
          },
          icon: Icon(Icons.notifications_outlined, color: Colors.grey.shade700),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200)),
          ),
        )
      ],
    );
  }

  Widget _buildGudangDropdown(GudangProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: provider.activeGudangId,
          isExpanded: true,
          hint: const Text('Pilih Gudang'),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: provider.gudangList.map((gudang) {
            return DropdownMenuItem(
              value: gudang.idGudang,
              child: Text(
                gudang.namaGudang,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.setActiveGudang(value);
              _fetchRoomData(value);
            }
          },
        ),
      ),
    );
  }
  
  Widget _buildBlanchingCard(BlanchingProvider provider, String? gudangId) {
    final timerData = provider.timerResponse?.getTimerByFlag('timer_1');
    final isRunning = timerData?.isRunning ?? false;
    final sisaTimer = timerData?.sisaTimer ?? 0.0;
    
    final minutes = (sisaTimer ~/ 60).toString().padLeft(2, '0');
    final seconds = (sisaTimer % 60).toInt().toString().padLeft(2, '0');

    return _buildGradientCard(
      title: 'Blanching (Perebusan)',
      subtitle: provider.isLoading ? 'Memuat data...' : 'Status: ${isRunning ? "Proses Berjalan" : "Standby"}',
      icon: Icons.water_drop_outlined,
      gradientColors: const [Color(0xFF43A047), Color(0xFF66BB6A)],
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItemCompact(
                'Suhu Air',
                '${provider.rataRataSuhu.toStringAsFixed(1)}°C',
                Icons.thermostat,
                Colors.white,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '$minutes:$seconds',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (provider.isLoading || gudangId == null) 
                  ? null 
                  : () => provider.toggleTimer(gudangId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isRunning ? Colors.red : const Color(0xFF43A047),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                isRunning ? 'Hentikan Timer' : 'Mulai Timer',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFermentasiCard(FermentasiProvider provider) {
    final isActive = provider.statusRuangan == 1;
    
    return _buildGradientCard(
      title: 'Fermentasi',
      subtitle: isActive ? 'Ruangan Aktif' : 'Ruangan Non-Aktif',
      icon: Icons.science_outlined,
      gradientColors: const [Color(0xFFFFA726), Color(0xFFFF7043)],
      content: Row(
        children: [
          Expanded(
            child: _buildStatItemCompact(
              'Rata-rata Suhu',
              '${provider.currentSuhu}°C',
              Icons.thermostat,
              Colors.white,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          Expanded(
            child: _buildStatItemCompact(
              'Kelembaban',
              '${provider.currentKelembaban}%',
              Icons.water_drop,
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengeringanCard(PengeringanProvider provider, String? gudangId) {
    return _buildGradientCard(
      title: 'Pengeringan',
      subtitle: 'Monitoring & Kontrol',
      icon: Icons.air,
      gradientColors: const [Color(0xFF42A5F5), Color(0xFF1E88E5)],
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItemCompact(
                  'Suhu',
                  '${provider.currentSuhu}°C',
                  Icons.thermostat,
                  Colors.white,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _buildStatItemCompact(
                  'Kelembaban',
                  '${provider.currentKelembaban}%',
                  Icons.water_drop,
                  Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          
          if (provider.availableBlowers.isEmpty)
             const Text('Tidak ada blower terdeteksi', style: TextStyle(color: Colors.white70, fontSize: 12)),
             
          ...provider.availableBlowers.map((blowerMeta) {
            final isBlowerActive = provider.isBlowerActive(blowerMeta.idSensor);
            final isToggling = provider.isBlowerToggling(blowerMeta.idSensor);
            final label = blowerMeta.flagSensor.replaceAll('_', ' ').toUpperCase();

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wind_power, 
                        color: isBlowerActive ? Colors.yellowAccent : Colors.white70, 
                        size: 20
                      ),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: isToggling 
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Switch(
                          value: isBlowerActive,
                          activeColor: Colors.white,
                          activeTrackColor: Colors.greenAccent.shade400,
                          inactiveThumbColor: Colors.grey.shade300,
                          inactiveTrackColor: Colors.black26,
                          onChanged: (value) {
                             provider.toggleBlower(blowerMeta.idSensor);
                          },
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildGradientCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildStatItemCompact(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.8), size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoGudangState() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.warehouse_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Silakan pilih gudang terlebih dahulu',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}