import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String text, Color color){
  Fluttertoast.showToast(
      msg: text,
      textColor: Colors.black,
      backgroundColor: color,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
  );
}