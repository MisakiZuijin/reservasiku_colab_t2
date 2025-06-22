import '../utils/supabase_client.dart';

class ReservationService {
  final _supabase = SupabaseConfig.client;

  Future<String> insertReservation({
    required String idUser,
    required String namaPemesan,
    required String telpPemesan,
    required DateTime tanggalPesanan,
    required String waktuPesanan,
    required int jumlahPesanan,
    required String catatanPesanan,
    required int totalHarga, // ← Tambahkan total harga
    String? imgPesanan,
  }) async {
    final response =
        await _supabase
            .from('Reservasi')
            .insert({
              'id_user': idUser,
              'nama_pemesan': namaPemesan,
              'telp_pemesan': telpPemesan,
              'tanggal_pesanan': tanggalPesanan.toIso8601String(),
              'waktu_pesanan': waktuPesanan,
              'jumlah_pesanan': jumlahPesanan,
              'catatan_pesanan': catatanPesanan.isEmpty ? null : catatanPesanan,
              'total_harga': totalHarga, // ← Tambahkan di sini
              'img_pesanan': imgPesanan,
            })
            .select('id_reservasi')
            .single();

    if (response == null || response['id_reservasi'] == null) {
      throw Exception('Gagal membuat reservasi');
    }
    return response['id_reservasi'];
  }
}
