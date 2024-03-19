import 'package:chat_app/services/app_routes.dart';
import 'package:chat_app/view/pages/chats_list.dart';
import 'package:chat_app/view/pages/login.dart';
import 'package:chat_app/view_model/add_contact_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDkK-v_oCrd2gNgT2RL7BbvfiFQssNoZIk',
        appId: '1:404272138972:android:b23daa65a7da4413f5c219',
        messagingSenderId: '404272138972',
        projectId: 'chat-app-bc8c1',
        storageBucket: 'chat-app-bc8c1.appspot.com',
      )
  );
  Get.put(AddContactViewModel());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const Login(),
      getPages: appRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
