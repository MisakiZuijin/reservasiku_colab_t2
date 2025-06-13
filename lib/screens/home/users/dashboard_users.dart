import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/reservation_controller.dart';
import '../../../widgets/bottom_nav.dart';

class DashboardUsersScreen extends StatelessWidget {
  const DashboardUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReservationController reservationController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selamat Datang di RestoKu"),
        backgroundColor: Colors.green,
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
                  color: Colors.green.shade100,
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
                        // Navigasi ke detail reservasi
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
