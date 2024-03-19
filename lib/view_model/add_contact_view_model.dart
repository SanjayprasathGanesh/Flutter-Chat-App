import 'package:chat_app/database/database_connection.dart';
import 'package:chat_app/services/validations.dart';
import 'package:chat_app/view/widgets/text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/add_contact_model.dart';

class AddContactViewModel extends GetxController{
  TextEditingController name = TextEditingController();
  TextEditingController phoneNum = TextEditingController();

  Widget buildAddContactForm() {
    List<Widget> fields = [
      MyTextFormField(
          title: 'Name', hintText: 'Enter Your Name',
          controller: name, validator: validateName,
          showVisibilityIcon: false, textInputType: TextInputType.text
      ),
      MyTextFormField(
          title: 'Phone Number', hintText: 'Enter Your Phone Number',
          controller: phoneNum, validator: validatePhone,
          showVisibilityIcon: false, textInputType: TextInputType.phone
      ),
    ];
    return Column(
      children: fields,
    );
  }

  Widget showMore(int index, context){
    print('Show More');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.edit,color: Colors.green,),
              title: const Text('Edit Contact',style: TextStyle(color: Colors.black),),
              onTap: (){},
            ),
            const Divider(thickness: 2.0,color: Colors.grey,),
            // const SizedBox(height: 10.0,),
            ListTile(
              leading: const Icon(Icons.delete_outline,color: Colors.red,),
              title: const Text('Delete Contact',style: TextStyle(color: Colors.black),),
              onTap: (){},
            ),
            const Divider(thickness: 2.0,color: Colors.grey,),
          ],
        )
      ),
    );
  }

  final DataBaseConnection _connection = DataBaseConnection();
  final _contactList = <AddContact>[].obs;

  List<AddContact> get contactList => _contactList;

  void addContact(String userNum) async{
    AddContact addContact = AddContact(name: name.text, phoneNum: phoneNum.text, createdBy: userNum);
    await _connection.addContact(addContact);
    _contactList.add(addContact);
  }

  updateContact(AddContact prevContact) async{
    AddContact addContact = AddContact(name: name.text, phoneNum: phoneNum.text, createdBy: prevContact.createdBy);
    await _connection.updateContact(prevContact, addContact);
  }

  deleteContact(AddContact addContact) async{
    await _connection.deleteContact(addContact);
  }

  void getAllContact(String userNum) async{
    QuerySnapshot querySnapshot = await _connection.getAllContact(userNum);
    Map<String, dynamic> map = {};
    List<AddContact> contacts = [];
    for(int i = 0;i < querySnapshot.size;i++){
      Map<String, dynamic> map = {};
      map = querySnapshot.docs[i].data() as Map<String, dynamic>;
      AddContact addContact = AddContact.fromJson(map);
      contacts.add(addContact);
    }
    _contactList.assignAll(contacts);
  }

  Future<bool> checkContactExist(String createdBy) async{
    AddContact addContact = AddContact(name: name.text, phoneNum: phoneNum.text, createdBy: createdBy);
    bool check = await _connection.checkContactExist(addContact);
    if(check){
      return true;
    }
    return false;
  }



}