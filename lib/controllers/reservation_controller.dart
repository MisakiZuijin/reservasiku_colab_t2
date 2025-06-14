import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reservation_model.dart';

class ReservationController extends GetxController {
  final RxList<Reservation> reservations = <Reservation>[].obs;

  void addReservation(Reservation newReservation) {
    reservations.add(newReservation);
    reservations.sort((a, b) => a.date.compareTo(b.date));
  }

  void updateReservationStatus(String id, String newStatus) {
    final index = reservations.indexWhere((res) => res.id == id);
    if (index != -1) {
      reservations[index] = reservations[index].copyWith(status: newStatus);
      reservations.refresh();
    }
  }

  Reservation? getReservationById(String id) {
    try {
      return reservations.firstWhere((res) => res.id == id);
    } catch (e) {
      return null;
    }
  }
}

extension ReservationExtension on Reservation {
  Reservation copyWith({
    String? id,
    String? restaurantName,
    DateTime? date,
    TimeOfDay? time,
    int? people,
    String? status,
    String? paymentProofUrl,
    String? notes, // Tambahkan parameter notes
  }) {
    return Reservation(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      date: date ?? this.date,
      time: time ?? this.time,
      people: people ?? this.people,
      status: status ?? this.status,
      paymentProofUrl: paymentProofUrl ?? this.paymentProofUrl,
      notes: notes ?? this.notes, // Tambahkan notes
    );
  }
}
