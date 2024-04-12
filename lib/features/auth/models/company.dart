import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flights/core/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable(explicitToJson: true)
class Company extends Equatable {
  String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String description;
  final String? imageUrl;
  final UserType userType;

  Company(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.userType,
      required this.description,
      required this.imageUrl});

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  factory Company.fromFirestore(DocumentSnapshot documentSnapshot) {
    Company company = Company.fromJson(documentSnapshot.data() as Map<String, dynamic>);

    company.id = documentSnapshot.id;
    return company;
  }

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  List<Object?> get props => [id, name, phone, email, address, description, imageUrl];
}
