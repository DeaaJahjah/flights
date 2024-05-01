// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'traveler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Traveler _$TravelerFromJson(Map<String, dynamic> json) => Traveler(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      birthDay: DateTime.parse(json['birthDay'] as String),
      passportEndDate: DateTime.parse(json['passportEndDate'] as String),
      passportReleaseDate: DateTime.parse(json['passportReleaseDate'] as String),
      nationality: json['nationality'] as String,
    );

Map<String, dynamic> _$TravelerToJson(Traveler instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'birthDay': instance.birthDay!.toIso8601String(),
      'passportEndDate': instance.passportEndDate!.toIso8601String(),
      'passportReleaseDate': instance.passportReleaseDate!.toIso8601String(),
      'nationality': instance.nationality,
    };
