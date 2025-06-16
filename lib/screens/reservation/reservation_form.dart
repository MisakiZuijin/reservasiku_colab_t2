import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reservasiku_colab_t2/controllers/reservation_controller.dart';
import 'package:reservasiku_colab_t2/models/reservation_model.dart';
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Form Reservasi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Nama
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nama lengkap';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nomor Telepon
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

              // Tanggal
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

              // Waktu
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

              // Jumlah Orang
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

              // Catatan
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

              // Tombol Konfirmasi
              ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                // Di bagian onPressed tombol konfirmasi:
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedDate != null &&
                      selectedTime != null) {
                    // Buat reservasi baru
                    final newReservation = Reservation(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      restaurantName:
                          "Resto Favorit", // atau ambil dari input user
                      date: selectedDate!,
                      time: selectedTime!,
                      people: peopleCount,
                      status: 'pending',
                      notes: notesController.text, // tambahkan notes
                    );

                    // Simpan ke controller
                    final reservationController =
                        Get.find<ReservationController>();
                    reservationController.addReservation(newReservation);

                    // Navigasi ke invoice dan hapus semua route sebelumnya
                    Get.offAll(
                      () => InvoiceScreen(
                        name: nameController.text,
                        phone: phoneController.text,
                        date: DateFormat('dd MMMM yyyy').format(selectedDate!),
                        time: selectedTime!.format(context),
                        people: peopleCount,
                        notes: notesController.text,
                        reservationId: newReservation.id,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap lengkapi semua data reservasi'),
                      ),
                    );
                  }
                },
                label: const Text(
                  "Konfirmasi Reservasi",
                  style: TextStyle(color: Colors.white),
                ),
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
}
