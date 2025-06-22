import 'package:flutter/material.dart';

class Reservation {
  final String id;
  final String namaPemesan;
  final String telpPemesan;
  final DateTime date;
  final TimeOfDay time;
  final int people;
  final String status;
  final String? notes;
  final num totalHarga;
  final String? imgPesanan; // ✅ TAMBAHKAN URL GAMBAR

  Reservation({
    required this.id,
    required this.namaPemesan,
    required this.telpPemesan,
    required this.date,
    required this.time,
    required this.people,
    required this.status,
    this.notes,
    required this.totalHarga,
    this.imgPesanan, // ✅
  });

  Color get statusColor {
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

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  String get formattedTime =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}
