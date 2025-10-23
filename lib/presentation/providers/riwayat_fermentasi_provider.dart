import 'package:iotmcc_mobile/data/repositories/riwayat_repository.dart';
import 'base_riwayat_provider.dart';

class RiwayatFermentasiProvider extends BaseRiwayatProvider {
  RiwayatFermentasiProvider(super.riwayatRepository);

  @override
  String get namaRuanganIdentifier =>
      "Fermentasi"; // Sesuaikan dengan nama di DB

  @override
  TipeRuanganRiwayat get tipeRuangan => TipeRuanganRiwayat.fermentasi;
}
