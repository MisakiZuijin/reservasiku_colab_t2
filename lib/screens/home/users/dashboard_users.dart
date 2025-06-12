import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/bottom_nav.dart';

class DashboardUsersScreen extends StatelessWidget {
  const DashboardUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selamat Datang di RestoKu"),
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

            // Section: Reservasi Terbaru
            const Text(
              "Reservasi Terbaru",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu, color: Colors.green),
                title: const Text("Resto Padang Sederhana"),
                subtitle: const Text("12 Juni 2025 - 18:00 WIB"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigasi ke detail reservasi
                },
              ),
            ),

            const SizedBox(height: 24),

            // Section: Riwayat Reservasi
            const Text(
              "Riwayat Reservasi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...List.generate(3, (index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text("Resto Jepang ${index + 1}"),
                  subtitle: Text("10 Juni 2025 - 19:00 WIB"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigasi ke detail riwayat
                  },
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
