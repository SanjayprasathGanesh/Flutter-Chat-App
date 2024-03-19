import 'package:chat_app/database/database_connection.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/view_model/specific_chat_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendImage extends StatefulWidget {
  const SendImage({super.key});

  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {

  SpecificChatViewModel _chatViewModel = SpecificChatViewModel();

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> map = Get.arguments;
    Message message = map['msg'];
    var image = map['imagePath'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Selected Image',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          fontFamily: 'Poppins',
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.25,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 10.0),
              child: Image.file(image),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5.0),
              ),
              child: MaterialButton(
                  onPressed: (){
                    print('Send $image');
                    Message msg = Message(
                        from: message.from,
                        to: message.to,
                        type: 'Image',
                        content: message.content,
                        timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
                        duration: '',
                        isPlaying: false,
                    );
                    String chatId = '${message.from} - ${message.to}';
                    _chatViewModel.sendImage(msg, chatId);
                    Get.back(result: 1);
                  },
                  child: const Text('Send',style: TextStyle(fontFamily: 'Poppins',),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
