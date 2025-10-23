// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class FermentasiPage extends StatelessWidget {
//   const FermentasiPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           _buildHeaderCard(),
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
//           colors: [Color(0xFFFFC107), Color(0xFFFFA000)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFFFC107).withOpacity(0.3),
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
//               Icons.science_outlined,
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
//                   'Status Fermentasi Optimal',
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
//                   'Proses fermentasi berjalan sesuai tahapan',
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
//             'OPTIMAL',
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
//             'Riwayat Suhu 30 Data Terakhir', // <-- Judul diubah
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
//                   horizontalInterval: 2,
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
//                   rightTitles:
//                       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles:
//                       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(color: Colors.grey.shade300)),
//                 minX: 0,
//                 maxX: 23,
//                 minY: 25,
//                 maxY: 40,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 32), FlSpot(2, 32.5), FlSpot(4, 33),
//                       FlSpot(6, 33.2), FlSpot(8, 34), FlSpot(10, 33.5),
//                       FlSpot(12, 33), FlSpot(14, 32.8), FlSpot(16, 32.5),
//                       FlSpot(18, 32), FlSpot(20, 31.5), FlSpot(23, 31),
//                     ],
//                     isCurved: true,
//                     color: const Color(0xFFFFC107),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFFFFC107).withOpacity(0.3),
//                           const Color(0xFFFFC107).withOpacity(0.0),
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
//             'Riwayat Kelembapan 30 Data Terakhir',
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
//                   rightTitles:
//                       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles:
//                       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(color: Colors.grey.shade300)),
//                 minX: 0,
//                 maxX: 23,
//                 minY: 70,
//                 maxY: 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 85), FlSpot(2, 86), FlSpot(4, 88),
//                       FlSpot(6, 89), FlSpot(8, 88), FlSpot(10, 86),
//                       FlSpot(12, 85), FlSpot(14, 84), FlSpot(16, 85),
//                       FlSpot(18, 86), FlSpot(20, 87), FlSpot(23, 86),
//                     ],
//                     isCurved: true,
//                     color: Colors.blueAccent, // Warna berbeda untuk kelembapan
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.blueAccent.withOpacity(0.3),
//                           Colors.blueAccent.withOpacity(0.0),
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
//                     _infoRow('Suhu Rata-rata:', '32° C'),
//                     _infoRow('Kelembapan:', '85%'),
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
//                             color: Colors.orange,
//                             border:
//                                 Border.all(color: Colors.orange.shade700, width: 3),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'AKTIF',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange,
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
//                   _infoRow('Suhu Rata-rata:', '32° C'),
//                   _infoRow('Kelembapan:', '85%'),
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
//                           color: Colors.orange,
//                           border:
//                               Border.all(color: Colors.orange.shade700, width: 3),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'AKTIF',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.orange,
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
//                   color: const Color(0xFFFFC107).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 20, color: const Color(0xFFFFC107)),
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
//               color: Color(0xFFFFC107),
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
//               Icon(Icons.history, color: Color(0xFFFFC107)),
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
//       {'time': '10:30', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','duration': '08:15:00'},
//       {'time': '09:45', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'duration': '09:00:15'},
//       {'time': '08:30', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'duration': '10:30:45'},
//       {'time': '07:15', 'event': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'duration': '11:45:30'},
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
//               color: const Color(0xFFFFC107).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.circle,
//               color: Color(0xFFFFC107),
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
// import 'package:iotmcc_mobile/presentation/providers/fermentasi_provider.dart';
// import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
// import 'package:iotmcc_mobile/data/models/fermentasi_model.dart';

// class FermentasiPage extends StatefulWidget {
//   const FermentasiPage({super.key});

//   @override
//   State<FermentasiPage> createState() => _FermentasiPageState();
// }

// class _FermentasiPageState extends State<FermentasiPage> {
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
//     await gudangProvider.loadGudangList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<GudangProvider, FermentasiProvider>(
//       builder: (context, gudangProvider, fermentasiProvider, child) {
//         final data = fermentasiProvider.data;
//         final activeId = gudangProvider.activeGudangId;
        
//         if (activeId != null && activeId != _lastLoadedGudangId) {
//           _lastLoadedGudangId = activeId; 
          
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             fermentasiProvider.fetchData(activeId);
//           });
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               if (gudangProvider.activeGudangId == null) 
//                 _buildNoActiveGudangWidget(gudangProvider),
              
//               if (gudangProvider.activeGudangId != null) ...[
//                 _buildHeaderCard(data, fermentasiProvider),
//                 const SizedBox(height: 20),
                
//                 if (fermentasiProvider.isLoading && data == null) 
//                   _buildLoadingIndicator(),
                
//                 if (fermentasiProvider.errorMessage.isNotEmpty && data == null) 
//                   _buildErrorWidget(fermentasiProvider),
                
//                 if (data != null) ...[
//                   _buildTempChartCard(data),
//                   const SizedBox(height: 20),
//                   _buildHumidityChartCard(data),
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
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Memuat data fermentasi...',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorWidget(FermentasiProvider provider) {
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

//   Widget _buildHeaderCard(FermentasiData? data, FermentasiProvider provider) {
//     final isActive = data?.statusRuangan == 1;
//     final statusText = isActive ? 'Status Fermentasi Optimal' : 'Status Fermentasi Non-Aktif';
//     final statusDescription = isActive
//         ? 'Proses fermentasi berjalan sesuai tahapan'
//         : 'Ruangan fermentasi sedang tidak aktif';

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isActive
//               ? [const Color(0xFFFFC107), const Color(0xFFFFA000)]
//               : [Colors.grey, Colors.grey.shade700],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: (isActive ? const Color(0xFFFFC107) : Colors.grey).withOpacity(0.3),
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
//               isActive ? Icons.science_outlined : Icons.power_off,
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
//             isActive ? 'OPTIMAL' : 'NON-AKTIF',
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

//   Widget _buildTempChartCard(FermentasiData data) {
//     final spots = _prepareChartSpots(data.dataSuhu);

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
//                 minY: data.dataSuhu.isNotEmpty ? _getMinValue(data.dataSuhu) - 2 : 0,
//                 maxY: data.dataSuhu.isNotEmpty ? _getMaxValue(data.dataSuhu) + 2 : 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: const Color(0xFFFFC107),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFFFFC107).withOpacity(0.3),
//                           const Color(0xFFFFC107).withOpacity(0.0),
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

//   Widget _buildHumidityChartCard(FermentasiData data) {
//     final spots = _prepareChartSpots(data.dataKelembaban);

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
//             'Riwayat Kelembaban 30 Data Terakhir',
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
//                   verticalInterval: 10,
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
//                       interval: 10,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()}%',
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
//                 maxX: data.dataKelembaban.isNotEmpty
//                     ? (data.dataKelembaban.length - 1).toDouble()
//                     : 0,
//                 minY: data.dataKelembaban.isNotEmpty ? _getMinValue(data.dataKelembaban) - 5 : 0,
//                 maxY: data.dataKelembaban.isNotEmpty ? _getMaxValue(data.dataKelembaban) + 5 : 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: Colors.blueAccent,
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.blueAccent.withOpacity(0.3),
//                           Colors.blueAccent.withOpacity(0.0),
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

//   List<FlSpot> _prepareChartSpots(List<double> data) {
//     List<FlSpot> spots = [];
//     for (int i = 0; i < data.length; i++) {
//       spots.add(FlSpot(i.toDouble(), data[i]));
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

//   Widget _buildInfoCards(FermentasiData data) {
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
//                     _infoRow('Kelembaban Rata-rata:', '${data.dataAvgKelembaban}%'),
//                     if (data.dataTimer != null) 
//                       _infoRow('Timer:', data.dataTimer!),
//                   ],
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
//                   _infoRow('Kelembaban Rata-rata:', '${data.dataAvgKelembaban}%'),
//                   if (data.dataTimer != null) 
//                     _infoRow('Timer:', data.dataTimer!),
//                 ],
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
//                   color: const Color(0xFFFFC107).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 20, color: const Color(0xFFFFC107)),
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

//   Widget _buildOperationalStatus(int? statusRuangan) {
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
//               color: Color(0xFFFFC107),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventLogCard(FermentasiData data) {
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
//               Icon(Icons.history, color: Color(0xFFFFC107)),
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

//   List<Widget> _buildSensorDataItems(FermentasiData data) {
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
//       final kelembaban = i < data.dataKelembaban.length ? data.dataKelembaban[i] : 0.0;
//       final waktuSuhu = i < data.dataWaktuSuhu.length ? data.dataWaktuSuhu[i] : '--:--:--';
//       final waktuKelembaban = i < data.dataWaktuKelembaban.length ? data.dataWaktuKelembaban[i] : '--:--:--';

//       items.add(_sensorDataRow(suhu, kelembaban, waktuSuhu, waktuKelembaban));
//       if (i < itemCount - 1 && i < 3) {
//         items.add(const SizedBox(height: 8));
//       }
//     }

//     return items;
//   }

//   Widget _sensorDataRow(double suhu, double kelembaban, String waktuSuhu, String waktuKelembaban) {
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
//               color: const Color(0xFFFFC107).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.sensors,
//               color: Color(0xFFFFC107),
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
//                     Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       waktuSuhu,
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       waktuKelembaban,
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
import 'package:iotmcc_mobile/presentation/providers/fermentasi_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/data/models/fermentasi_model.dart';

class FermentasiPage extends StatefulWidget {
  const FermentasiPage({super.key});

  @override
  State<FermentasiPage> createState() => _FermentasiPageState();
}

class _FermentasiPageState extends State<FermentasiPage> {
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
    // Cukup panggil loadGudangList. fetchData fermentasi akan dipicu oleh Consumer
    await gudangProvider.loadGudangList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GudangProvider, FermentasiProvider>(
      builder: (context, gudangProvider, fermentasiProvider, child) {
        // Ambil data mentah (untuk cek null) dan data yang sudah diformat dari provider
        final data = fermentasiProvider.data;
        final activeId = gudangProvider.activeGudangId;

        // Logika untuk memuat data fermentasi ketika gudang aktif berubah
        if (activeId != null && activeId != _lastLoadedGudangId) {
          _lastLoadedGudangId = activeId;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            fermentasiProvider.fetchData(activeId);
          });
        }

        // Ambil data yang sudah diformat dari provider
        final dataSuhu = fermentasiProvider.dataSuhu;
        final dataKelembaban = fermentasiProvider.dataKelembaban;
        final dataWaktuSuhu = fermentasiProvider.dataWaktuSuhu;
        final dataWaktuKelembaban = fermentasiProvider.dataWaktuKelembaban;
        final dataAvgSuhu = fermentasiProvider.dataAvgSuhu;
        final dataAvgKelembaban = fermentasiProvider.dataAvgKelembaban;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Tampilkan jika tidak ada gudang aktif
              if (gudangProvider.activeGudangId == null)
                _buildNoActiveGudangWidget(gudangProvider),

              // Tampilkan jika ada gudang aktif
              if (gudangProvider.activeGudangId != null) ...[
                _buildHeaderCard(data, fermentasiProvider),
                const SizedBox(height: 20),

                // Tampilkan loading indicator HANYA jika data belum ada sama sekali
                if (fermentasiProvider.isLoading && data == null)
                  _buildLoadingIndicator(),

                // Tampilkan error HANYA jika data belum ada sama sekali
                if (fermentasiProvider.errorMessage.isNotEmpty && data == null)
                  _buildErrorWidget(fermentasiProvider),

                // Tampilkan konten utama jika data SUDAH tersedia
                if (data != null) ...[
                  _buildTempChartCard(dataSuhu), // PERBAIKAN
                  const SizedBox(height: 20),
                  _buildHumidityChartCard(dataKelembaban), // PERBAIKAN
                  const SizedBox(height: 20),
                  _buildInfoCards(
                    // PERBAIKAN
                    data.statusRuangan,
                    dataAvgSuhu,
                    dataAvgKelembaban,
                  ),
                  const SizedBox(height: 20),
                  _buildEventLogCard(
                    // PERBAIKAN
                    dataSuhu,
                    dataKelembaban,
                    dataWaktuSuhu,
                    dataWaktuKelembaban,
                  ),
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data fermentasi...',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(FermentasiProvider provider) {
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
                _lastLoadedGudangId = null; // Paksa refresh
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

  Widget _buildHeaderCard(FermentasiData? data, FermentasiProvider provider) {
    // Gunakan data?.statusRuangan, default ke non-aktif (0) jika data null
    final isActive = data?.statusRuangan == 1;
    final statusText =
        isActive ? 'Status Fermentasi Optimal' : 'Status Fermentasi Non-Aktif';
    final statusDescription = isActive
        ? 'Proses fermentasi berjalan sesuai tahapan'
        : 'Ruangan fermentasi sedang tidak aktif';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFFFFC107), const Color(0xFFFFA000)]
              : [Colors.grey, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                (isActive ? const Color(0xFFFFC107) : Colors.grey).withOpacity(0.3),
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
              isActive ? Icons.science_outlined : Icons.power_off,
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
          // Tampilkan loading spinner kecil jika sedang refresh data
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
            isActive ? 'OPTIMAL' : 'NON-AKTIF',
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

  // PERBAIKAN: Menerima List<double> dataSuhu
  Widget _buildTempChartCard(List<double> dataSuhu) {
    final spots = _prepareChartSpots(dataSuhu);

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
                // PERBAIKAN: Gunakan dataSuhu
                maxX: dataSuhu.isNotEmpty
                    ? (dataSuhu.length - 1).toDouble()
                    : 0,
                minY: dataSuhu.isNotEmpty ? _getMinValue(dataSuhu) - 2 : 0,
                maxY: dataSuhu.isNotEmpty ? _getMaxValue(dataSuhu) + 2 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFFFFC107),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFC107).withOpacity(0.3),
                          const Color(0xFFFFC107).withOpacity(0.0),
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

  // PERBAIKAN: Menerima List<double> dataKelembaban
  Widget _buildHumidityChartCard(List<double> dataKelembaban) {
    final spots = _prepareChartSpots(dataKelembaban);

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
            'Riwayat Kelembaban 30 Data Terakhir',
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
                  verticalInterval: 10,
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
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
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
                // PERBAIKAN: Gunakan dataKelembaban
                maxX: dataKelembaban.isNotEmpty
                    ? (dataKelembaban.length - 1).toDouble()
                    : 0,
                minY: dataKelembaban.isNotEmpty
                    ? _getMinValue(dataKelembaban) - 5
                    : 0,
                maxY: dataKelembaban.isNotEmpty
                    ? _getMaxValue(dataKelembaban) + 5
                    : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.3),
                          Colors.blueAccent.withOpacity(0.0),
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

  // PERBAIKAN: Menerima data yang sudah di-format
  Widget _buildInfoCards(
    int? statusRuangan,
    String dataAvgSuhu,
    String dataAvgKelembaban,
  ) {
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
                    _infoRow('Suhu Rata-rata:', '$dataAvgSuhu° C'),
                    _infoRow('Kelembaban Rata-rata:', '$dataAvgKelembaban%'),
                    // PERBAIKAN: Timer dihapus karena tidak ada di API/Model baru
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.power_settings_new,
                  title: 'Status Operasional',
                  children: [
                    _buildOperationalStatus(statusRuangan),
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
                  _infoRow('Suhu Rata-rata:', '$dataAvgSuhu° C'),
                  _infoRow('Kelembaban Rata-rata:', '$dataAvgKelembaban%'),
                  // PERBAIKAN: Timer dihapus
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.power_settings_new,
                title: 'Status Operasional',
                children: [
                  _buildOperationalStatus(statusRuangan),
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
                  color: const Color(0xFFFFC107).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFFFFC107)),
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
              color: Color(0xFFFFC107),
            ),
          ),
        ],
      ),
    );
  }

  // PERBAIKAN: Menerima list data yang sudah di-format
  Widget _buildEventLogCard(
    List<double> dataSuhu,
    List<double> dataKelembaban,
    List<String> dataWaktuSuhu,
    List<String> dataWaktuKelembaban,
  ) {
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
              Icon(Icons.history, color: Color(0xFFFFC107)),
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
          ..._buildSensorDataItems(
            dataSuhu,
            dataKelembaban,
            dataWaktuSuhu,
            dataWaktuKelembaban,
          ),
        ],
      ),
    );
  }

  // PERBAIKAN: Menerima list data yang sudah di-format
  List<Widget> _buildSensorDataItems(
    List<double> dataSuhu,
    List<double> dataKelembaban,
    List<String> dataWaktuSuhu,
    List<String> dataWaktuKelembaban,
  ) {
    if (dataSuhu.isEmpty && dataKelembaban.isEmpty) {
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
    // Tampilkan data berdasarkan jumlah data suhu (asumsi suhu dan kelembaban punya jumlah data yang sama)
    int itemCount = dataSuhu.length;

    // Tampilkan maksimal 4 data terbaru
    for (int i = 0; i < itemCount && i < 4; i++) {
      final suhu = i < dataSuhu.length ? dataSuhu[i] : 0.0;
      final kelembaban =
          i < dataKelembaban.length ? dataKelembaban[i] : 0.0;
      final waktuSuhu =
          i < dataWaktuSuhu.length ? dataWaktuSuhu[i] : '--:--:--';
      final waktuKelembaban = i < dataWaktuKelembaban.length
          ? dataWaktuKelembaban[i]
          : '--:--:--';

      items.add(_sensorDataRow(suhu, kelembaban, waktuSuhu, waktuKelembaban));
      if (i < itemCount - 1 && i < 3) {
        items.add(const SizedBox(height: 8));
      }
    }

    return items;
  }

  Widget _sensorDataRow(
      double suhu, double kelembaban, String waktuSuhu, String waktuKelembaban) {
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
              color: const Color(0xFFFFC107).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sensors,
              color: Color(0xFFFFC107),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      'Kelembaban: ${kelembaban.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      waktuSuhu, // Asumsi waktu suhu dan kelembaban sama
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Hapus duplikasi waktu jika sama
                    if (waktuSuhu != waktuKelembaban) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        waktuKelembaban,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]
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
