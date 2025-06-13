import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reservation_model.dart';

class ReservationController extends GetxController {
  final RxList<Reservation> _reservations = <Reservation>[].obs;

  List<Reservation> get reservations => _reservations;

  void addReservation(Reservation newReservation) {
    _reservations.add(newReservation);
    _reservations.sort((a, b) => a.date.compareTo(b.date));
  }

  void updateReservationStatus(String id, String newStatus) {
    final index = _reservations.indexWhere((res) => res.id == id);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(status: newStatus);
      _reservations.refresh();
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
  }) {
    return Reservation(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      date: date ?? this.date,
      time: time ?? this.time,
      people: people ?? this.people,
      status: status ?? this.status,
      paymentProofUrl: paymentProofUrl ?? this.paymentProofUrl,
    );
  }
}
