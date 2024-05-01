// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      id: json['id'] as String,
      clientId: json['clientId'] as String?,
      flights: (json['flights'] as List<dynamic>).map((e) => Flight.fromJson(e as Map<String, dynamic>)).toList(),
      isOneWay: json['isOneWay'] as bool,
      travelers: (json['travelers'] as List<dynamic>).map((e) => Traveler.fromJson(e as Map<String, dynamic>)).toList(),
      reservationDate: DateTime.parse(json['reservationDate'] as String),
      flightClass: json['flightClass'] as String,
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'flights': instance.flights.map((e) => e.toJson()).toList(),
      'isOneWay': instance.isOneWay,
      'travelers': instance.travelers.map((e) => e.toJson()).toList(),
      'reservationDate': instance.reservationDate.toIso8601String(),
      'flightClass': instance.flightClass,
    };
