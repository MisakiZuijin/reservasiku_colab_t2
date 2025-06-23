import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reservation_model.dart';
import '../utils/supabase_client.dart';

class ReservationController extends GetxController {
  final RxList<Reservation> reservations = <Reservation>[].obs;
  final RxList<Reservation> allReservations = <Reservation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    final supabase = SupabaseConfig.client;
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        reservations.clear();
        return;
      }

      final response = await supabase
          .from('Reservasi')
          .select()
          .eq('id_user', user.id)
          .order('tanggal_pesanan', ascending: true);

      reservations.clear();

      for (final item in response) {
        reservations.add(
          Reservation(
            id: item['id_reservasi'],
            namaPemesan: item['nama_pemesan'],
            telpPemesan: item['telp_pemesan'],
            date: DateTime.parse(item['tanggal_pesanan']),
            time: TimeOfDay(
              hour: int.parse(item['waktu_pesanan'].toString().split(':')[0]),
              minute: int.parse(item['waktu_pesanan'].toString().split(':')[1]),
            ),
            people: (item['jumlah_pesanan'] as num).toInt(),
            status: item['konfirmasi_pesanan'] ?? 'pending',
            notes: item['catatan_pesanan'],
            totalHarga: item['total_harga'] ?? 0,
            imgPesanan: item['img_pesanan'], // ✅ TAMBAHKAN URL GAMBAR
          ),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data reservasi: $e');
    }
  }

  Future<void> fetchAllReservations() async {
    final supabase = SupabaseConfig.client;
    try {
      final response = await supabase
          .from('Reservasi')
          .select()
          .order('tanggal_pesanan', ascending: true);

      allReservations.clear();

      for (final item in response) {
        allReservations.add(_mapToReservation(item));
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat semua reservasi: $e');
    }
  }

  Reservation _mapToReservation(dynamic item) {
    return Reservation(
      id: item['id_reservasi'],
      namaPemesan: item['nama_pemesan'],
      telpPemesan: item['telp_pemesan'],
      date: DateTime.parse(item['tanggal_pesanan']),
      time: TimeOfDay(
        hour: int.parse(item['waktu_pesanan'].toString().split(':')[0]),
        minute: int.parse(item['waktu_pesanan'].toString().split(':')[1]),
      ),
      people: (item['jumlah_pesanan'] as num).toInt(),
      status: item['konfirmasi_pesanan'] ?? 'pending',
      notes: item['catatan_pesanan'],
      totalHarga: item['total_harga'] ?? 0,
      imgPesanan: item['img_pesanan'],
    );
  }
}
