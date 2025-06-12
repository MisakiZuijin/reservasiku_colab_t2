// screens/reservation/invoice_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'payment_screen.dart';

class InvoiceScreen extends StatelessWidget {
  final String name, date, time;

  const InvoiceScreen({
    super.key,
    required this.name,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoCard(Icons.person, "Nama", name),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.calendar_today, "Tanggal", date),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.access_time, "Waktu", time),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.payment),
              onPressed: () {
                Get.to(() => const PaymentScreen());
              },
              label: const Text("Lanjut ke Pembayaran"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
