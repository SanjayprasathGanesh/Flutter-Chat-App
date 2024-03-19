import 'dart:io';

import 'package:chat_app/database/database_connection.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/services/validations.dart';
import 'package:chat_app/view/widgets/show_toast.dart';
import 'package:chat_app/view/widgets/text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SpecificChatViewModel extends GetxController{

  final DataBaseConnection _connection = DataBaseConnection();
  var msgList = <Message>[];
  TextEditingController text = TextEditingController();

  Widget buildMsgText(){
    List<Widget> field = [
      MyTextFormField(
          title: '',
          hintText: 'Enter Your Message',
          controller: text,
          validator: validateText,
          showVisibilityIcon: false,
          textInputType: TextInputType.text
      )
    ];

    return Column(
      children: field,
    );
  }

  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  var isPlaying = false.obs;

  final ScrollController scrollController = ScrollController();

  initializePlayer() async{
    await _player.openPlayer(enableVoiceProcessing: true);
  }

  playAudio(Message message) async{
    try{
      _player.startPlayer(
          fromURI: message.content,
          whenFinished: (){
            isPlaying.value = false;
          }
      );
      isPlaying.value = true;
    }
    catch(e){
      print('Error in Playing Audio: $e');
    }
  }

  stopAudio() async{
    try{
      await _player.stopPlayer();
      isPlaying.value = false;
    }
    catch(e){
      print("Error in Stoping Audio: $e");
    }
  }


  buildMessageList(String from, String to) {
    String chatId = '$from - $to';
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
          stream: _connection.getSpecificChat(chatId),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData){
              msgList.clear();
              snapshot.data!.docs.forEach((doc) {
                var map = doc.data() as Map<String, dynamic>;
                Message msg = Message(
                  from: map['from'],
                  to: map['to'],
                  type: map['type'],
                  content: map['content'],
                  timeStamp: map['timeStamp'],
                  duration: map['duration'],
                  isPlaying: map['isPlaying'],
                );
                msgList.add(msg);
                // print(msgList);
              });
              if (msgList.isEmpty) {
                return const Center(
                  child: Text(
                    'No Messages Available,Start a New Chat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              // else if(snapshot.connectionState == ConnectionState.waiting){
              //   return const Center(child: CircularProgressIndicator(),);
              // }
              else {
                return ListView.builder(
                    itemCount: msgList.length,
                    itemBuilder: (context, index) {
                      if(msgList[index].type == 'Audio'){
                        return ListTile(
                          title: msgList[index].from == from ?
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(left: 50.0,right: 5.0,top: 5.0,bottom: 5.0),
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() {
                                        return IconButton(
                                          icon: isPlaying.value ? const Icon(Icons.pause, color: Colors.black,size: 25.0,) : const Icon(Icons.play_arrow, color: Colors.black, size: 25.0,),
                                          onPressed: (){
                                            if(isPlaying.value){
                                              stopAudio();
                                            }
                                            else{
                                              playAudio(msgList[index]);
                                            }
                                          },
                                        );
                                      }),
                                      const SizedBox(),
                                      Text(msgList[index].duration,style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),),
                                    ],
                                  ),
                                ),
                              ) :
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(left: 5.0,right: 50.0,top: 5.0,bottom: 5.0),
                              padding: const EdgeInsets.all(5.0),
                              width: MediaQuery.of(context).size.width / 1.3,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    return IconButton(
                                      icon: isPlaying.value ? const Icon(Icons.pause, color: Colors.black,size: 25.0,) : const Icon(Icons.play_arrow, color: Colors.black, size: 25.0,),
                                      onPressed: (){
                                        if(isPlaying.value){
                                          stopAudio();
                                        }
                                        else{
                                          playAudio(msgList[index]);
                                        }
                                      },
                                    );
                                  }),
                                  const SizedBox(),
                                  Text(msgList[index].duration,style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          subtitle: msgList[index].from == from ?
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgList[index].timeStamp))),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),),
                          ) :
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgList[index].timeStamp))),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),),
                          )
                        );
                      }
                      else if(msgList[index].type == 'Image'){
                        return ListTile(
                          title: msgList[index].from == from ?
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 300.0,
                              width: 240.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3.0,
                                )
                              ),
                              child: Image.file(File(msgList[index].content!),fit: BoxFit.fitWidth,),
                            ),
                          )
                          :
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 300.0,
                              width: 240.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3.0,
                                  )
                              ),
                              child: Image.file(File(msgList[index].content!),fit: BoxFit.fitWidth,),
                            ),
                          ),
                          subtitle: msgList[index].from == from ?
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgList[index].timeStamp))),
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )
                              :
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgList[index].timeStamp))),
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          onTap: (){
                            Get.toNamed('/show_image',arguments: File(msgList[index].content!));
                          },
                        );
                      }
                      return ListTile(
                        title: msgList[index].from == from ?
                        Align(
                          alignment: Alignment.centerRight,
                          child: Card(
                            color: Colors.lightBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(msgList[index].content!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 15.0,
                                    ),),
                                  const SizedBox(height: 4),
                                  Text(DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgList[index].timeStamp))),
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ) :
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            color: Colors.lightGreen,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(msgList[index].content!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 15.0,
                                    ),),
                                  const SizedBox(height: 4),
                                  Text(DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgList[index].timeStamp))),
                                    style: const TextStyle(
                                      color: Colors.purple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                );
              }
            }
            // else if(snapshot.connectionState == ConnectionState.waiting){
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            else{
              return const Center(
                child: Text('No Messages..',style: TextStyle(
                  fontFamily: 'Poppins',
                ),),
              );
            }
          }
      ),
    );
  }

  List<Message> get messageList => msgList;

  sendMessage(String from, String to) async{
    if(text.text.isNotEmpty){
      Message message = Message(
          from: from,
          to: to,
          type: 'message',
          content: text.text,
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          duration: '',
          isPlaying: false,
      );
      String chatId = '$from - $to';
      String chatId2 = '$to - $from';
      _connection.sendMessage(chatId, chatId2, message);
      update();
      text.clear();
    }
    else{
      showToast('Empty Message', Colors.red);
    }
  }

  sendAudioMsg(Message message, String chatId) async{
    String from = chatId.split(' - ')[0];
    String to = chatId.split(' - ')[1];
    String chatId2 = '$to - $from';
    _connection.sendMessage(chatId, chatId2, message);
    update();
  }

  sendImage(Message message, String chatId) async{
    String from = chatId.split(' - ')[0];
    String to = chatId.split(' - ')[1];
    String chatId2 = '$to - $from';
    _connection.sendMessage(chatId, chatId2, message);
    update();
  }
}