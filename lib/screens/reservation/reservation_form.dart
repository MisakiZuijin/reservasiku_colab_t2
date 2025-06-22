import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utils/supabase_client.dart';
import '../../services/reservation_service.dart';
import 'invoice_screen.dart';

class ReservationForm extends StatefulWidget {
  const ReservationForm({super.key});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int peopleCount = 2;
  bool _isSubmitting = false;

  final supabase = SupabaseConfig.client;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final data =
            await supabase
                .from('Users')
                .select('username')
                .eq('id_user', user.id)
                .single();
        setState(() {
          nameController.text = data['username'] ?? '';
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat nama pengguna');
    }
  }

  Future<void> _submitReservation() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate() ||
        selectedDate == null ||
        selectedTime == null) {
      Get.snackbar('Error', 'Harap lengkapi semua data reservasi');
      return;
    }

    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Anda belum login');
      return;
    }

    _isSubmitting = true;

    try {
      final reservationService = ReservationService();
      final totalHarga = peopleCount * 20000;

      final idReservasi = await reservationService.insertReservation(
        idUser: user.id,
        namaPemesan: nameController.text.trim(),
        telpPemesan: phoneController.text.trim(),
        tanggalPesanan: selectedDate!,
        waktuPesanan: '${selectedTime!.hour}:${selectedTime!.minute}',
        jumlahPesanan: peopleCount,
        catatanPesanan: notesController.text.trim(),
        totalHarga: totalHarga, // ← Tambahkan total harga
      );

      Get.offAll(
        () => InvoiceScreen(
          name: nameController.text,
          phone: phoneController.text,
          date: DateFormat('dd MMMM yyyy').format(selectedDate!),
          time: selectedTime!.format(context),
          people: peopleCount,
          notes: notesController.text,
          reservationId: idReservasi, // ← pakai id dari database
        ),
      );
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      _isSubmitting = false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null; // reset waktu agar tidak terjadi bentrok
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (selectedDate == null) {
      Get.snackbar('Error', 'Pilih tanggal terlebih dahulu');
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      if (isSameDay(selectedDate!, now)) {
        final nowTime = TimeOfDay.now();
        if (picked.hour < nowTime.hour ||
            (picked.hour == nowTime.hour && picked.minute < nowTime.minute)) {
          Get.snackbar('Error', 'Tidak bisa memilih waktu yang sudah lewat');
          return;
        }
      }
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Reservasi"),
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemesan',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nomor telepon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Reservasi',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    selectedDate != null
                        ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                        : 'Pilih Tanggal',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Waktu Reservasi',
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Pilih Waktu',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: peopleCount,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Orang',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                items:
                    List.generate(10, (index) => index + 1)
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text('$value Orang'),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    peopleCount = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Tambahan (Opsional)',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitReservation,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text("Konfirmasi Reservasi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
