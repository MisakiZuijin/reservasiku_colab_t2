import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/supabase_client.dart'; // Tambahkan ini

class InvoiceViewOnlyScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String date;
  final String time;
  final int people;
  final String notes;
  final String reservationId;
  final String status;
  final num totalHarga;
  final String? imgPesanan;
  final bool isAdmin; // Tambahkan ini

  const InvoiceViewOnlyScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.date,
    required this.time,
    required this.people,
    required this.notes,
    required this.reservationId,
    required this.status,
    required this.totalHarga,
    this.imgPesanan,
    this.isAdmin = false, // Default false
  });

  String get formattedTotalHarga {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(totalHarga);
  }

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    try {
      final supabase = SupabaseConfig.client;
      await supabase
          .from('Reservasi')
          .update({'konfirmasi_pesanan': newStatus})
          .eq('id_reservasi', reservationId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status berhasil diubah menjadi $newStatus')),
      );
      Navigator.of(context).pop(); // Kembali ke dashboard admin
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Reservasi"),
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Status: ${status.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Reservasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildDetailRow("Nama", name),
                    _buildDetailRow("No Telepon", phone),
                    _buildDetailRow("Tanggal", date),
                    _buildDetailRow("Waktu", time),
                    _buildDetailRow("Jumlah Orang", "$people Orang"),
                    if (notes.isNotEmpty) _buildDetailRow("Catatan", notes),
                    _buildDetailRow("Total Pembayaran", formattedTotalHarga),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (imgPesanan != null && imgPesanan!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bukti Pembayaran:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imgPesanan!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Text("Gagal memuat gambar"),
                    ),
                  ),
                ],
              ),
            // === TOMBOL KONFIRMASI ADMIN ===
            if (isAdmin && status.toLowerCase() == 'pending') ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => _updateStatus(context, 'Accept'),
                      child: const Text('Terima'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => _updateStatus(context, 'Reject'),
                      child: const Text('Tolak'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(": "),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accept':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Reject':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}