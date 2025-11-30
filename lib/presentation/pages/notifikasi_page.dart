import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:viotmec_mobile/presentation/providers/riwayat_notifikasi_provider.dart';

class HalamanNotifikasi extends StatefulWidget {
  @override
  _HalamanNotifikasiState createState() => _HalamanNotifikasiState();
}

class _HalamanNotifikasiState extends State<HalamanNotifikasi> {
  @override
  void initState() {
    super.initState();
    // Panggil fetch data saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // listen: false karena kita hanya memanggil fungsi, bukan mendengar perubahan state di sini
      context.read<RiwayatNotifikasiProvider>().fetchNotifikasi();
    });
  }

  // Helper Warna
  Color _getCardColor(String kategori) {
    switch (kategori) {
      case 'danger':
        return Colors.red.shade50;
      case 'warning':
        return Colors.orange.shade50;
      default:
        return Colors.white;
    }
  }

  // Helper Icon
  Icon _getIcon(String kategori) {
    switch (kategori) {
      case 'danger':
        return Icon(Icons.dangerous, color: Colors.red);
      case 'warning':
        return Icon(Icons.warning_amber, color: Colors.orange);
      default:
        return Icon(Icons.info_outline, color: Colors.blue);
    }
  }

  String _formatTanggal(String rawDate) {
    try {
      DateTime dt = DateTime.parse(rawDate).toLocal();
      return DateFormat('d MMM, HH:mm', 'id_ID').format(dt);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Peringatan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Consumer<RiwayatNotifikasiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 10),
                  Text(provider.errorMessage!),
                  TextButton(
                    onPressed: () => provider.fetchNotifikasi(),
                    child: Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }
          if (provider.listNotifikasi.isEmpty) {
            return Center(
              child: RefreshIndicator(
                onRefresh: () => provider.fetchNotifikasi(),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text("Belum ada notifikasi"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchNotifikasi(),
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: provider.listNotifikasi.length,
              itemBuilder: (context, index) {
                final item = provider.listNotifikasi[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12),
                  color: _getCardColor(item.kategori),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: _getIcon(item.kategori),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _formatTanggal(item.createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                item.body,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
