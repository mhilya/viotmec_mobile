import 'package:viotmec_mobile/data/repositories/riwayat_repository.dart';
import 'base_riwayat_provider.dart';

class RiwayatPengeringanProvider extends BaseRiwayatProvider {
  RiwayatPengeringanProvider(super.riwayatRepository);

  @override
  String get namaRuanganIdentifier =>
      "Ruangan Pengeringan"; // Sesuaikan dengan nama di DB

  @override
  TipeRuanganRiwayat get tipeRuangan => TipeRuanganRiwayat.pengeringan;
}
