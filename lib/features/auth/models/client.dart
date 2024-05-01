import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flights/core/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable(explicitToJson: true)
class Client extends Equatable {
  String id;
  final String name;
  final String email;

  final String phone;
  final UserType userType;
  final DateTime birthday;
  final String? imageUrl;

  Client(
      {required this.id,
      required this.name,
      required this.phone,
      required this.userType,
      required this.birthday,
      required this.email,
      required this.imageUrl});

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  factory Client.fromFirestore(DocumentSnapshot documentSnapshot) {
    Client client = Client.fromJson(documentSnapshot.data() as Map<String, dynamic>);

    client.id = documentSnapshot.id;
    return client;
  }

  Map<String, dynamic> toJson() => _$ClientToJson(this);
  @override
  List<Object?> get props => [id, name, phone, birthday, imageUrl];
}
