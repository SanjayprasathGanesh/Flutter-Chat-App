import 'package:json_annotation/json_annotation.dart';

part 'add_contact_model.g.dart';

@JsonSerializable()
class AddContact{
  String? name;
  String? phoneNum;
  String? createdBy;

  AddContact({required this.name, required this.phoneNum, required this.createdBy});

  factory AddContact.fromJson(Map<String, dynamic> map) => _$AddContactFromJson(map);

  Map<String, dynamic> toJson(AddContact addContact) => _$AddContactToJson(addContact);
}