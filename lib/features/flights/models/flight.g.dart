// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flight _$FlightFromJson(Map<String, dynamic> json) => Flight(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      flightNo: json['flightNo'] as String,
      airplaneNo: json['airplaneNo'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      lunchDate: DateTime.parse(json['lunchDate'] as String),
      arriveDate: DateTime.parse(json['arriveDate'] as String),
      businessClassCost: json['businessClassCost'] as int,
      normalClassCost: json['normalClassCost'] as int,
      numberOfNormalSeats: json['numberOfNormalSeats'] as int,
      numberOfVIPSeats: json['numberOfVIPSeats'] as int,
      seats: (json['seats'] as List<dynamic>)
          .map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
      period: json['period'] as int,
    );

Map<String, dynamic> _$FlightToJson(Flight instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'flightNo': instance.flightNo,
      'airplaneNo': instance.airplaneNo,
      'from': instance.from,
      'to': instance.to,
      'lunchDate': instance.lunchDate.toIso8601String(),
      'arriveDate': instance.arriveDate.toIso8601String(),
      'businessClassCost': instance.businessClassCost,
      'normalClassCost': instance.normalClassCost,
      'numberOfVIPSeats': instance.numberOfVIPSeats,
      'numberOfNormalSeats': instance.numberOfNormalSeats,
      'period': instance.period,
      'seats': instance.seats.map((e) => e.toJson()).toList(),
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      id: json['id'] as String?,
      isVip: json['isVip'] as bool,
      name: json['name'] as String,
      available: json['available'] as bool,
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isVip': instance.isVip,
      'available': instance.available,
    };
