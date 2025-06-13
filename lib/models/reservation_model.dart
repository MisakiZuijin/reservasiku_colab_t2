import 'package:flutter/material.dart';

class Reservation {
  final String id;
  final String restaurantName;
  final DateTime date;
  final TimeOfDay time;
  final int people;
  final String status; // 'pending', 'confirmed', 'rejected'
  final String? paymentProofUrl;

  Reservation({
    required this.id,
    required this.restaurantName,
    required this.date,
    required this.time,
    required this.people,
    required this.status,
    this.paymentProofUrl,
  });

  // Helper method to get status color
  Color get statusColor {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  // Format date to string
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format time to string
  String get formattedTime {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
