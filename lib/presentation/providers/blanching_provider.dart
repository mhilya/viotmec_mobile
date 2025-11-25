// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:viotmec_mobile/data/models/blanching_model.dart';
// import 'package:viotmec_mobile/data/repositories/blanching_repository.dart';

// class BlanchingProvider extends ChangeNotifier {
//   final BlanchingRepository _repository;

//   BlanchingProvider(this._repository);

//   BlanchingData? _blanchingData;
//   TimerResponse? _timerResponse;
//   bool _isLoading = false;
//   String? _error;

//   Timer? _localTicker;
//   // Variabel untuk menyimpan kapan timer lokal harus berhenti (berdasarkan jam HP sendiri)
//   DateTime? _localTargetTime;

//   BlanchingData? get blanchingData => _blanchingData;
//   TimerResponse? get timerResponse => _timerResponse;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   Future<void> fetchData(String gudangId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       await Future.wait([
//         fetchSensorData(gudangId),
//         fetchTimerData(gudangId),
//       ]);
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshDataBackground(String gudangId) async {
//     try {
//       await fetchSensorData(gudangId);
//       // Kirim flag isBackground: true
//       await fetchTimerData(gudangId, isBackground: true);
//     } catch (e) {
//       debugPrint('Background refresh error: $e');
//     }
//   }

//   Future<void> fetchSensorData(String gudangId) async {
//     try {
//       final data = await _repository.getBlanchingData(gudangId);
//       _blanchingData = data;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error fetching sensor data: $e');
//     }
//   }

//   Future<void> fetchTimerData(String gudangId, {bool isBackground = false}) async {
//     try {
//       final newData = await _repository.getTimerData(gudangId);

//       // 1. Cari Timer yang sedang aktif di data baru (Server)
//       final serverTimer = newData.getTimerByFlag('timer_1');
//       final bool serverIsRunning = serverTimer?.isRunning ?? false;
//       final double serverSisa = serverTimer?.sisaTimer ?? 0.0;

//       // 2. Cek status timer lokal saat ini
//       bool localIsRunning = _localTicker != null && _localTicker!.isActive;

//       // --- LOGIKA PENTING (THE FIX) ---

//       if (serverIsRunning) {
//         // KASUS A: Server bilang "START"

//         if (!localIsRunning || _localTargetTime == null) {

//           _localTargetTime = DateTime.now().add(Duration(seconds: serverSisa.toInt()));
//           _startLocalTicker(gudangId);
//         }
//         else if (isBackground && _localTargetTime != null) {
//           // KASUS B: Lokal sedang jalan, dan ini update background
//           // Kita cek selisih hitungan lokal vs server

//           final secondsLeftLocal = _localTargetTime!.difference(DateTime.now()).inSeconds;
//           final diff = (secondsLeftLocal - serverSisa).abs();

//           // Jika selisihnya KECIL (< 10 detik), BERARTI SINKRON.
//           // JANGAN update data timerResponse dengan data server.
//           // Biarkan timer lokal lanjut menghitung agar tidak lompat.
//           if (diff < 10) {
//              // Kita update status lain, tapi pertahankan sisaTimer lokal
//              if (_timerResponse != null) {
//                final oldTimer = _timerResponse!.getTimerByFlag('timer_1');
//                if (oldTimer != null) serverTimer!.sisaTimer = oldTimer.sisaTimer;
//              }
//           } else {
//             // Jika selisih BESAR (> 10 detik), berarti ada reset di server.
//             // Kita ikut server (Reset Lokal).
//              _localTargetTime = DateTime.now().add(Duration(seconds: serverSisa.toInt()));
//           }
//         }
//       } else {
//         // KASUS C: Server bilang "STOP"
//         // Matikan lokal segera
//         _localTicker?.cancel();
//         _localTargetTime = null;
//         _localTicker = null;
//       }

//       // Simpan data baru
//       _timerResponse = newData;
//       notifyListeners();

//     } catch (e) {
//       debugPrint('Error fetching timer data: $e');
//     }
//   }

//   void _startLocalTicker(String gudangId) {
//     // Cegah double ticker
//     if (_localTicker != null && _localTicker!.isActive) return;

//     _localTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
//       // Safety check
//       if (_timerResponse == null || _localTargetTime == null) {
//         timer.cancel();
//         return;
//       }

//       final activeTimer = _timerResponse!.getTimerByFlag('timer_1');

//       // Jika data hilang atau status berubah jadi stop
//       if (activeTimer == null || !activeTimer.isRunning) {
//         timer.cancel();
//         _localTargetTime = null;
//         notifyListeners();
//         return;
//       }

//       // Hitung sisa waktu: Target Lokal - Jam Sekarang
//       final now = DateTime.now();
//       final remainingSeconds = _localTargetTime!.difference(now).inSeconds;

//       if (remainingSeconds > 0) {
//         // Update UI
//         activeTimer.sisaTimer = remainingSeconds.toDouble();
//         notifyListeners();
//       } else {
//         // Waktu Habis
//         activeTimer.sisaTimer = 0.0;
//         notifyListeners();

//         timer.cancel();
//         _localTargetTime = null;
//         _localTicker = null;

//         // Validasi terakhir ke server
//         fetchTimerData(gudangId);
//       }
//     });
//   }

//   Future<bool> toggleTimer(String gudangId) async {
//     try {
//       await _repository.toggleTimer(gudangId);
//       // Reset total saat tombol ditekan
//       _localTicker?.cancel();
//       _localTicker = null;
//       _localTargetTime = null;

//       await fetchTimerData(gudangId);
//       return true;
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<bool> setLimitTimer(String gudangId, int limit, String flagSensor) async {
//     try {
//       final success = await _repository.setLimitTimer(gudangId, limit, flagSensor);
//       if (success) {
//         _localTicker?.cancel();
//         _localTicker = null;
//         _localTargetTime = null;
//         await fetchTimerData(gudangId);
//       }
//       return success;
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       notifyListeners();
//       return false;
//     }
//   }

//   @override
//   void dispose() {
//     _localTicker?.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:viotmec_mobile/data/models/blanching_model.dart';
import 'package:viotmec_mobile/data/repositories/blanching_repository.dart';

class BlanchingProvider extends ChangeNotifier {
  final BlanchingRepository _repository;

  BlanchingProvider(this._repository);

  BlanchingData? _data;
  TimerResponse? _timerResponse;
  bool _isLoading = false;
  String _errorMessage = '';

  Timer? _localTicker;
  DateTime? _localTargetTime;

  BlanchingData? get data => _data;
  TimerResponse? get timerResponse => _timerResponse;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  double get rataRataSuhu => _data?.rataRataSuhu ?? 0.0;
  String get statusRuangan => _data?.statusRuangan ?? '0';

  double get latestSuhu1 =>
      _data?.getSensorByFlag('suhu_1')?.latestValue ?? 0.0;
  double get avgSuhu1 => _data?.getSensorByFlag('suhu_1')?.avg ?? 0.0;

  List<StdDevData> get stddevSuhu1 =>
      _data?.getSensorByFlag('suhu_1')?.stddev ?? [];
  List<List<dynamic>> get stddevSuhu1AsList =>
      stddevSuhu1.map((stddev) => stddev.toList()).toList();

  List<Map<String, dynamic>> get chartDataSensor1 {
    final chartData = _data?.getChartData();
    return chartData?['sensor1'] ?? [];
  }

  List<Map<String, dynamic>> get chartDataSensor11Jam =>
      _getData1Jam(chartDataSensor1);

  List<Map<String, dynamic>> _getData1Jam(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return [];
    final now = DateTime.now();
    final satuJamLalu = now.subtract(const Duration(hours: 1));
    return data.where((item) {
      final waktuData = _parseTimeString(item['waktu']?.toString() ?? '');
      return waktuData != null && waktuData.isAfter(satuJamLalu);
    }).toList();
  }

  List<String> referenceList(
    List<Map<String, dynamic>> sensor1Data,
    List<Map<String, dynamic>> sensor2Data,
  ) {
    return sensor1Data.length >= sensor2Data.length
        ? getWaktuValues(sensor1Data)
        : getWaktuValues(sensor2Data);
  }

  DateTime? _parseTimeString(String timeStr) {
    try {
      final now = DateTime.now();
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    } catch (e) {
      debugPrint('Error parsing time: $timeStr, error: $e');
    }
    return null;
  }

  List<double> getSuhuValues(List<Map<String, dynamic>> chartData) {
    return chartData.map((item) => (item['suhu'] as double? ?? 0.0)).toList();
  }

  List<String> getWaktuValues(List<Map<String, dynamic>> chartData) {
    return chartData.map((item) => (item['waktu']?.toString() ?? '')).toList();
  }

  SensorData? getSensorData(String flag) => _data?.getSensorByFlag(flag);
  WaktuSensor? getWaktuData(String flag) => _data?.getTimeByFlag(flag);

  bool get hasData => _data != null;
  bool get hasChartData => chartDataSensor1.isNotEmpty;

  Future<void> fetchData(String gudangId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await Future.wait([fetchSensorData(gudangId), fetchTimerData(gudangId)]);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDataBackground(String gudangId) async {
    try {
      await fetchSensorData(gudangId);
      await fetchTimerData(gudangId, isBackground: true);
    } catch (e) {
      debugPrint('Background refresh error: $e');
    }
  }

  Future<void> fetchSensorData(String gudangId) async {
    try {
      final data = await _repository.getBlanchingData(gudangId);
      _data = data;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching sensor data: $e');
    }
  }

  void clearData() {
    _data = null;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> fetchTimerData(
    String gudangId, {
    bool isBackground = false,
  }) async {
    try {
      final newData = await _repository.getTimerData(gudangId);

      final serverTimer = newData.getTimerByFlag('timer_1');
      final bool serverIsRunning = serverTimer?.isRunning ?? false;
      final double serverSisa = serverTimer?.sisaTimer ?? 0.0;

      bool localIsRunning = _localTicker != null && _localTicker!.isActive;

      if (serverIsRunning) {
        if (!localIsRunning || _localTargetTime == null) {
          _localTargetTime = DateTime.now().add(
            Duration(seconds: serverSisa.toInt()),
          );
          _startLocalTicker(gudangId);
        } else if (isBackground && _localTargetTime != null) {
          final secondsLeftLocal = _localTargetTime!
              .difference(DateTime.now())
              .inSeconds;
          final diff = (secondsLeftLocal - serverSisa).abs();

          if (diff < 10) {
            if (_timerResponse != null) {
              final oldTimer = _timerResponse!.getTimerByFlag('timer_1');
              if (oldTimer != null) serverTimer!.sisaTimer = oldTimer.sisaTimer;
            }
          } else {
            _localTargetTime = DateTime.now().add(
              Duration(seconds: serverSisa.toInt()),
            );
          }
        }
      } else {
        _localTicker?.cancel();
        _localTargetTime = null;
        _localTicker = null;
      }

      _timerResponse = newData;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching timer data: $e');
    }
  }

  void _startLocalTicker(String gudangId) {
    if (_localTicker != null && _localTicker!.isActive) return;

    _localTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerResponse == null || _localTargetTime == null) {
        timer.cancel();
        return;
      }

      final activeTimer = _timerResponse!.getTimerByFlag('timer_1');

      if (activeTimer == null || !activeTimer.isRunning) {
        timer.cancel();
        _localTargetTime = null;
        notifyListeners();
        return;
      }

      final now = DateTime.now();
      final remainingSeconds = _localTargetTime!.difference(now).inSeconds;

      if (remainingSeconds > 0) {
        activeTimer.sisaTimer = remainingSeconds.toDouble();
        notifyListeners();
      } else {
        activeTimer.sisaTimer = 0.0;
        notifyListeners();

        timer.cancel();
        _localTargetTime = null;
        _localTicker = null;

        fetchTimerData(gudangId);
      }
    });
  }

  Future<bool> toggleTimer(String gudangId) async {
    try {
      await _repository.toggleTimer(gudangId);
      _localTicker?.cancel();
      _localTicker = null;
      _localTargetTime = null;

      await fetchTimerData(gudangId);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> setLimitTimer(
    String gudangId,
    int limit,
    String flagSensor,
  ) async {
    try {
      final success = await _repository.setLimitTimer(
        gudangId,
        limit,
        flagSensor,
      );
      if (success) {
        _localTicker?.cancel();
        _localTicker = null;
        _localTargetTime = null;
        await fetchTimerData(gudangId);
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _localTicker?.cancel();
    super.dispose();
  }
}
