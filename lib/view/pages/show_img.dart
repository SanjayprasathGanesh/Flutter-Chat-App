import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({super.key});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {

  var image = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Image',style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(20.0),
        child: Image.file(image,fit: BoxFit.fitWidth,),
      ),
    );
  }
}
