import 'package:chat_app/model/add_contact_model.dart';
import 'package:chat_app/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../database/database_connection.dart';
import 'login.dart';

class RegisterContact extends StatefulWidget {
  const RegisterContact({super.key});

  @override
  State<RegisterContact> createState() => _RegisterContactState();
}

class _RegisterContactState extends State<RegisterContact> {

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  DataBaseConnection _connection = DataBaseConnection();
  bool validateName = false, validatePhone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  label: const Text("Enter Your Name", style: TextStyle(
                    fontFamily: 'Poppins',
                  ),),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  errorText: validateName ?
                  'Empty Name Field' : null,
                ),
                controller: name,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text("Enter the Contact Phone Number", style: TextStyle(
                    fontFamily: 'Poppins',
                  ),),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  errorText: validatePhone ?
                  'Empty Phone Field' : null,
                ),
                controller: phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async{
                        setState(() {
                          validateName = name.text.isEmpty!;
                          validatePhone = phone.text.isEmpty!;
                        });
                        if(!validateName && !validatePhone){
                          AddContact add = AddContact(name: name.text, phoneNum: phone.text, createdBy: phone.text);
                          bool check = await _connection.checkUserExist(add);
                          if(!check){
                            await _connection.addUser(add);
                            showToast('Contact Registered Successfully', Colors.green);
                            Get.toNamed('/chats_list',arguments: phone.text);
                          }
                          else{
                            showToast('User Already Exists', Colors.red);
                          }
                        }
                        else{
                          showToast('Empty Fields', Colors.red);
                        }
                      },
                      child: const Text('Register',style: TextStyle(
                        fontFamily: 'Poppins',
                      ),)
                  ),
                  const SizedBox(width: 10.0,),
                  TextButton(
                      onPressed: (){
                        Get.back();
                      },
                      child: const Text('Existing User?',style: TextStyle(
                        fontFamily: 'Poppins',
                      ),)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}