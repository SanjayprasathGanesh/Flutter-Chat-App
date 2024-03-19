import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  bool? showVisibilityIcon;
  final TextInputType textInputType;

  MyTextFormField({super.key,
    required this.title, required this.hintText,
    required this.controller, required this.validator,
    required this.showVisibilityIcon, required this.textInputType,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {

  bool showPsw = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrange),
              borderRadius: BorderRadius.circular(6.0),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            labelText: widget.title,
            suffixIcon: IconButton(
              onPressed: (){
                setState((){
                  showPsw = !showPsw;
                });
              },
              icon: widget.showVisibilityIcon! ?
                      showPsw ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility_outlined)
                      : const SizedBox(),
            )
        ),
        validator:  widget.validator,
        controller:  widget.controller,
        cursorColor: Colors.black,
        keyboardType:  widget.textInputType,
        obscureText:  showPsw,
        maxLines: null, // Initially set to null
        onChanged: (_) {
          setState(() {
            // Update maxLines based on the length of text
            if (widget.controller.text.isNotEmpty) {
              widget.controller.text.split('\n').length >= 5
                  ? widget.controller.text.split('\n').length + 1
                  : null;
            } else {
              widget.controller.text.split('\n').length + 1;
            }
          });
        },
      ),
    );
  }
}
