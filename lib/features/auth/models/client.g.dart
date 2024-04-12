// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      birthday: DateTime.parse(json['birthday'] as String),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'birthday': instance.birthday.toIso8601String(),
      'imageUrl': instance.imageUrl,
    };

const _$UserTypeEnumMap = {
  UserType.client: 'client',
  UserType.company: 'company',
};
