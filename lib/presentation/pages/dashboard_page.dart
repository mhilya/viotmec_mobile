import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iotmcc_mobile/presentation/providers/user_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isBlowerOn = true;
  bool isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    // Load user data ketika halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildHeader(userProvider),
            const SizedBox(height: 24),
            _buildRoomCard(
              title: 'Ruang Perebusan',
              statusColor: const Color(0xFF34A853),
              icon: Icons.local_fire_department_outlined,
              children: [
                _buildInfoRow('Suhu', '95° C'),
                _buildInfoRow('Timer', '02:30:15'),
                _buildTimerControls(),
              ],
            ),
            const SizedBox(height: 16),
            _buildRoomCard(
              title: 'Ruang Fermentasi',
              statusColor: const Color(0xFFFFC107),
              icon: Icons.science_outlined,
              children: [
                _buildInfoRow('Suhu', '32° C'),
                _buildInfoRow('Kelembapan', '85%'),
              ],
            ),
            const SizedBox(height: 16),
            _buildRoomCard(
              title: 'Ruang Pengeringan',
              statusColor: const Color(0xFF2196F3),
              icon: Icons.air_outlined,
              children: [
                _buildInfoRow('Suhu', '45° C'),
                _buildInfoRow('Kelembapan', '55%'),
                _buildBlowerSwitchRow(),
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

  Widget _buildInfoRow(String label, String value) {
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
            value,
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

  Widget _buildBlowerSwitchRow() {
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
            onChanged: (value) {
              setState(() {
                isBlowerOn = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

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
                // TODO: Tambahkan logika untuk MENGHENTIKAN timer
              },
            )
          : ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Mulai Timer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 42),
                // Menggunakan style dari theme, tidak perlu kustomisasi berlebih
              ),
              onPressed: () {
                setState(() {
                  isTimerRunning = true;
                });
                // TODO: Tambahkan logika untuk MEMULAI timer
              },
            ),
    );
  }
}
