import 'package:chat_app/model/add_contact_model.dart';
import 'package:chat_app/view/widgets/show_toast.dart';
import 'package:chat_app/view_model/add_contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact({super.key});

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {

  AddContactViewModel _addContactViewModel = AddContactViewModel();

  final _formKey = GlobalKey<FormState>();

  AddContact contact = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addContactViewModel.name.text = contact.name!;
    _addContactViewModel.phoneNum.text = contact.phoneNum!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          fontSize: 16.0,
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
                        // bool check = await _addContactViewModel.checkContactExist(contact.createdBy!);
                        // if(check){
                        //   showToast('Name or Phone Number Already Exist', Colors.red);
                        // }
                        // else{
                          await _addContactViewModel.updateContact(contact);
                          showToast('Contact Updated Successfully', Colors.green);
                          Get.back(result: true);
                        // }
                      }
                      else{
                        showToast('Some Empty Fields', Colors.red);
                      }
                    },
                    child: const Text('Save',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
