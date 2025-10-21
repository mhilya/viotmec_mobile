import 'package:flutter/foundation.dart';

// Model untuk menampung semua data di halaman pengeringan
class PengeringanData {
  final PengeringanSuhuData suhuData;
  final PengeringanBlowerData blowerData;

  PengeringanData({
    required this.suhuData,
    required this.blowerData,
  });
}


// Model untuk data dari endpoint getDataSuhu
class PengeringanSuhuData {
  final List<dynamic> dataSuhu;
  final List<dynamic> dataKelembaban;
  final List<dynamic> dataWaktuSuhu;
  final List<dynamic> dataWaktuKelembaban;
  final String dataAvgSuhu;
  final String dataAvgKelembaban;

  PengeringanSuhuData({
    required this.dataSuhu,
    required this.dataKelembaban,
    required this.dataWaktuSuhu,
    required this.dataWaktuKelembaban,
    required this.dataAvgSuhu,
    required this.dataAvgKelembaban,
  });

  factory PengeringanSuhuData.fromJson(Map<String, dynamic> json) {
    return PengeringanSuhuData(
      dataSuhu: json['dataSuhu'] as List<dynamic>,
      dataKelembaban: json['dataKelembaban'] as List<dynamic>,
      dataWaktuSuhu: json['dataWaktuSuhu'] as List<dynamic>,
      dataWaktuKelembaban: json['dataWaktuKelembaban'] as List<dynamic>,
      dataAvgSuhu: json['dataAvgSuhu'].toString(),
      dataAvgKelembaban: json['dataAvgKelembaban'].toString(),
    );
  }
}

// Model untuk data dari endpoint getDataBlower 0
class PengeringanBlowerData {
  final int statusRuangan;
  final int statusBlower;
  final int durasiAktif;
  final List<dynamic> dataBlower;
  final List<dynamic> dataWaktuBlower;

  PengeringanBlowerData({
    required this.statusRuangan,
    required this.statusBlower,
    required this.durasiAktif,
    required this.dataBlower,
    required this.dataWaktuBlower,
  });

  factory PengeringanBlowerData.fromJson(Map<String, dynamic> json) {
    return PengeringanBlowerData(
      statusRuangan: json['statusRuangan'] as int,
      statusBlower: json['statusBlower'] as int,
      durasiAktif: json['durasiAktif'] as int,
      dataBlower: json['dataBlower'] as List<dynamic>,
      dataWaktuBlower: json['dataWaktuBlower'] as List<dynamic>,
    );
  }

  PengeringanBlowerData copyWith({
    int? statusRuangan,
    int? statusBlower,
    int? durasiAktif,
    List<dynamic>? dataBlower,
    List<dynamic>? dataWaktuBlower,
  }) {
    return PengeringanBlowerData(
      statusRuangan: statusRuangan ?? this.statusRuangan,
      statusBlower: statusBlower ?? this.statusBlower,
      durasiAktif: durasiAktif ?? this.durasiAktif,
      dataBlower: dataBlower ?? this.dataBlower,
      dataWaktuBlower: dataWaktuBlower ?? this.dataWaktuBlower,
    );
  }
}
