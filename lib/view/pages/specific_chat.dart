import 'dart:async';

import 'package:chat_app/model/add_contact_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/view/widgets/show_toast.dart';
import 'package:chat_app/view_model/specific_chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificChat extends StatefulWidget {
  const SpecificChat({super.key});

  @override
  State<SpecificChat> createState() => _SpecificChatState();
}

class _SpecificChatState extends State<SpecificChat> {

  SpecificChatViewModel _chatViewModel = SpecificChatViewModel();
  AddContact contact = Get.arguments;

  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false,isSpeaking = false;
  String recordedPath = '';
  Duration _recDuration = Duration.zero;
  late Timer _timer;

  getPermission() async{
    var status = await Permission.audio.status;
    if(status.isProvisional || status.isDenied){
      var result = await Permission.microphone.request();
      if(result.isGranted){
        return true;
      }
      else{
        return false;
      }
    }
    else if(status.isPermanentlyDenied){
      showToast('Permission has been denied Permantly in Your Mobile Phone', Colors.red);
    }
    else if(status.isGranted){
      return true;
    }
  }

  getCallPermission() async{
    var status = await Permission.phone.status;
    if(status.isProvisional || status.isDenied){
      var result = await Permission.phone.request();
      if(result.isGranted){
        return true;
      }
      else{
        return false;
      }
    }
    else if(status.isPermanentlyDenied){
      showToast('Call Permission has been denied Permanently in Your Mobile Phone', Colors.red);
    }
    else if(status.isGranted){
      return true;
    }
  }

  makeCall(String phoneNum) async{
    try{
      bool isPermited = await getCallPermission();
      if(isPermited){
        final phone = 'tel:$phoneNum';
        final url = Uri.parse(phone);
        if(await canLaunchUrl(url)){
          await launchUrl(url);
        }
        else{
          showToast("Can't able to make a call right now", Colors.red);
        }
      }
    }
    catch(e){
      print('Error in Calling : $e');
    }
  }



  @override
  void initState() {
    super.initState();
    _recorder.openRecorder().then((value) {
      print('Audio session initialized');
    }).catchError((error) {
      print('Error initializing audio session: $error');
    });
    _chatViewModel.initializePlayer();
    _initSpeech();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _chatViewModel.scrollController.jumpTo(_chatViewModel.scrollController.position.maxScrollExtent);
    // });
  }

  @override
  void dispose(){
    super.dispose();
    _recorder.closeRecorder();
    _timer?.cancel();
  }



  startRecording() async {
    try {
      bool isGranted = await getPermission();
      if(isGranted) {
        setState(() {
          _recDuration = Duration.zero;
        });
        await _recorder.startRecorder(toFile: 'example_${DateTime.now().millisecondsSinceEpoch.toString()}');
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _recDuration = _recDuration + Duration(seconds: 1);
          });
        });
      }
      else{
        showToast('Permission Denied', Colors.red);
      }
    } catch (e) {
      print('Error in Recording Audio: $e');
    }
  }

  stopRecording() async {
    try {
      String? path = await _recorder.stopRecorder();
      _timer.cancel();
      print('Duration: $_recDuration');
      Message message = Message(
          from: contact.createdBy!,
          to: contact.phoneNum!,
          type: 'Audio',
          content: path!,
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          duration: _recDuration.toString().split(".")[0],
          isPlaying: false
      );
      _chatViewModel.sendAudioMsg(message, '${contact.createdBy!} - ${contact.phoneNum!}');
      setState(() {
        _recDuration = Duration.zero;
      });
    } catch (e) {
      print('Error in Stop Recording Audio: $e');
    }
  }

  final SpeechToText _speechToText = SpeechToText();
  bool isSpeechEnabled = false;
  String words = '';

  _initSpeech() async{
    isSpeechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void startListening() async{
    await _speechToText.listen(onResult: _speechResult,listenFor: Duration(minutes: 15));
    print('Listening');
    setState(() {});
  }

  void stopListening() async{
    await _speechToText.stop();
    print('Stopped');
    setState(() {});
  }

  _speechResult(SpeechRecognitionResult result){
    if(result.finalResult){
      String combined = '$words ${result.recognizedWords}';
      print('Combined: $combined');
      words = '';
      words = combined;
      print('Words: $words');
      // setState(() {
      _chatViewModel.text.text = words;
      // });
      if(isSpeaking){
        startListening();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(contact.name!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins',fontSize: 16.0),),
        actions:  [
          IconButton(
            onPressed: (){
              makeCall(contact.phoneNum!);
            },
            icon: const Icon(Icons.call_sharp,color: Colors.green),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _chatViewModel.buildMessageList(contact.createdBy!, contact.phoneNum!),
              Container(
                alignment: Alignment.bottomLeft,
                color: Colors.white,
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isRecording ?
                    Row(
                      children: [
                        const Text('Audio Recording : ',style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        )),
                        const SizedBox(width: 5.0,),
                        Text('${_recDuration.inMinutes.toString().padLeft(2, '0')}:${(_recDuration.inSeconds % 60).toString().padLeft(2, '0')}'),
                        const SizedBox(width: 10.0,),
                        IconButton(
                          onPressed: (){
                            stopRecording();
                            setState(() {
                              // _timer.cancel();
                              _recDuration = Duration.zero;
                              isRecording = false;
                            });
                            showToast('Audio Deleted and Not Sent', Colors.green);
                          },
                          icon: const Icon(Icons.delete_outline,color: Colors.red,size: 25.0,),
                        )
                      ],
                    )
                    : Expanded(child: _chatViewModel.buildMsgText()),
                    IconButton(
                        onPressed: (){
                          setState(() {
                            isRecording = !isRecording;
                          });
                          if(isRecording){
                            startRecording();
                          }
                          else{
                            stopRecording();
                          }
                        },
                        icon: isRecording ? const Icon(Icons.mic, color: Colors.red, size: 45.0,) : const Icon(Icons.mic_off, color: Colors.blue, size: 25.0,)
                    ),
                    !isRecording ? IconButton(
                        onPressed: (){
                          Message message = Message(
                              from: contact.createdBy!,
                              to: contact.phoneNum!,
                              type: 'Image',
                              content: '',
                              timeStamp: '',
                              duration: '',
                              isPlaying: false,
                          );
                          Get.toNamed('/take_image', arguments: message);
                        },
                        icon: const Icon(Icons.camera_alt_outlined,color: Colors.orange,)
                    ) : const SizedBox(),
                    !isRecording ? IconButton(
                        onPressed: () async{
                          _chatViewModel.sendMessage(contact.createdBy!, contact.phoneNum!);
                        },
                        icon: const Icon(Icons.send,color: Colors.blue,)
                    ) : const SizedBox()
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 90.0,
            right: 10.0,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  isSpeaking = !isSpeaking;
                });
                if(isSpeaking){
                  startListening();
                }
                else{
                  stopListening();
                }
              },
              tooltip: 'Speech to Text',
              child: isSpeaking
                  ? const Icon(Icons.stop_circle_outlined, color: Colors.red)
                  : const Icon(Icons.not_started_outlined, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
