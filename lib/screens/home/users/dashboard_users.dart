import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/reservation_controller.dart';
import '../../../widgets/bottom_nav.dart';
import '../../reservation/invoice_screen.dart';

class DashboardUsersScreen extends StatelessWidget {
  const DashboardUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReservationController reservationController = Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/Logo_White.png",
            height: 10,
            width: 10,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          "Selamat Datang di Reservasiku",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
        elevation: 4,
      ),
      body: Obx(() {
        final reservations = reservationController.reservations;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner welcome
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(173, 255, 128, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pesan Meja Restoran Favoritmu!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Buat reservasi dengan mudah dan cepat.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reservasi Aktif
              const Text(
                "Reservasi Aktif",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (reservations.isEmpty)
                const Center(child: Text("Belum ada reservasi"))
              else
                ...reservations.map((reservation) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: reservation.statusColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      title: Text(reservation.restaurantName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${reservation.formattedDate} - ${reservation.formattedTime}",
                          ),
                          Text("${reservation.people} Orang"),
                          Text(
                            "Status: ${reservation.status.toUpperCase()}",
                            style: TextStyle(
                              color: reservation.statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigasi ke detail invoice
                        final currentReservation =
                            reservation; // Rename variable untuk menghindari conflict
                        final reservationDetail = reservationController
                            .getReservationById(currentReservation.id);
                        if (reservationDetail != null) {
                          Get.to(
                            () => InvoiceScreen(
                              name:
                                  "Nama User", // Ganti dengan data user sebenarnya
                              phone:
                                  "Nomor Telepon", // Ganti dengan data user sebenarnya
                              date: reservationDetail.formattedDate,
                              time: reservationDetail.formattedTime,
                              people: reservationDetail.people,
                              notes:
                                  reservationDetail.notes ??
                                  "", // Gunakan notes dari reservasi
                              reservationId: reservationDetail.id,
                            ),
                          );
                        }
                      },
                    ),
                  );
                }),

              const SizedBox(height: 24),

              // Button untuk buat reservasi baru
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNav(),
    );
  }
}
