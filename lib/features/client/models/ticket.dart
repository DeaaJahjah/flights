import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flights/features/client/models/traveler.dart';
import 'package:flights/features/flights/models/flight.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

@JsonSerializable(explicitToJson: true)
class Ticket extends Equatable {
  final String id;
  final String? clientId;
  final List<Flight> flights;
  final bool isOneWay;
  final List<Traveler> travelers;
  final DateTime reservationDate;
  final String flightClass;

  const Ticket(
      {required this.id,
      this.clientId,
      required this.flights,
      required this.isOneWay,
      required this.travelers,
      required this.reservationDate,
      required this.flightClass});

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  factory Ticket.fromFirestore(DocumentSnapshot documentSnapshot) {
    Ticket ticket = Ticket.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return ticket.copyWith(id: documentSnapshot.id);
  }

  Map<String, dynamic> toJson() => _$TicketToJson(this);

  Ticket copyWith({
    String? id,
    List<Flight>? flights,
    bool? isOneWay,
    List<Traveler>? travelers,
    DateTime? reservationDate,
    String? flightClass,
  }) {
    return Ticket(
      id: id ?? this.id,
      flights: flights ?? this.flights,
      isOneWay: isOneWay ?? this.isOneWay,
      travelers: travelers ?? this.travelers,
      reservationDate: reservationDate ?? this.reservationDate,
      flightClass: flightClass ?? this.flightClass,
    );
  }

  @override
  List<Object?> get props => [flights, isOneWay, travelers, reservationDate, flightClass, flights];
}
