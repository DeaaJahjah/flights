import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flight.g.dart';

@JsonSerializable(explicitToJson: true)
class Flight extends Equatable {
  String? id;
  final String userId;
  final String userName;
  final String flightNo;
  final String airplaneNo;
  final String from;
  final String to;
  final DateTime lunchDate;
  final DateTime arriveDate;
  final int businessClassCost;
  final int normalClassCost;
  final int numberOfVIPSeats;
  final int numberOfNormalSeats;
  final int period;

  final List<Seat> seats;

  Flight(
      {this.id,
      required this.userId,
      required this.userName,
      required this.flightNo,
      required this.airplaneNo,
      required this.from,
      required this.to,
      required this.lunchDate,
      required this.arriveDate,
      required this.businessClassCost,
      required this.normalClassCost,
      required this.numberOfNormalSeats,
      required this.numberOfVIPSeats,
      required this.seats,
      required this.period});

  factory Flight.fromJson(Map<String, dynamic> json) => _$FlightFromJson(json);
  Map<String, dynamic> toJson() => _$FlightToJson(this);

  factory Flight.fromFirestore(DocumentSnapshot documentSnapshot) {
    Flight flight = Flight.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    flight.id = documentSnapshot.id;
    return flight;
  }

  Flight copyWith({
    String? id,
    String? userId,
    String? userName,
    String? flightNo,
    String? airplaneNo,
    String? from,
    String? to,
    DateTime? lunchDate,
    DateTime? arriveDate,
    int? businessClassCost,
    int? normalClassCost,
    int? numberOfVIPSeats,
    int? numberOfNormalSeats,
    List<Seat>? seats,
    int? period,
  }) {
    return Flight(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        flightNo: flightNo ?? this.flightNo,
        airplaneNo: airplaneNo ?? this.airplaneNo,
        from: from ?? this.from,
        to: to ?? this.to,
        lunchDate: lunchDate ?? this.lunchDate,
        arriveDate: arriveDate ?? this.arriveDate,
        businessClassCost: businessClassCost ?? this.businessClassCost,
        normalClassCost: normalClassCost ?? this.normalClassCost,
        numberOfNormalSeats: numberOfNormalSeats ?? this.numberOfNormalSeats,
        numberOfVIPSeats: numberOfVIPSeats ?? this.numberOfVIPSeats,
        seats: seats ?? this.seats,
        period: period ?? this.period);
  }

  @override
  List<Object?> get props => [
        id,
        flightNo,
        seats,
        businessClassCost,
        normalClassCost,
        from,
        to,
        lunchDate,
        arriveDate,
        period,
      ];
}

@JsonSerializable(explicitToJson: true)
class Seat extends Equatable {
  String? id;
  final String name;
  final bool isVip;

  final bool available;

  Seat({required this.id, required this.isVip, required this.name, required this.available});

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);
  Map<String, dynamic> toJson() => _$SeatToJson(this);

  factory Seat.fromFirestore(DocumentSnapshot documentSnapshot) {
    Seat seat = Seat.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    seat.id = documentSnapshot.id;
    return seat;
  }

  Seat copyWith({
    String? id,
    String? name,
    bool? isVip,
    bool? available,
  }) {
    return Seat(
      id: id ?? this.id,
      name: name ?? this.name,
      isVip: isVip ?? this.isVip,
      available: available ?? this.available,
    );
  }

  @override
  List<Object?> get props => [id, name, available];
}
