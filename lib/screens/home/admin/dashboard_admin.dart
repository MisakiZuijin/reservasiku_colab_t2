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

  // Tambahkan dummy data untuk notifikasi
  final List<Map<String, dynamic>> dummyReservations = [
    {
      'namaPemesan': 'Budi Santoso',
      'telpPemesan': '081234567890',
      'formattedDate': '23/06/2025',
      'formattedTime': '19:00',
      'people': 4,
      'notes': 'Meja dekat jendela',
      'id': 'RSV001',
      'status': 'Pending',
      'totalHarga': 250000,
      'imgPesanan': null,
    },
    {
      'namaPemesan': 'Siti Aminah',
      'telpPemesan': '082345678901',
      'formattedDate': '24/06/2025',
      'formattedTime': '20:00',
      'people': 2,
      'notes': '',
      'id': 'RSV002',
      'status': 'Accept',
      'totalHarga': 150000,
      'imgPesanan': null,
    },
    {
      'namaPemesan': 'Andi Wijaya',
      'telpPemesan': '083456789012',
      'formattedDate': '25/06/2025',
      'formattedTime': '18:30',
      'people': 6,
      'notes': 'Ulang tahun',
      'id': 'RSV003',
      'status': 'Reject',
      'totalHarga': 400000,
      'imgPesanan': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    reservationController.fetchReservations();
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
        final reservations = reservationController.reservations;

        // Jika tidak ada reservasi dari controller, tampilkan dummy
        final showDummy = reservations.isEmpty;
        final List dataList = showDummy ? dummyReservations : reservations;

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
                      "Kelola reservasi, data user, dan laporan dengan mudah.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Notifikasi Reservasi User",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (dataList.isEmpty)
                const Center(child: Text("Belum ada reservasi"))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final reservation = dataList[index];
                    // Untuk dummy, gunakan Map, untuk asli gunakan model
                    final namaPemesan = reservation is Map
                        ? reservation['namaPemesan']
                        : reservation.namaPemesan;
                    final telpPemesan = reservation is Map
                        ? reservation['telpPemesan']
                        : reservation.telpPemesan;
                    final formattedDate = reservation is Map
                        ? reservation['formattedDate']
                        : reservation.formattedDate;
                    final formattedTime = reservation is Map
                        ? reservation['formattedTime']
                        : reservation.formattedTime;
                    final people = reservation is Map
                        ? reservation['people']
                        : reservation.people;
                    final notes = reservation is Map
                        ? reservation['notes']
                        : reservation.notes ?? '';
                    final id = reservation is Map
                        ? reservation['id']
                        : reservation.id;
                    final status = reservation is Map
                        ? reservation['status']
                        : reservation.status;
                    final totalHarga = reservation is Map
                        ? reservation['totalHarga']
                        : reservation.totalHarga;
                    final imgPesanan = reservation is Map
                        ? reservation['imgPesanan']
                        : reservation.imgPesanan;

                    Color statusColor;
                    switch (status.toString().toLowerCase()) {
                      case 'accept':
                        statusColor = Colors.green;
                        break;
                      case 'pending':
                        statusColor = Colors.orange;
                        break;
                      case 'reject':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

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
                            color: statusColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        title: Text(namaPemesan),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$formattedDate - $formattedTime",
                            ),
                            Text("$people Orang"),
                            Text(
                              "Status: ${status.toString().toUpperCase()}",
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.to(
                            () => InvoiceViewOnlyScreen(
                              name: namaPemesan,
                              phone: telpPemesan,
                              date: formattedDate,
                              time: formattedTime,
                              people: people,
                              notes: notes ?? '',
                              reservationId: id,
                              status: status,
                              totalHarga: totalHarga,
                              imgPesanan: imgPesanan,
                              isAdmin: true,
                            ),
                          );
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