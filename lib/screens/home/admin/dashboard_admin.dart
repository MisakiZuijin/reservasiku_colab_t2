import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/reservation_controller.dart';
import '../../../widgets/bottom_nav_admin.dart';
import '../../reservation/invoice_view_only_screen.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  final reservationController = Get.find<ReservationController>();

  @override
  void initState() {
    super.initState();
    reservationController
        .fetchAllReservations(); // Ambil semua reservasi (khusus admin)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/Logo_White.png", fit: BoxFit.cover),
        ),
        title: const Text(
          "Dashboard Admin Reservasiku",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
      ),
      body: Obx(() {
        final reservations = reservationController.allReservations;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(173, 255, 128, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang Admin!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Kelola reservasi pengguna dengan mudah.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Semua Reservasi Pengguna",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (reservations.isEmpty)
                const Center(child: Text("Belum ada reservasi."))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];

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
                        title: Text(reservation.namaPemesan),
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
                          Get.to(
                            () => InvoiceViewOnlyScreen(
                              name: reservation.namaPemesan,
                              phone: reservation.telpPemesan,
                              date: reservation.formattedDate,
                              time: reservation.formattedTime,
                              people: reservation.people,
                              notes: reservation.notes ?? '',
                              reservationId: reservation.id,
                              status: reservation.status,
                              totalHarga: reservation.totalHarga,
                              imgPesanan: reservation.imgPesanan,
                              isAdmin: true,
                            ),
                          )?.then((_) {
                            reservationController
                                .fetchAllReservations(); // ✅ Refresh saat kembali
                          });
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavAdmin(),
    );
  }
}
