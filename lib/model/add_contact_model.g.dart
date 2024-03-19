// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddContact _$AddContactFromJson(Map<String, dynamic> json) => AddContact(
      name: json['name'] as String?,
      phoneNum: json['phoneNum'] as String?,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$AddContactToJson(AddContact instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phoneNum': instance.phoneNum,
      'createdBy': instance.createdBy,
    };
