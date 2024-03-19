import 'package:chat_app/view/widgets/show_toast.dart';
import 'package:chat_app/view_model/add_contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {

  AddContactViewModel _addContactViewModel = AddContactViewModel();

  final _formKey = GlobalKey<FormState>();

  String userNum = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          fontFamily: 'Poppins',
        ),),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            shape: BoxShape.rectangle,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children:
              [
                _addContactViewModel.buildAddContactForm(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        bool check = await _addContactViewModel.checkContactExist(userNum);
                        if(check){
                          showToast('Name or Phone Number Already Exist', Colors.red);
                        }
                        else{
                          _addContactViewModel.addContact(userNum);
                          showToast('New Contact Added Successfully', Colors.green);
                          Get.back(result: 1);
                        }
                      }
                      else{
                        showToast('Some Empty Fields', Colors.red);
                      }
                    },
                    child: const Text('Save',style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
