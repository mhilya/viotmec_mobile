// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// // import 'package:iotmcc_mobile/routes/app_routes.dart';

// class LaporanPage extends StatefulWidget {
//   const LaporanPage({super.key});

//   @override
//   State<LaporanPage> createState() => _LaporanPageState();
// }

// class _LaporanPageState extends State<LaporanPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Laporan',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             color: Colors.black87,
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: const Color(0xFF34A853),
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: const Color(0xFF34A853),
//           indicatorWeight: 3,
//           labelStyle: const TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//           tabs: const [
//             Tab(
//               icon: Icon(Icons.local_fire_department_outlined, size: 20),
//               text: 'Perebusan',
//             ),
//             Tab(
//               icon: Icon(Icons.science_outlined, size: 20),
//               text: 'Fermentasi',
//             ),
//             Tab(
//               icon: Icon(Icons.ac_unit_outlined, size: 20),
//               text: 'Pengeringan',
//             ),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: const [
//           DetailRuanganView(),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.science, size: 60, color: Colors.grey),
//                 SizedBox(height: 16),
//                 Text(
//                   'Data Fermentasi',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.ac_unit, size: 60, color: Colors.grey),
//                 SizedBox(height: 16),
//                 Text(
//                   'Data Pengeringan',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DetailRuanganView extends StatelessWidget {
//   const DetailRuanganView({super.key});

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
//           Text(
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
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Riwayat Suhu 7 Hari Terakhir',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
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
//                   verticalInterval: 1,
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
//                       getTitlesWidget: (value, meta) {
//                         final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             days[value.toInt()],
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
//                 maxX: 6,
//                 minY: 0,
//                 maxY: 20,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 5),
//                       FlSpot(1, 7),
//                       FlSpot(2, 6),
//                       FlSpot(3, 10),
//                       FlSpot(4, 15),
//                       FlSpot(5, 18),
//                       FlSpot(6, 17),
//                     ],
//                     isCurved: true,
//                     color: const Color(0xFF34A853),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         return FlDotCirclePainter(
//                           radius: 4,
//                           color: Colors.white,
//                           strokeWidth: 2,
//                           strokeColor: Color(0xFF34A853),
//                         );
//                       },
//                     ),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF34A853).withOpacity(0.3),
//                           const Color(0xFF34A853).withOpacity(0.1),
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
//             children: [
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.thermostat,
//                   title: 'Parameter Utama',
//                   children: [
//                     _infoRow('Suhu Rata-rata:', '95° C'),
//                     _infoRow('Total Waktu:', '02:30:00'),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildInfoCard(
//                   icon: Icons.power_settings_new,
//                   title: 'Status Operasional',
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 20,
//                           height: 20,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.green,
//                             border: Border.all(color: Colors.green.shade700, width: 3),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'AKTIF',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     )
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
//               ),
//               const SizedBox(height: 16),
//               _buildInfoCard(
//                 icon: Icons.power_settings_new,
//                 title: 'Status Operasional',
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.green,
//                           border: Border.all(color: Colors.green.shade700, width: 3),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'AKTIF',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   )
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
//         ],
//       ),
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
//       {'time': '09:00', 'event': 'Pemanasan dimulai. Sistem mencapai suhu target 95°C', 'duration': '16h 102:00'},
//       {'time': '08:45', 'event': 'Monitoring suhu stabil dalam range optimal', 'duration': '13:12:09'},
//       {'time': '08:30', 'event': 'Proses perebusan batch #0234 dimulai', 'duration': '12:45:30'},
//       {'time': '08:15', 'event': 'Quality check passed - ready for production', 'duration': '12:30:15'},
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
//             child: Icon(
//               Icons.circle,
//               color: const Color(0xFF34A853),
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
          'Laporan',
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
        children: const [
          PerebusanPage(),
          FermentasiPage(),
          PengeringanPage(),
        ],
      ),
    );
  }
}