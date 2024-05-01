import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flight.g.dart';

@JsonSerializable(explicitToJson: true)
class Flight extends Equatable {
  String? id;
  final String userId;
  final String userName;
  final String? logo;
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
  final String period;
  final String lunchTime;
  final String arriveTime;
  final List<Seat> seats;
  //for sorting the flights in the tickets
  final int index;

  Flight({
    this.id,
    required this.userId,
    required this.userName,
    required this.logo,
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
    required this.period,
    required this.arriveTime,
    required this.lunchTime,
    this.index = 0,
  });

  factory Flight.fromJson(Map<String, dynamic> json) => _$FlightFromJson(json);
  Map<String, dynamic> toJson() => _$FlightToJson(this);

  factory Flight.fromFirestore(DocumentSnapshot documentSnapshot) {
    Flight flight = Flight.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    flight.id = documentSnapshot.id;
    return flight;
  }

  bool hasAvailableSeats({required String flightClass, required int neadedSeats}) {
    bool isVip = flightClass == 'Business' ? true : false;

    int countAvailableSeats = 0;
    for (var seat in seats) {
      if (seat.available && seat.isVip == isVip) {
        countAvailableSeats++;
      }
    }
    return countAvailableSeats >= neadedSeats;
  }

  int countSeats(String flightClass) {
    bool isVip = flightClass == 'Business' ? true : false;

    int count = 0;

    for (var seat in seats) {
      if (seat.isVip == isVip) {
        count += 1;
      }
    }
    return count;
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
    String? period,
    String? lunchTime,
    String? arriveTime,
    int? index,
    String? logo,
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
      period: period ?? this.period,
      arriveTime: arriveTime ?? this.arriveTime,
      lunchTime: lunchTime ?? this.lunchTime,
      index: index ?? this.index,
      logo: logo ?? this.logo,
    );
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
        index,
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
