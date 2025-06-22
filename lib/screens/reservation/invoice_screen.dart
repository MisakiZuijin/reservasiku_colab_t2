import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:reservasiku_colab_t2/screens/home/users/dashboard_users.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/reservation_controller.dart';
import '../../services/auth_service.dart';
import '../../utils/supabase_client.dart';

class InvoiceScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String date;
  final String time;
  final int people;
  final String notes;
  final String reservationId;

  const InvoiceScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.date,
    required this.time,
    required this.people,
    required this.notes,
    required this.reservationId,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String? selectedPaymentMethod;
  final supabase = SupabaseConfig.client;
  bool _isUploading = false;

  String get totalPrice {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.people * 20000);
  }

  Future<void> _pickAndUploadProof() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      Get.snackbar('Batal', 'Tidak ada gambar yang dipilih');
      return;
    }

    setState(() => _isUploading = true);

    final fileName =
        '${widget.reservationId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    String imgUrl;

    try {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        imgUrl = await AuthService().uploadImage(
          bucket: 'bukti-pembayaran',
          fileName: fileName,
          bytes: bytes,
        );
      } else {
        final file = File(pickedFile.path);
        imgUrl = await AuthService().uploadImage(
          bucket: 'bukti-pembayaran',
          fileName: fileName,
          file: file,
        );
      }

      await supabase
          .from('Reservasi')
          .update({'img_pesanan': imgUrl, 'konfirmasi_pesanan': 'Pending'})
          .eq('id_reservasi', widget.reservationId);

      _showPaymentConfirmationDialog(context);
    } catch (e) {
      Get.snackbar('Error', 'Gagal upload bukti pembayaran: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Reservasi"),
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Center(
              child: Icon(
                Icons.check_circle,
                color: const Color.fromRGBO(89, 255, 0, 1),
                size: 80,
              ),
            ),
            const Center(
              child: Text(
                "Reservasi Berhasil!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // Detail Reservasi
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
                    _buildDetailRow("Nama", widget.name),
                    _buildDetailRow("Nomor Telepon", widget.phone),
                    _buildDetailRow("Tanggal", widget.date),
                    _buildDetailRow("Waktu", widget.time),
                    _buildDetailRow("Jumlah Orang", "${widget.people} Orang"),
                    if (widget.notes.isNotEmpty)
                      _buildDetailRow("Catatan", widget.notes),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pembayaran
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
                      "Pembayaran",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const Text(
                      "Total yang harus dibayar:",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      totalPrice,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(89, 255, 0, 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Pilih metode pembayaran:",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    // Metode Pembayaran baru
                    _buildPaymentOption("QRIS", "assets/images/qris.png"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedPaymentMethod == null) {
                    Get.snackbar(
                      'Pilih Metode Pembayaran',
                      'Silakan pilih metode pembayaran terlebih dahulu.',
                    );
                    return;
                  }

                  if (selectedPaymentMethod == "QRIS") {
                    _showQRISDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Lanjutkan Pembayaran",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
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

  Widget _buildPaymentOption(String method, String iconPath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: RadioListTile<String>(
        title: Row(
          children: [
            Image.asset(iconPath, width: 85),
            const SizedBox(width: 10),
            Text(method, style: TextStyle(color: Colors.transparent)),
          ],
        ),
        value: method,
        groupValue: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value;
          });
        },
      ),
    );
  }

  void _showQRISDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Pembayaran QRIS"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.qr_code,
                    size: 200,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Scan QR Code di atas untuk melakukan pembayaran"),
                const SizedBox(height: 16),
                Text(
                  "Total: $totalPrice",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Tutup dialog
                      _showUploadProofDialog(context);
                    },
                    child: const Text("Saya Sudah Bayar"),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showUploadProofDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Upload Bukti Pembayaran"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Silakan upload bukti pembayaran Anda"),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    Get.back(); // tutup dialog upload sebelum mulai upload
                    await _pickAndUploadProof(); // buka image picker langsung
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 50),
                        SizedBox(height: 8),
                        Text("Pilih Gambar"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(), // untuk membatalkan
                  child: const Text("Batal"),
                ),
              ],
            ),
          ),
    );
  }

  void _showPaymentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Terima Kasih"),
            content: const Text(
              "Bukti pembayaran Anda telah dikirim. "
              "Silakan tunggu konfirmasi dari admin.",
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  Get.offAll(
                    () => const DashboardUsersScreen(),
                  ); // Kembali ke dashboard
                },
                child: const Text("Ok"),
              ),
            ],
          ),
    );
  }
}
