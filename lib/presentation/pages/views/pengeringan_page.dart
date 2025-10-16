// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class PengeringanPage extends StatelessWidget {
//   const PengeringanPage({super.key});

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
//           Text(
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
//                 maxY: 60,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 42),
//                       FlSpot(1, 44),
//                       FlSpot(2, 45),
//                       FlSpot(3, 43),
//                       FlSpot(4, 46),
//                       FlSpot(5, 45),
//                       FlSpot(6, 45),
//                     ],
//                     isCurved: true,
//                     color: const Color(0xFF2196F3),
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         return FlDotCirclePainter(
//                           radius: 4,
//                           color: Colors.white,
//                           strokeWidth: 2,
//                           strokeColor: Color(0xFF2196F3),
//                         );
//                       },
//                     ),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF2196F3).withOpacity(0.3),
//                           const Color(0xFF2196F3).withOpacity(0.1),
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
//                             border: Border.all(color: Colors.blue.shade700, width: 3),
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
//                           border: Border.all(color: Colors.blue.shade700, width: 3),
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
//       {'time': '11:45', 'event': 'Monitoring kelembapan stabil di 55%', 'duration': '05:30:00'},
//       {'time': '10:20', 'event': 'Penyesuaian suhu ke 45°C', 'duration': '06:55:15'},
//       {'time': '09:15', 'event': 'Proses pengeringan batch #0236 dimulai', 'duration': '08:00:45'},
//       {'time': '08:00', 'event': 'Quality check passed - ready for drying', 'duration': '09:15:30'},
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
//               color: const Color(0xFF2196F3).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.circle,
//               color: const Color(0xFF2196F3),
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
import 'package:fl_chart/fl_chart.dart';

class PengeringanPage extends StatefulWidget {
  const PengeringanPage({super.key});

  @override
  State<PengeringanPage> createState() => _PengeringanPageState();
}

class _PengeringanPageState extends State<PengeringanPage> {
  bool isBlowerOn = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 20),
          _buildBlowerControlCard(),
          const SizedBox(height: 20),
          _buildChartCard(),
          const SizedBox(height: 20),
          _buildInfoCards(),
          const SizedBox(height: 20),
          _buildEventLogCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
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
            child: const Icon(
              Icons.air_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Pengeringan Aktif',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusIndicator(),
                const SizedBox(height: 6),
                Text(
                  'Proses pengeringan mencapai tahap akhir',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
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
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'AKTIF',
            style: TextStyle(
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

  Widget _buildChartCard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Suhu 7 Hari Terakhir',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
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
                  verticalInterval: 1,
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
                      getTitlesWidget: (value, meta) {
                        final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            days[value.toInt()],
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
                maxX: 6,
                minY: 0,
                maxY: 60,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 42),
                      FlSpot(1, 44),
                      FlSpot(2, 45),
                      FlSpot(3, 43),
                      FlSpot(4, 46),
                      FlSpot(5, 45),
                      FlSpot(6, 45),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2196F3),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Color(0xFF2196F3),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2196F3).withOpacity(0.3),
                          const Color(0xFF2196F3).withOpacity(0.1),
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

  Widget _buildInfoCards() {
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
                    _infoRow('Suhu Rata-rata:', '45° C'),
                    _infoRow('Kelembapan:', '55%'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.power_settings_new,
                  title: 'Status Operasional',
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.blue.shade700, width: 3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'AKTIF',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
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
                  _infoRow('Suhu Rata-rata:', '45° C'),
                  _infoRow('Kelembapan:', '55%'),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.power_settings_new,
                title: 'Status Operasional',
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                          border: Border.all(color: Colors.blue.shade700, width: 3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'AKTIF',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        }
      },
    );
  }

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
                child: const Icon(Icons.air, size: 20, color: Color(0xFF2196F3)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Blower',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isBlowerOn ? 'MENYALA' : 'MATI',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isBlowerOn ? const Color(0xFF2196F3) : Colors.grey,
                    ),
                  ),
                ],
              ),
              Switch(
                value: isBlowerOn,
                onChanged: (value) {
                  setState(() {
                    isBlowerOn = value;
                  });
                },
                activeColor: const Color(0xFF2196F3),
                activeTrackColor: const Color(0xFF2196F3).withOpacity(0.5),
              ),
            ],
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
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade600,
                  size: 16,
                ),
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

  List<Widget> _buildEventLogItems() {
    final events = [
      {'time': '11:45', 'event': 'Monitoring kelembapan stabil di 55%', 'duration': '05:30:00'},
      {'time': '10:20', 'event': 'Penyesuaian suhu ke 45°C', 'duration': '06:55:15'},
      {'time': '09:15', 'event': 'Proses pengeringan batch #0236 dimulai', 'duration': '08:00:45'},
      {'time': '08:00', 'event': 'Quality check passed - ready for drying', 'duration': '09:15:30'},
    ];

    return events.map((event) => _eventLogRow(event['event']!, event['duration']!, event['time']!)).toList();
  }

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
            child: Icon(
              Icons.circle,
              color: const Color(0xFF2196F3),
              size: 8,
            ),
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
}