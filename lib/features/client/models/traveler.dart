import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'traveler.g.dart';

@JsonSerializable(explicitToJson: true)
class Traveler extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final DateTime? birthDay;
  final DateTime? passportEndDate;
  final DateTime? passportReleaseDate;
  final String nationality;

  const Traveler(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.birthDay,
      required this.passportEndDate,
      required this.passportReleaseDate,
      required this.nationality});

  factory Traveler.fromJson(Map<String, dynamic> json) => _$TravelerFromJson(json);

  factory Traveler.fromFirestore(DocumentSnapshot documentSnapshot) {
    Traveler traveler = Traveler.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return traveler.copyWith(id: documentSnapshot.id);
  }

  Map<String, dynamic> toJson() => _$TravelerToJson(this);

  Traveler copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    DateTime? birthDay,
    DateTime? passportEndDate,
    DateTime? passportReleaseDate,
    String? nationality,
  }) {
    return Traveler(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDay: birthDay ?? this.birthDay,
      passportEndDate: passportEndDate ?? this.passportEndDate,
      passportReleaseDate: passportReleaseDate ?? this.passportReleaseDate,
      nationality: nationality ?? this.nationality,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        birthDay,
        passportEndDate,
        passportReleaseDate,
        nationality,
      ];
}
