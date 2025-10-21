// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class PengeringanPage extends StatefulWidget {
//   const PengeringanPage({super.key});

//   @override
//   State<PengeringanPage> createState() => _PengeringanPageState();
// }

// class _PengeringanPageState extends State<PengeringanPage> {
//   bool isBlowerOn = true;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           _buildHeaderCard(),
//           const SizedBox(height: 20),
//           _buildBlowerControlCard(),
//           const SizedBox(height: 20),
//           _buildTempChartCard(), // <-- Grafik Suhu 24 Jam
//           const SizedBox(height: 20),
//           _buildHumidityChartCard(), // <-- KARTU BARU: Grafik Kelembapan 24 Jam
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
//           colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF2196F3).withOpacity(0.3),
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
//               Icons.air_outlined,
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
//                   'Status Pengeringan Aktif',
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
//                   'Proses pengeringan mencapai tahap akhir',
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
//             'AKTIF',
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

//   // Widget ini diubah untuk menampilkan suhu 24 jam
//   Widget _buildTempChartCard() {
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
//                   getDrawingHorizontalLine: (value) => FlLine(
//                     color: Colors.grey.shade200,
//                     strokeWidth: 1,
//                     dashArray: [4],
//                   ),
//                   getDrawingVerticalLine: (value) => FlLine(
//                     color: Colors.grey.shade200,
//                     strokeWidth: 1,
//                     dashArray: [4],
//                   ),
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
//                                 fontFamily: 'Poppins',
//                                 fontSize: 10,
//                                 color: Colors.grey),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       getTitlesWidget: (value, meta) => Text(
//                         '${value.toInt()}°C',
//                         style: const TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 10,
//                             color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(color: Colors.grey.shade300)),
//                 minX: 0,
//                 maxX: 23,
//                 minY: 40,
//                 maxY: 60,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 45), FlSpot(2, 48), FlSpot(4, 50),
//                       FlSpot(6, 52), FlSpot(8, 51), FlSpot(10, 49),
//                       FlSpot(12, 48), FlSpot(14, 46), FlSpot(16, 45),
//                       FlSpot(18, 44), FlSpot(20, 43), FlSpot(23, 42),
//                     ],
//                     isCurved: true,
//                     color: const Color(0xFF2196F3),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF2196F3).withOpacity(0.3),
//                           const Color(0xFF2196F3).withOpacity(0.0),
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

//   // WIDGET BARU untuk menampilkan kelembapan 24 jam
//   Widget _buildHumidityChartCard() {
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
//             'Riwayat Kelembapan 24 Jam Terakhir',
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
//                   getDrawingHorizontalLine: (value) => FlLine(
//                     color: Colors.grey.shade200,
//                     strokeWidth: 1,
//                     dashArray: [4],
//                   ),
//                   getDrawingVerticalLine: (value) => FlLine(
//                     color: Colors.grey.shade200,
//                     strokeWidth: 1,
//                     dashArray: [4],
//                   ),
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
//                                 fontFamily: 'Poppins',
//                                 fontSize: 10,
//                                 color: Colors.grey),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       getTitlesWidget: (value, meta) => Text(
//                         '${value.toInt()}%',
//                         style: const TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 10,
//                             color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(color: Colors.grey.shade300)),
//                 minX: 0,
//                 maxX: 23,
//                 minY: 40,
//                 maxY: 70,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 65), FlSpot(2, 62), FlSpot(4, 60),
//                       FlSpot(6, 58), FlSpot(8, 55), FlSpot(10, 56),
//                       FlSpot(12, 58), FlSpot(14, 60), FlSpot(16, 61),
//                       FlSpot(18, 63), FlSpot(20, 64), FlSpot(23, 65),
//                     ],
//                     isCurved: true,
//                     color: Colors.teal, // Warna berbeda untuk kelembapan
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.teal.withOpacity(0.3),
//                           Colors.teal.withOpacity(0.0),
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

//   Widget _buildBlowerControlCard() {
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
//                   color: const Color(0xFF2196F3).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.air, size: 20, color: Color(0xFF2196F3)),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Kontrol Blower',
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
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Status Blower',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     isBlowerOn ? 'MENYALA' : 'MATI',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: isBlowerOn ? const Color(0xFF2196F3) : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               Switch(
//                 value: isBlowerOn,
//                 onChanged: (value) {
//                   setState(() {
//                     isBlowerOn = value;
//                   });
//                 },
//                 activeColor: const Color(0xFF2196F3),
//                 activeTrackColor: const Color(0xFF2196F3).withOpacity(0.5),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.info_outline,
//                   color: Colors.blue.shade600,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Blower berfungsi untuk mengatur sirkulasi udara dalam ruang pengeringan',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
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
//                     _infoRow('Suhu Rata-rata:', '45° C'),
//                     _infoRow('Kelembapan:', '55%'),
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
//                             color: Colors.blue,
//                             border:
//                                 Border.all(color: Colors.blue.shade700, width: 3),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'AKTIF',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
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
//                   _infoRow('Suhu Rata-rata:', '45° C'),
//                   _infoRow('Kelembapan:', '55%'),
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
//                           color: Colors.blue,
//                           border: Border.all(
//                               color: Colors.blue.shade700, width: 3),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'AKTIF',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
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
//                   color: const Color(0xFF2196F3).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 20, color: const Color(0xFF2196F3)),
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
//               color: Color(0xFF2196F3),
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
//               Icon(Icons.history, color: Color(0xFF2196F3)),
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
//       {'time': '11:45', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','duration': '05:30:00'},
//       {'time': '10:20', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','duration': '06:55:15'},
//       {'time': '09:15', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','duration': '08:00:45'},
//       {'time': '08:00', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','duration': '09:15:30'},
//     ];

//     return events
//         .map((event) =>
//             _eventLogRow(event['event']!, event['duration']!, event['time']!))
//         .toList();
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
//               color: const Color(0xFF2196F3).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.circle,
//               color: Color(0xFF2196F3),
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

// D:\msaif\Project\Flutter\iotmcc_mobile\lib\presentation\pages\views\pengeringan_page.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iotmcc_mobile/data/models/pengeringan_model.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/pengeringan_provider.dart';
import 'package:provider/provider.dart';

class PengeringanPage extends StatefulWidget {
  const PengeringanPage({super.key});

  @override
  State<PengeringanPage> createState() => _PengeringanPageState();
}

class _PengeringanPageState extends State<PengeringanPage> {
  // Variabel lokal untuk switch blower (dummy)
  bool isBlowerOn = true;
  String? _lastLoadedGudangId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    // Muat daftar gudang saat halaman dibuka
    final gudangProvider = Provider.of<GudangProvider>(context, listen: false);
    await gudangProvider.loadGudangList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GudangProvider, PengeringanProvider>(
      builder: (context, gudangProvider, pengeringanProvider, child) {
        final data = pengeringanProvider.data;
        final activeId = gudangProvider.activeGudangId;

        // Logika untuk fetch data ketika gudang aktif berubah
        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pengeringanProvider.fetchData(activeId);
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Tampilkan widget "Tidak Ada Gudang" jika ID null
              if (gudangProvider.activeGudangId == null)
                _buildNoActiveGudangWidget(gudangProvider),

              // Tampilkan data jika gudang aktif ada
              if (gudangProvider.activeGudangId != null) ...[
                // Tampilkan loading HANYA jika data belum ada
                if (pengeringanProvider.isLoading && data == null)
                  _buildLoadingIndicator(),

                // Tampilkan error HANYA jika data belum ada
                if (pengeringanProvider.errorMessage!.isNotEmpty &&
                    data == null)
                  _buildErrorWidget(pengeringanProvider),

                // Tampilkan semua kartu jika data sudah ada
                if (data != null) ...[
                  _buildHeaderCard(data, pengeringanProvider),
                  const SizedBox(height: 20),
                  _buildBlowerControlCard(), // <-- Menggunakan state dummy lokal
                  const SizedBox(height: 20),
                  _buildTempChartCard(data.suhuData),
                  const SizedBox(height: 20),
                  _buildHumidityChartCard(data.suhuData),
                  const SizedBox(height: 20),
                  _buildInfoCards(data),
                  const SizedBox(height: 20),
                  _buildEventLogCard(), // <-- Menggunakan data dummy
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  // --- WIDGET UNTUK STATE MANAGEMENT ---

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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data pengeringan...',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(PengeringanProvider provider) {
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
              // Reset _lastLoadedGudangId agar fetch ulang
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

  // --- WIDGET KARTU ---

  Widget _buildHeaderCard(PengeringanData data, PengeringanProvider provider) {
    // Menggunakan data dari provider
    final isActive = data.blowerData.statusRuangan == 1;
    final statusText = isActive
        ? 'Status Pengeringan Aktif'
        : 'Status Pengeringan Non-Aktif';
    final statusDescription = isActive
        ? 'Proses pengeringan berjalan optimal'
        : 'Ruangan pengeringan sedang tidak aktif';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFF2196F3), const Color(0xFF1976D2)]
              : [Colors.grey, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isActive ? const Color(0xFF2196F3) : Colors.grey)
                .withOpacity(0.3),
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
              isActive ? Icons.air_outlined : Icons.power_off,
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
                _buildStatusIndicator(isActive), // Kirim status
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
          // Indikator loading saat refresh
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
              color: isActive ? Colors.white : Colors.orange, // Sesuaikan warna
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'AKTIF' : 'NON-AKTIF', // Teks dinamis
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

  // Menggunakan data dinamis dari PengeringanSuhuData
  Widget _buildTempChartCard(PengeringanSuhuData suhuData) {
    final List<double> suhuList = suhuData.dataSuhu
        .map((e) => double.tryParse(e.toString()) ?? 0.0)
        .toList();
    final spots = _prepareChartSpots(suhuList);
    ;

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
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
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
                            '${value.toInt()}', // Sumbu X sebagai index
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
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}°C',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
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
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                // Sumbu X, Y dinamis
                maxX: spots.isNotEmpty ? (spots.length - 1).toDouble() : 0,
                minY: spots.isNotEmpty ? _getMinValue(suhuList) - 2 : 40,
                maxY: spots.isNotEmpty ? _getMaxValue(suhuList) + 2 : 60,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots, // Data dinamis
                    isCurved: true,
                    color: const Color(0xFF2196F3),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2196F3).withOpacity(0.3),
                          const Color(0xFF2196F3).withOpacity(0.0),
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

  // Menggunakan data dinamis dari PengeringanSuhuData
  Widget _buildHumidityChartCard(PengeringanSuhuData suhuData) {
    final List<double> kelembabanList = suhuData.dataKelembaban
        .map((e) => double.tryParse(e.toString()) ?? 0.0)
        .toList();
    final spots = _prepareChartSpots(kelembabanList);

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
            'Riwayat Kelembapan 30 Data Terakhir', // Judul disesuaikan
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
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [4],
                  ),
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
                            '${value.toInt()}', // Sumbu X sebagai index
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
                      interval: 10, // Sesuaikan interval
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
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
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                // Sumbu X, Y dinamis
                maxX: spots.isNotEmpty ? (spots.length - 1).toDouble() : 0,
                minY: spots.isNotEmpty ? _getMinValue(kelembabanList) - 5 : 40,
                maxY: spots.isNotEmpty ? _getMaxValue(kelembabanList) + 5 : 70,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots, // Data dinamis
                    isCurved: true,
                    color: Colors.teal, // Warna berbeda untuk kelembapan
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.withOpacity(0.3),
                          Colors.teal.withOpacity(0.0),
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

  // Sesuai permintaan: Bagian kontrol blower ini DUMMY
  // Menggunakan state lokal 'isBlowerOn'
  // Widget _buildBlowerControlCard() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: Colors.grey.shade200),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF2196F3).withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child:
  //                   const Icon(Icons.air, size: 20, color: Color(0xFF2196F3)),
  //             ),
  //             const SizedBox(width: 12),
  //             const Text(
  //               'Kontrol Blower',
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 16,
  //                 color: Colors.black87,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Status Blower',
  //                   style: TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontSize: 14,
  //                     color: Colors.grey.shade600,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   isBlowerOn ? 'MENYALA' : 'MATI',
  //                   style: TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w700,
  //                     color: isBlowerOn ? const Color(0xFF2196F3) : Colors.grey,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Switch(
  //               value: isBlowerOn,
  //               onChanged: (value) {
  //                 // Hanya update state lokal (dummy)
  //                 setState(() {
  //                   isBlowerOn = value;
  //                 });
  //               },
  //               activeColor: const Color(0xFF2196F3),
  //               activeTrackColor: const Color(0xFF2196F3).withOpacity(0.5),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.grey.shade50,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: Colors.grey.shade200),
  //           ),
  //           child: Row(
  //             children: [
  //               Icon(
  //                 Icons.info_outline,
  //                 color: Colors.blue.shade600,
  //                 size: 16,
  //               ),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: Text(
  //                   'Blower berfungsi untuk mengatur sirkulasi udara dalam ruang pengeringan',
  //                   style: TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontSize: 12,
  //                     color: Colors.grey.shade600,
  //                   ),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBlowerControlCard() {
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
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.air,
                  size: 20,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Kontrol Blower',
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

          // Grid untuk 8 blower
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kolom
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3, // Rasio lebar:tinggi
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              int blowerNumber = index + 1;
              bool isBlowerOn = _getBlowerStatus(
                blowerNumber,
              ); // Fungsi untuk mendapatkan status blower

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blower $blowerNumber',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isBlowerOn ? 'MENYALA' : 'MATI',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isBlowerOn
                                ? const Color(0xFF2196F3)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isBlowerOn,
                      onChanged: (value) {
                        _toggleBlower(
                          blowerNumber,
                          value,
                        ); // Fungsi untuk toggle blower
                      },
                      activeColor: const Color(0xFF2196F3),
                      activeTrackColor: const Color(
                        0xFF2196F3,
                      ).withOpacity(0.5),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Blower berfungsi untuk mengatur sirkulasi udara dalam ruang pengeringan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi helper untuk mendapatkan status blower
  bool _getBlowerStatus(int blowerNumber) {
    // Ganti dengan logika sesuai kebutuhan
    // Contoh: return _blowerStatusList[blowerNumber - 1];
    return _blowerStatusList[blowerNumber - 1];
  }

  // Fungsi untuk toggle blower
  void _toggleBlower(int blowerNumber, bool value) {
    setState(() {
      // Ganti dengan logika penyimpanan status blower
      // Contoh: _blowerStatusList[blowerNumber - 1] = value;
      _blowerStatusList[blowerNumber - 1] = value;
      // Jika ingin semua blower dikontrol oleh satu variabel saja:
      // isBlowerOn = value;
    });

    // Tambahkan logika untuk mengirim perintah ke hardware/API
    print('Blower $blowerNumber: ${value ? 'ON' : 'OFF'}');
  }

  List<bool> _blowerStatusList = List.generate(8, (index) => false);

  // Menggunakan data dinamis dari PengeringanData
  Widget _buildInfoCards(PengeringanData data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.thermostat,
                  title: 'Parameter Utama',
                  children: [
                    _infoRow(
                      'Suhu Rata-rata:',
                      '${data.suhuData.dataAvgSuhu}° C',
                    ),
                    _infoRow(
                      'Kelembapan Rata-rata:',
                      '${data.suhuData.dataAvgKelembaban}%',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.power_settings_new,
                  title: 'Status Operasional',
                  children: [
                    // Menggunakan data status ruangan dari blowerData
                    _buildOperationalStatus(data.blowerData.statusRuangan),
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
                  _infoRow(
                    'Suhu Rata-rata:',
                    '${data.suhuData.dataAvgSuhu}° C',
                  ),
                  _infoRow(
                    'Kelembapan Rata-rata:',
                    '${data.suhuData.dataAvgKelembaban}%',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.power_settings_new,
                title: 'Status Operasional',
                children: [
                  _buildOperationalStatus(data.blowerData.statusRuangan),
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
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF2196F3)),
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
        ],
      ),
    );
  }

  // Widget helper baru untuk status operasional
  Widget _buildOperationalStatus(int? statusRuangan) {
    final isActive = statusRuangan == 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue : Colors.grey,
            border: Border.all(
              color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
              width: 3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          isActive ? 'AKTIF' : 'NON-AKTIF',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.blue : Colors.grey,
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
              color: Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  // Sesuai permintaan: Bagian Event Log ini DUMMY
  // Menggunakan data hardcode dari _buildEventLogItems
  Widget _buildEventLogCard() {
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
              Icon(Icons.history, color: Color(0xFF2196F3)),
              SizedBox(width: 8),
              Text(
                'Event Log',
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
          ..._buildEventLogItems(),
        ],
      ),
    );
  }

  // Data DUMMY
  List<Widget> _buildEventLogItems() {
    final events = [
      {
        'time': '11:45',
        'event':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'duration': '05:30:00',
      },
      {
        'time': '10:20',
        'event':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'duration': '06:55:15',
      },
      {
        'time': '09:15',
        'event':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'duration': '08:00:45',
      },
      {
        'time': '08:00',
        'event':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'duration': '09:15:30',
      },
    ];

    return events
        .map(
          (event) =>
              _eventLogRow(event['event']!, event['duration']!, event['time']!),
        )
        .toList();
  }

  // Data DUMMY
  Widget _eventLogRow(String event, String duration, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: const Color(0xFF2196F3).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.circle, color: Color(0xFF2196F3), size: 8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      duration,
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

  // --- FUNGSI HELPER UNTUK GRAFIK ---

  List<FlSpot> _prepareChartSpots(List<double> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
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
}
