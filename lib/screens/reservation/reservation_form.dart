// screens/reservation/reservation_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'invoice_screen.dart';

class ReservationForm extends StatelessWidget {
  const ReservationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Reservasi"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildField(Icons.person, "Nama", nameController),
            const SizedBox(height: 16),
            _buildField(Icons.calendar_today, "Tanggal", dateController),
            const SizedBox(height: 16),
            _buildField(Icons.access_time, "Waktu", timeController),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              onPressed: () {
                Get.to(
                  () => InvoiceScreen(
                    name: nameController.text,
                    date: dateController.text,
                    time: timeController.text,
                  ),
                );
              },
              label: const Text("Konfirmasi Reservasi"),
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

  Widget _buildField(
    IconData icon,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.green),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
