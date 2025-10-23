import 'package:iotmcc_mobile/data/repositories/riwayat_repository.dart';
import 'base_riwayat_provider.dart';

class RiwayatPerebusanProvider extends BaseRiwayatProvider {
  RiwayatPerebusanProvider(super.riwayatRepository);

  @override
  String get namaRuanganIdentifier =>
      "Blaching"; // Sesuaikan dengan nama di DB

  @override
  TipeRuanganRiwayat get tipeRuangan => TipeRuanganRiwayat.perebusan;
}
