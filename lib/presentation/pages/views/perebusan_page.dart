// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class PerebusanPage extends StatefulWidget {
//   const PerebusanPage({super.key});

//   @override
//   State<PerebusanPage> createState() => _PerebusanPageState();
// }

// class _PerebusanPageState extends State<PerebusanPage> {
//   bool isTimerRunning = false;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           _buildHeaderCard(),
//           const SizedBox(height: 20),
//           _buildChartCard(),
//           const SizedBox(height: 20),
//           _buildInfoCards(),
//           const SizedBox(height: 20),
//           _buildEventLogCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF34A853), Color(0xFF2E8B46)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF34A853).withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.thermostat_auto_outlined,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Status Perebusan Stabil',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildStatusIndicator(),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Suhu terkendali dalam range optimal',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusIndicator() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 6),
//           const Text(
//             'STABIL',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChartCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//           const Text(
//             'Riwayat Suhu 30 Data Terakhir',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 200,
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   horizontalInterval: 5,
//                   verticalInterval: 4,
//                   getDrawingHorizontalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey.shade200,
//                       strokeWidth: 1,
//                       dashArray: [4],
//                     );
//                   },
//                   getDrawingVerticalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey.shade200,
//                       strokeWidth: 1,
//                       dashArray: [4],
//                     );
//                   },
//                 ),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       interval: 6,
//                       getTitlesWidget: (value, meta) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             '${value.toInt().toString().padLeft(2, '0')}:00',
//                             style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       interval: 5,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()}°C',
//                           style: const TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 10,
//                             color: Colors.grey,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border.all(color: Colors.grey.shade300, width: 1),
//                 ),
//                 minX: 0,
//                 maxX: 23,
//                 minY: 85,
//                 maxY: 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 95), FlSpot(2, 96), FlSpot(4, 95),
//                       FlSpot(6, 97), FlSpot(8, 98), FlSpot(10, 99),
//                       FlSpot(12, 98), FlSpot(14, 96), FlSpot(16, 95),
//                       FlSpot(18, 94), FlSpot(20, 92), FlSpot(22, 90),
//                       FlSpot(23, 90),
//                     ],
//                     isCurved: true,
//                     color: const Color(0xFF34A853),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF34A853).withOpacity(0.3),
//                           const Color(0xFF34A853).withOpacity(0.0),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCards() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > 600) {
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.thermostat,
//                   title: 'Parameter Utama',
//                   children: [
//                     _infoRow('Suhu Rata-rata:', '95° C'),
//                     _infoRow('Total Waktu:', '02:30:00'),
//                   ],
//                   actionButton: _buildTimerControls(),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.power_settings_new,
//                   title: 'Status Operasional',
//                   children: [
//                     _buildOperationalStatus(),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Column(
//             children: [
//               _buildInfoCard(
//                 icon: Icons.thermostat,
//                 title: 'Parameter Utama',
//                 children: [
//                   _infoRow('Suhu Rata-rata:', '95° C'),
//                   _infoRow('Total Waktu:', '02:30:00'),
//                 ],
//                 actionButton: _buildTimerControls(),
//               ),
//               const SizedBox(height: 16),
//               _buildInfoCard(
//                 icon: Icons.power_settings_new,
//                 title: 'Status Operasional',
//                 children: [
//                   _buildOperationalStatus(),
//                 ],
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required List<Widget> children,
//     Widget? actionButton,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//                   color: const Color(0xFF34A853).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 20, color: const Color(0xFF34A853)),
//               ),
//               const SizedBox(width: 12),
//               Flexible(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...children,
//           if (actionButton != null) ...[
//             const SizedBox(height: 16),
//             actionButton,
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTimerControls() {
//     return isTimerRunning
//         ? OutlinedButton.icon(
//             icon: const Icon(Icons.stop_rounded),
//             label: const Text('Hentikan Timer'),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.red.shade700,
//               side: BorderSide(color: Colors.red.shade300, width: 1.5),
//               minimumSize: const Size(double.infinity, 42),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               setState(() {
//                 isTimerRunning = false;
//               });
//               // TODO: Tambahkan logika untuk MENGHENTIKAN timer
//             },
//           )
//         : ElevatedButton.icon(
//             icon: const Icon(Icons.play_arrow_rounded),
//             label: const Text('Mulai Timer'),
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(double.infinity, 42),
//             ),
//             onPressed: () {
//               setState(() {
//                 isTimerRunning = true;
//               });
//               // TODO: Tambahkan logika untuk MEMULAI timer
//             },
//           );
//   }
  
//   Widget _buildOperationalStatus() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: 20,
//           height: 20,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.green,
//             border: Border.all(color: Colors.green.shade700, width: 3),
//           ),
//         ),
//         const SizedBox(width: 12),
//         const Text(
//           'AKTIF',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.green,
//           ),
//         ),
//       ],
//     );
//   }


//   Widget _infoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF34A853),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventLogCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//           const Row(
//             children: [
//               Icon(Icons.history, color: Color(0xFF34A853)),
//               SizedBox(width: 8),
//               Text(
//                 'Event Log',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ..._buildEventLogItems(),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildEventLogItems() {
//     final events = [
//       {'time': '09:00', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'duration': '16h 102:00'},
//       {'time': '08:45', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'duration': '13:12:09'},
//       {'time': '08:30', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'duration': '12:45:30'},
//       {'time': '08:15', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'duration': '12:30:15'},
//     ];

//     return events.map((event) => _eventLogRow(event['event']!, event['duration']!, event['time']!)).toList();
//   }

//   Widget _eventLogRow(String event, String duration, String time) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF34A853).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.circle,
//               color: Color(0xFF34A853),
//               size: 8,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   event,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.black87,
//                     fontSize: 14,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(
//                       time,
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       width: 4,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade400,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       duration,
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:iotmcc_mobile/presentation/providers/perebusan_provider.dart';
// import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
// import 'package:iotmcc_mobile/data/models/perebusan_model.dart';

// class PerebusanPage extends StatefulWidget {
//   const PerebusanPage({super.key});

//   @override
//   State<PerebusanPage> createState() => _PerebusanPageState();
// }

// class _PerebusanPageState extends State<PerebusanPage> {
//   bool isTimerRunning = false;
//   bool _initialLoadCompleted = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadInitialData();
//     });
//   }

//   void _loadInitialData() async {
//     final gudangProvider = Provider.of<GudangProvider>(context, listen: false);
//     final perebusanProvider = Provider.of<PerebusanProvider>(context, listen: false);
    
//     // Load data gudang terlebih dahulu
//     await gudangProvider.loadGudangList();
    
//     // Setelah gudang loaded, load data perebusan
//     if (gudangProvider.activeGudangId != null) {
//       perebusanProvider.fetchData(gudangProvider.activeGudangId);
//       _initialLoadCompleted = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<GudangProvider, PerebusanProvider>(
//       builder: (context, gudangProvider, perebusanProvider, child) {
//         final data = perebusanProvider.data;
        
//         // Auto-reload ketika gudang aktif berubah
//         if (_initialLoadCompleted && gudangProvider.activeGudangId != null) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             perebusanProvider.fetchData(gudangProvider.activeGudangId);
//           });
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Tampilkan pesan jika tidak ada gudang aktif
//               if (gudangProvider.activeGudangId == null) 
//                 _buildNoActiveGudangWidget(gudangProvider),
              
//               if (gudangProvider.activeGudangId != null) ...[
//                 _buildHeaderCard(data, perebusanProvider),
//                 const SizedBox(height: 20),
                
//                 if (perebusanProvider.isLoading && data == null) 
//                   _buildLoadingIndicator(),
                
//                 if (perebusanProvider.errorMessage.isNotEmpty) 
//                   _buildErrorWidget(perebusanProvider),
                
//                 if (data != null) ...[
//                   _buildChartCard(data),
//                   const SizedBox(height: 20),
//                   _buildInfoCards(data),
//                   const SizedBox(height: 20),
//                   _buildEventLogCard(data),
//                 ],
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNoActiveGudangWidget(GudangProvider gudangProvider) {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       child: Column(
//         children: [
//           Icon(Icons.warehouse_outlined, size: 64, color: Colors.grey.shade400),
//           const SizedBox(height: 16),
//           const Text(
//             'Tidak Ada Gudang Aktif',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             gudangProvider.gudangList.isEmpty 
//               ? 'Tidak ada gudang tersedia'
//               : 'Pilih gudang dari menu dropdown',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//   Widget _buildLoadingIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       child: const Column(
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34A853)),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Memuat data perebusan...',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorWidget(PerebusanProvider provider) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.red.shade200),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.error_outline, color: Colors.red.shade600, size: 40),
//           const SizedBox(height: 12),
//           Text(
//             'Gagal memuat data',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.red.shade800,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             provider.errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.red.shade600,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton(
//             onPressed: _loadInitialData,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade600,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Coba Lagi'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderCard(PerebusanData? data, PerebusanProvider provider) {
//     final isActive = data?.statusRuangan == 1;
//     final statusText = isActive ? 'Status Perebusan Stabil' : 'Status Perebusan Non-Aktif';
//     final statusDescription = isActive
//         ? 'Suhu terkendali dalam range optimal'
//         : 'Ruangan perebusan sedang tidak aktif';

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isActive
//               ? [const Color(0xFF34A853), const Color(0xFF2E8B46)]
//               : [Colors.grey, Colors.grey.shade700],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: (isActive ? const Color(0xFF34A853) : Colors.grey).withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               isActive ? Icons.thermostat_auto_outlined : Icons.power_off,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   statusText,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildStatusIndicator(isActive),
//                 const SizedBox(height: 6),
//                 Text(
//                   statusDescription,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (provider.isLoading)
//             const SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusIndicator(bool isActive) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: isActive ? Colors.white : Colors.orange,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             isActive ? 'STABIL' : 'NON-AKTIF',
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChartCard(PerebusanData data) {
//     // Prepare chart spots from real data
//     final spots = _prepareChartSpots(data.dataSuhu, data.dataWaktuSuhu);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//           const Text(
//             'Riwayat Suhu 30 Data Terakhir',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 200,
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   horizontalInterval: 5,
//                   verticalInterval: 4,
//                   getDrawingHorizontalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey.shade200,
//                       strokeWidth: 1,
//                       dashArray: [4],
//                     );
//                   },
//                   getDrawingVerticalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey.shade200,
//                       strokeWidth: 1,
//                       dashArray: [4],
//                     );
//                   },
//                 ),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       interval: 6,
//                       getTitlesWidget: (value, meta) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             '${value.toInt()}',
//                             style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       interval: 5,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()}°C',
//                           style: const TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 10,
//                             color: Colors.grey,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border.all(color: Colors.grey.shade300, width: 1),
//                 ),
//                 minX: 0,
//                 maxX: data.dataSuhu.isNotEmpty
//                     ? (data.dataSuhu.length - 1).toDouble()
//                     : 0,
//                 minY:
//                     data.dataSuhu.isNotEmpty ? _getMinValue(data.dataSuhu) - 2 : 0,
//                 maxY:
//                     data.dataSuhu.isNotEmpty ? _getMaxValue(data.dataSuhu) + 2 : 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: const Color(0xFF34A853),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF34A853).withOpacity(0.3),
//                           const Color(0xFF34A853).withOpacity(0.0),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<FlSpot> _prepareChartSpots(
//       List<double> suhuData, List<String> waktuData) {
//     List<FlSpot> spots = [];
//     for (int i = 0; i < suhuData.length; i++) {
//       spots.add(FlSpot(i.toDouble(), suhuData[i]));
//     }
//     return spots;
//   }

//   double _getMinValue(List<double> data) {
//     if (data.isEmpty) return 0;
//     return data.reduce((a, b) => a < b ? a : b);
//   }

//   double _getMaxValue(List<double> data) {
//     if (data.isEmpty) return 100;
//     return data.reduce((a, b) => a > b ? a : b);
//   }

//   Widget _buildInfoCards(PerebusanData data) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > 600) {
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.thermostat,
//                   title: 'Parameter Utama',
//                   children: [
//                     _infoRow('Suhu Rata-rata:', '${data.dataAvgSuhu}° C'),
//                     _infoRow(
//                         'Kelembaban Rata-rata:', '${data.dataAvgKelembaban}%'),
//                     if (data.dataTimer != null)
//                       _infoRow('Timer:', '${data.dataTimer} detik'),
//                   ],
//                   actionButton: _buildTimerControls(data),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.power_settings_new,
//                   title: 'Status Operasional',
//                   children: [
//                     _buildOperationalStatus(data.statusRuangan),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Column(
//             children: [
//               _buildInfoCard(
//                 icon: Icons.thermostat,
//                 title: 'Parameter Utama',
//                 children: [
//                   _infoRow('Suhu Rata-rata:', '${data.dataAvgSuhu}° C'),
//                   _infoRow(
//                       'Kelembaban Rata-rata:', '${data.dataAvgKelembaban}%'),
//                   if (data.dataTimer != null)
//                     _infoRow('Timer:', '${data.dataTimer} detik'),
//                 ],
//                 actionButton: _buildTimerControls(data),
//               ),
//               const SizedBox(height: 16),
//               _buildInfoCard(
//                 icon: Icons.power_settings_new,
//                 title: 'Status Operasional',
//                 children: [
//                   _buildOperationalStatus(data.statusRuangan),
//                 ],
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required List<Widget> children,
//     Widget? actionButton,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//                   color: const Color(0xFF34A853).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 20, color: const Color(0xFF34A853)),
//               ),
//               const SizedBox(width: 12),
//               Flexible(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...children,
//           if (actionButton != null) ...[
//             const SizedBox(height: 16),
//             actionButton,
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTimerControls(PerebusanData data) {
//     return isTimerRunning
//         ? OutlinedButton.icon(
//             icon: const Icon(Icons.stop_rounded),
//             label: const Text('Hentikan Timer'),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.red.shade700,
//               side: BorderSide(color: Colors.red.shade300, width: 1.5),
//               minimumSize: const Size(double.infinity, 42),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               setState(() {
//                 isTimerRunning = false;
//               });
//               // TODO: Tambahkan logika untuk MENGHENTIKAN timer
//             },
//           )
//         : ElevatedButton.icon(
//             icon: const Icon(Icons.play_arrow_rounded),
//             label: const Text('Mulai Timer'),
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(double.infinity, 42),
//             ),
//             onPressed: data.statusRuangan == 1
//                 ? () {
//                     setState(() {
//                       isTimerRunning = true;
//                     });
//                     // TODO: Tambahkan logika untuk MEMULAI timer
//                   }
//                 : null,
//           );
//   }

//   Widget _buildOperationalStatus(int statusRuangan) {
//     final isActive = statusRuangan == 1;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: 20,
//           height: 20,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isActive ? Colors.green : Colors.grey,
//             border: Border.all(
//                 color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
//                 width: 3),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           isActive ? 'AKTIF' : 'NON-AKTIF',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: isActive ? Colors.green : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _infoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF34A853),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventLogCard(PerebusanData data) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//           const Row(
//             children: [
//               Icon(Icons.history, color: Color(0xFF34A853)),
//               SizedBox(width: 8),
//               Text(
//                 'Data Sensor Terbaru',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ..._buildSensorDataItems(data),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildSensorDataItems(PerebusanData data) {
//     if (data.dataSuhu.isEmpty && data.dataKelembaban.isEmpty) {
//       return [
//         Center(
//           child: Text(
//             'Tidak ada data sensor',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.grey.shade500,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ),
//       ];
//     }

//     List<Widget> items = [];
//     int itemCount = data.dataSuhu.length;

//     for (int i = 0; i < itemCount && i < 4; i++) {
//       final suhu = i < data.dataSuhu.length ? data.dataSuhu[i] : 0.0;
//       final waktu =
//           i < data.dataWaktuSuhu.length ? data.dataWaktuSuhu[i] : '--:--:--';
//       // Assuming dataKelembaban is a List<num> or List<dynamic>
//       final num kelembaban =
//           i < data.dataKelembaban.length ? data.dataKelembaban[i] : 0;

//       items.add(_sensorDataRow(suhu, kelembaban, waktu));
//       if (i < itemCount - 1 && i < 3) {
//         items.add(const SizedBox(height: 8));
//       }
//     }

//     return items;
//   }

//   // FIX: Changed the type of 'kelembaban' from 'double' to 'num'.
//   Widget _sensorDataRow(double suhu, num kelembaban, String waktu) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF34A853).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.sensors,
//               color: Color(0xFF34A853),
//               size: 16,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Suhu: ${suhu.toStringAsFixed(1)}°C',
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.black87,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       'Kelembaban: ${kelembaban.toStringAsFixed(1)}%',
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.black87,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.access_time,
//                         size: 14, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       waktu,
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:iotmcc_mobile/presentation/providers/perebusan_provider.dart';
// import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
// import 'package:iotmcc_mobile/data/models/perebusan_model.dart';

// class PerebusanPage extends StatefulWidget {
//   const PerebusanPage({super.key});

//   @override
//   State<PerebusanPage> createState() => _PerebusanPageState();
// }

// class _PerebusanPageState extends State<PerebusanPage> {
//   bool isTimerRunning = false;
//   // FIX: Ganti _initialLoadCompleted dengan variabel untuk melacak ID.
//   // Ini akan mencegah pemanggilan API berulang untuk ID yang sama.
//   String? _lastLoadedGudangId;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadInitialData();
//     });
//   }

//   void _loadInitialData() async {
//     final gudangProvider = Provider.of<GudangProvider>(context, listen: false);
//     // Tidak perlu memanggil perebusanProvider di sini, karena build method akan menanganinya
    
//     // Cukup load data gudang saja di awal.
//     await gudangProvider.loadGudangList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<GudangProvider, PerebusanProvider>(
//       builder: (context, gudangProvider, perebusanProvider, child) {
//         final data = perebusanProvider.data;
//         final activeId = gudangProvider.activeGudangId;
        
//         // FIX: Logika baru untuk mencegah infinite loop.
//         // Panggil fetchData HANYA JIKA activeId ada DAN berbeda dari yang terakhir dimuat.
//         if (activeId != null && activeId != _lastLoadedGudangId) {
//           // Tandai ID ini sebagai yang sedang dimuat SEBELUM memanggil API
//           _lastLoadedGudangId = activeId; 
          
//           // Jadwalkan pemanggilan API setelah build selesai
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             perebusanProvider.fetchData(activeId);
//           });
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Tampilkan pesan jika tidak ada gudang aktif
//               if (gudangProvider.activeGudangId == null) 
//                 _buildNoActiveGudangWidget(gudangProvider),
              
//               if (gudangProvider.activeGudangId != null) ...[
//                 _buildHeaderCard(data, perebusanProvider),
//                 const SizedBox(height: 20),
                
//                 // Tampilkan loading indicator jika sedang loading DAN belum ada data sama sekali
//                 if (perebusanProvider.isLoading && data == null) 
//                   _buildLoadingIndicator(),
                
//                 if (perebusanProvider.errorMessage.isNotEmpty && data == null) 
//                   _buildErrorWidget(perebusanProvider),
                
//                 if (data != null) ...[
//                   _buildChartCard(data),
//                   const SizedBox(height: 20),
//                   _buildInfoCards(data),
//                   const SizedBox(height: 20),
//                   _buildEventLogCard(data),
//                 ],
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNoActiveGudangWidget(GudangProvider gudangProvider) {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       child: Column(
//         children: [
//           Icon(Icons.warehouse_outlined, size: 64, color: Colors.grey.shade400),
//           const SizedBox(height: 16),
//           const Text(
//             'Tidak Ada Gudang Aktif',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             gudangProvider.gudangList.isEmpty 
//             ? 'Tidak ada gudang tersedia'
//             : 'Pilih gudang dari menu dropdown',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//   Widget _buildLoadingIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       child: const Column(
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34A853)),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Memuat data perebusan...',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorWidget(PerebusanProvider provider) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.red.shade200),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.error_outline, color: Colors.red.shade600, size: 40),
//           const SizedBox(height: 12),
//           Text(
//             'Gagal memuat data',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.red.shade800,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             provider.errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.red.shade600,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton(
//             onPressed: () {
//               // Reset _lastLoadedGudangId agar bisa fetch ulang
//               setState(() {
//                 _lastLoadedGudangId = null;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade600,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Coba Lagi'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderCard(PerebusanData? data, PerebusanProvider provider) {
//     final isActive = data?.statusRuangan == 1;
//     final statusText = isActive ? 'Status Perebusan Stabil' : 'Status Perebusan Non-Aktif';
//     final statusDescription = isActive
//         ? 'Suhu terkendali dalam range optimal'
//         : 'Ruangan perebusan sedang tidak aktif';

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isActive
//               ? [const Color(0xFF34A853), const Color(0xFF2E8B46)]
//               : [Colors.grey, Colors.grey.shade700],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: (isActive ? const Color(0xFF34A853) : Colors.grey).withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               isActive ? Icons.thermostat_auto_outlined : Icons.power_off,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   statusText,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildStatusIndicator(isActive),
//                 const SizedBox(height: 6),
//                 Text(
//                   statusDescription,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (provider.isLoading)
//             const SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusIndicator(bool isActive) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: isActive ? Colors.white : Colors.orange,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             isActive ? 'STABIL' : 'NON-AKTIF',
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChartCard(PerebusanData data) {
//     // Prepare chart spots from real data
//     final spots = _prepareChartSpots(data.dataSuhu, data.dataWaktuSuhu);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//           const Text(
//             'Riwayat Suhu 30 Data Terakhir',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 200,
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   horizontalInterval: 5,
//                   verticalInterval: 4,
//                   getDrawingHorizontalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey.shade200,
//                       strokeWidth: 1,
//                       dashArray: [4],
//                     );
//                   },
//                   getDrawingVerticalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey.shade200,
//                       strokeWidth: 1,
//                       dashArray: [4],
//                     );
//                   },
//                 ),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       interval: 6,
//                       getTitlesWidget: (value, meta) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             '${value.toInt()}',
//                             style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       interval: 5,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()}°C',
//                           style: const TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 10,
//                             color: Colors.grey,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border.all(color: Colors.grey.shade300, width: 1),
//                 ),
//                 minX: 0,
//                 maxX: data.dataSuhu.isNotEmpty
//                     ? (data.dataSuhu.length - 1).toDouble()
//                     : 0,
//                 minY:
//                     data.dataSuhu.isNotEmpty ? _getMinValue(data.dataSuhu) - 2 : 0,
//                 maxY:
//                     data.dataSuhu.isNotEmpty ? _getMaxValue(data.dataSuhu) + 2 : 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: const Color(0xFF34A853),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF34A853).withOpacity(0.3),
//                           const Color(0xFF34A853).withOpacity(0.0),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<FlSpot> _prepareChartSpots(
//       List<double> suhuData, List<String> waktuData) {
//     List<FlSpot> spots = [];
//     for (int i = 0; i < suhuData.length; i++) {
//       spots.add(FlSpot(i.toDouble(), suhuData[i]));
//     }
//     return spots;
//   }

//   double _getMinValue(List<double> data) {
//     if (data.isEmpty) return 0;
//     return data.reduce((a, b) => a < b ? a : b);
//   }

//   double _getMaxValue(List<double> data) {
//     if (data.isEmpty) return 100;
//     return data.reduce((a, b) => a > b ? a : b);
//   }

//   Widget _buildInfoCards(PerebusanData data) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > 600) {
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.thermostat,
//                   title: 'Parameter Utama',
//                   children: [
//                     _infoRow('Suhu Rata-rata:', '${data.dataAvgSuhu}° C'),
//                     _infoRow(
//                         'Kelembaban Rata-rata:', '${data.dataAvgKelembaban}%'),
//                     if (data.dataTimer != null)
//                       _infoRow('Timer:', '${data.dataTimer} detik'),
//                   ],
//                   actionButton: _buildTimerControls(data),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.power_settings_new,
//                   title: 'Status Operasional',
//                   children: [
//                     _buildOperationalStatus(data.statusRuangan),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Column(
//             children: [
//               _buildInfoCard(
//                 icon: Icons.thermostat,
//                 title: 'Parameter Utama',
//                 children: [
//                   _infoRow('Suhu Rata-rata:', '${data.dataAvgSuhu}° C'),
//                   _infoRow(
//                       'Kelembaban Rata-rata:', '${data.dataAvgKelembaban}%'),
//                   if (data.dataTimer != null)
//                     _infoRow('Timer:', '${data.dataTimer} detik'),
//                 ],
//                 actionButton: _buildTimerControls(data),
//               ),
//               const SizedBox(height: 16),
//               _buildInfoCard(
//                 icon: Icons.power_settings_new,
//                 title: 'Status Operasional',
//                 children: [
//                   _buildOperationalStatus(data.statusRuangan),
//                 ],
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required List<Widget> children,
//     Widget? actionButton,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//                   color: const Color(0xFF34A853).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 20, color: const Color(0xFF34A853)),
//               ),
//               const SizedBox(width: 12),
//               Flexible(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...children,
//           if (actionButton != null) ...[
//             const SizedBox(height: 16),
//             actionButton,
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTimerControls(PerebusanData data) {
//     return isTimerRunning
//         ? OutlinedButton.icon(
//             icon: const Icon(Icons.stop_rounded),
//             label: const Text('Hentikan Timer'),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.red.shade700,
//               side: BorderSide(color: Colors.red.shade300, width: 1.5),
//               minimumSize: const Size(double.infinity, 42),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               setState(() {
//                 isTimerRunning = false;
//               });
//               // TODO: Tambahkan logika untuk MENGHENTIKAN timer
//             },
//           )
//         : ElevatedButton.icon(
//             icon: const Icon(Icons.play_arrow_rounded),
//             label: const Text('Mulai Timer'),
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(double.infinity, 42),
//             ),
//             onPressed: data.statusRuangan == 1
//                 ? () {
//                     setState(() {
//                       isTimerRunning = true;
//                     });
//                     // TODO: Tambahkan logika untuk MEMULAI timer
//                   }
//                 : null,
//           );
//   }

//   Widget _buildOperationalStatus(int statusRuangan) {
//     final isActive = statusRuangan == 1;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: 20,
//           height: 20,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isActive ? Colors.green : Colors.grey,
//             border: Border.all(
//                 color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
//                 width: 3),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           isActive ? 'AKTIF' : 'NON-AKTIF',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: isActive ? Colors.green : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _infoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF34A853),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventLogCard(PerebusanData data) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
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
//           const Row(
//             children: [
//               Icon(Icons.history, color: Color(0xFF34A853)),
//               SizedBox(width: 8),
//               Text(
//                 'Data Sensor Terbaru',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ..._buildSensorDataItems(data),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildSensorDataItems(PerebusanData data) {
//     if (data.dataSuhu.isEmpty && data.dataKelembaban.isEmpty) {
//       return [
//         Center(
//           child: Text(
//             'Tidak ada data sensor',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.grey.shade500,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ),
//       ];
//     }

//     List<Widget> items = [];
//     int itemCount = data.dataSuhu.length;

//     for (int i = 0; i < itemCount && i < 4; i++) {
//       final suhu = i < data.dataSuhu.length ? data.dataSuhu[i] : 0.0;
//       final waktu =
//           i < data.dataWaktuSuhu.length ? data.dataWaktuSuhu[i] : '--:--:--';
//       // Assuming dataKelembaban is a List<num> or List<dynamic>
//       final num kelembaban =
//           i < data.dataKelembaban.length ? data.dataKelembaban[i] : 0;

//       items.add(_sensorDataRow(suhu, kelembaban, waktu));
//       if (i < itemCount - 1 && i < 3) {
//         items.add(const SizedBox(height: 8));
//       }
//     }

//     return items;
//   }

//   // FIX: Changed the type of 'kelembaban' from 'double' to 'num'.
//   Widget _sensorDataRow(double suhu, num kelembaban, String waktu) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF34A853).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.sensors,
//               color: Color(0xFF34A853),
//               size: 16,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Suhu: ${suhu.toStringAsFixed(1)}°C',
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.black87,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       'Kelembaban: ${kelembaban.toStringAsFixed(1)}%',
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.black87,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.access_time,
//                         size: 14, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       waktu,
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:iotmcc_mobile/presentation/providers/perebusan_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/data/models/perebusan_model.dart';

class PerebusanPage extends StatefulWidget {
  const PerebusanPage({super.key});

  @override
  State<PerebusanPage> createState() => _PerebusanPageState();
}

class _PerebusanPageState extends State<PerebusanPage> {
  bool isTimerRunning = false;
  String? _lastLoadedGudangId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final gudangProvider = Provider.of<GudangProvider>(context, listen: false);
    await gudangProvider.loadGudangList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GudangProvider, PerebusanProvider>(
      builder: (context, gudangProvider, perebusanProvider, child) {
        final data = perebusanProvider.data;
        final activeId = gudangProvider.activeGudangId;
        
        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId; 
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            perebusanProvider.fetchData(activeId);
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (gudangProvider.activeGudangId == null) 
                _buildNoActiveGudangWidget(gudangProvider),
              
              if (gudangProvider.activeGudangId != null) ...[
                _buildHeaderCard(data, perebusanProvider),
                const SizedBox(height: 20),
                
                if (perebusanProvider.isLoading && data == null) 
                  _buildLoadingIndicator(),
                
                if (perebusanProvider.errorMessage.isNotEmpty && data == null) 
                  _buildErrorWidget(perebusanProvider),
                
                if (data != null) ...[
                  _buildChartCard(data),
                  const SizedBox(height: 20),
                  _buildInfoCards(data),
                  const SizedBox(height: 20),
                  _buildEventLogCard(data),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoActiveGudangWidget(GudangProvider gudangProvider) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.warehouse_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Tidak Ada Gudang Aktif',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gudangProvider.gudangList.isEmpty 
            ? 'Tidak ada gudang tersedia'
            : 'Pilih gudang dari menu dropdown',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34A853)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data perebusan...',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(PerebusanProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 40),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat data',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.red.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.red.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _lastLoadedGudangId = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(PerebusanData? data, PerebusanProvider provider) {
    final isActive = data?.statusRuangan == 1;
    final statusText = isActive ? 'Status Perebusan Stabil' : 'Status Perebusan Non-Aktif';
    final statusDescription = isActive
        ? 'Suhu terkendali dalam range optimal'
        : 'Ruangan perebusan sedang tidak aktif';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFF34A853), const Color(0xFF2E8B46)]
              : [Colors.grey, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isActive ? const Color(0xFF34A853) : Colors.grey).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? Icons.thermostat_auto_outlined : Icons.power_off,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusIndicator(isActive),
                const SizedBox(height: 6),
                Text(
                  statusDescription,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (provider.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'STABIL' : 'NON-AKTIF',
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(PerebusanData data) {
    final spots = _prepareChartSpots(data.dataSuhu, data.dataWaktuSuhu);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          const Text(
            'Riwayat Suhu 30 Data Terakhir',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                      dashArray: [4],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                      dashArray: [4],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 6,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}°C',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                minX: 0,
                maxX: data.dataSuhu.isNotEmpty
                    ? (data.dataSuhu.length - 1).toDouble()
                    : 0,
                minY:
                    data.dataSuhu.isNotEmpty ? _getMinValue(data.dataSuhu) - 2 : 0,
                maxY:
                    data.dataSuhu.isNotEmpty ? _getMaxValue(data.dataSuhu) + 2 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF34A853),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF34A853).withOpacity(0.3),
                          const Color(0xFF34A853).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _prepareChartSpots(
      List<double> suhuData, List<String> waktuData) {
    List<FlSpot> spots = [];
    for (int i = 0; i < suhuData.length; i++) {
      spots.add(FlSpot(i.toDouble(), suhuData[i]));
    }
    return spots;
  }

  double _getMinValue(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue(List<double> data) {
    if (data.isEmpty) return 100;
    return data.reduce((a, b) => a > b ? a : b);
  }

  Widget _buildInfoCards(PerebusanData data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.thermostat,
                  title: 'Parameter Utama',
                  children: [
                    _infoRow('Suhu Rata-rata:', '${data.dataAvgSuhu}° C'),
                    // CHANGE: Kelembaban disembunyikan dan Timer ditampilkan secara default
                    _infoRow('Timer:', '00:00:00'),
                  ],
                  actionButton: _buildTimerControls(data),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.power_settings_new,
                  title: 'Status Operasional',
                  children: [
                    _buildOperationalStatus(data.statusRuangan),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildInfoCard(
                icon: Icons.thermostat,
                title: 'Parameter Utama',
                children: [
                  _infoRow('Suhu Rata-rata:', '${data.dataAvgSuhu}° C'),
                  // CHANGE: Kelembaban disembunyikan dan Timer ditampilkan secara default
                  _infoRow('Timer:', '00:00:00'),
                ],
                actionButton: _buildTimerControls(data),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.power_settings_new,
                title: 'Status Operasional',
                children: [
                  _buildOperationalStatus(data.statusRuangan),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
    Widget? actionButton,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                  color: const Color(0xFF34A853).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF34A853)),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
          if (actionButton != null) ...[
            const SizedBox(height: 16),
            actionButton,
          ],
        ],
      ),
    );
  }

  Widget _buildTimerControls(PerebusanData data) {
    return isTimerRunning
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
            ),
            onPressed: data.statusRuangan == 1
                ? () {
                    setState(() {
                      isTimerRunning = true;
                    });
                    // TODO: Tambahkan logika untuk MEMULAI timer
                  }
                : null,
          );
  }

  Widget _buildOperationalStatus(int statusRuangan) {
    final isActive = statusRuangan == 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey,
            border: Border.all(
                color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
                width: 3),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          isActive ? 'AKTIF' : 'NON-AKTIF',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF34A853),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventLogCard(PerebusanData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          const Row(
            children: [
              Icon(Icons.history, color: Color(0xFF34A853)),
              SizedBox(width: 8),
              Text(
                'Data Sensor Terbaru',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildSensorDataItems(data),
        ],
      ),
    );
  }

  List<Widget> _buildSensorDataItems(PerebusanData data) {
    if (data.dataSuhu.isEmpty) { // Cukup cek suhu saja
      return [
        Center(
          child: Text(
            'Tidak ada data sensor',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ];
    }

    List<Widget> items = [];
    int itemCount = data.dataSuhu.length;

    for (int i = 0; i < itemCount && i < 4; i++) {
      final suhu = i < data.dataSuhu.length ? data.dataSuhu[i] : 0.0;
      final waktu =
          i < data.dataWaktuSuhu.length ? data.dataWaktuSuhu[i] : '--:--:--';
      
      // Data kelembaban tidak perlu diambil lagi karena tidak akan ditampilkan
      // final num kelembaban = i < data.dataKelembaban.length ? data.dataKelembaban[i] : 0;

      items.add(_sensorDataRow(suhu, waktu));
      if (i < itemCount - 1 && i < 3) {
        items.add(const SizedBox(height: 8));
      }
    }

    return items;
  }

  // CHANGE: Widget ini sekarang hanya menerima suhu dan waktu
  Widget _sensorDataRow(double suhu, String waktu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF34A853).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sensors,
              color: Color(0xFF34A853),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CHANGE: Row di sini tidak lagi memerlukan spaceBetween
                Row(
                  children: [
                    Text(
                      'Suhu: ${suhu.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Teks kelembaban dihilangkan
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      waktu,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

