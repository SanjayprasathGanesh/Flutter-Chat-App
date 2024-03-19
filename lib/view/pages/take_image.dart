import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_app/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/message_model.dart';

class TakeImage extends StatefulWidget {
  const TakeImage({super.key});

  @override
  State<TakeImage> createState() => _TakeImageState();
}

class _TakeImageState extends State<TakeImage> {

  bool onFlash = false, isFlipped = false;

  late CameraController _controller;
  late Future<void> _initializeFutureController;
  File? image;

  Message message = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    if(Platform.isAndroid){
      _controller.resumePreview();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  _initializeCamera() async{
    try{
      final cameras = await availableCameras();
      final frstCam = cameras.first;
      _controller = CameraController(frstCam, ResolutionPreset.high);
      setState(() {
        _initializeFutureController = _controller.initialize();
      });
    }
    catch(e){
      print('Error in Initializing Camera : $e');
    }
  }

  takeImage() async{
    try{
      bool isPermitted = await getCamPermissions();
      if(isPermitted){
        await _initializeFutureController;
        var image = await _controller.takePicture();
        print('I: ${image.path}');
        if(image != null){
          var cap_img = File(image.path);
          print('Tap');
          Message msg = Message(
              from: message.from,
              to: message.to,
              type: message.type,
              content: image.path,
              timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
              duration: '',
              isPlaying: false
          );

          Map<String, dynamic> arguments = {
            'msg': msg,
            'imagePath': cap_img,
          };

          Get.toNamed('/send_image',arguments: arguments)?.then((value) => {
            if(value != null && value == 1){
              Get.back()
            }
          });
        }
      }
    }
    catch(e){
      print('Error in Taking Image: $e');
    }
  }

  getCamPermissions() async{
    var status = await Permission.camera.status;
    if(status.isDenied || status.isProvisional){
      var result = await Permission.camera.request();
      if(result.isGranted){
        return true;
      }
      else{
        return false;
      }
    }
    else if(status.isGranted){
      return true;
    }
    else{
      showToast('Camera Permission Denied Permanently', Colors.red);
      return false;
    }
  }

  getGalleryPermissions() async{
    var status = await Permission.storage.status;
    if(status.isDenied || status.isProvisional){
      var result = await Permission.storage.request();
      if(result.isGranted){
        return true;
      }
      else{
        return false;
      }
    }
    else if(status.isGranted){
      return true;
    }
    else{
      showToast('Storage Permission Denied Permanently', Colors.red);
      return false;
    }
  }

  pickImage() async{
    try{
      bool permission = await getGalleryPermissions();
      if(permission) {
        final ImagePicker _imagePicker = ImagePicker();
        final pickedImage = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: MediaQuery.of(context).size.width,
        );
        print('Image: ${pickedImage?.path!}');
        setState(() {
          if (pickedImage != null) {
            image = File(pickedImage.path);
          }
        });
        Message msg = Message(
            from: message.from,
            to: message.to,
            type: message.type,
            content: image!.path,
            timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
            duration: '',
            isPlaying: false
        );

        Map<String, dynamic> arguments = {
          'msg': msg,
          'imagePath': image,
        };

        Get.toNamed('/send_image',arguments: arguments)?.then((value) => {
          if(value != null && value == 1){
            Get.back()
          }
        });
      }
    }
    catch(e){
      print('Error in Picking Image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Take Image',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 17.0,
          fontFamily: 'Poppins',
        ),),
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  onFlash = !onFlash;
                });
                if(onFlash){
                  _controller.setFlashMode(FlashMode.torch);
                }
                else{
                  _controller.setFlashMode(FlashMode.off);
                }
              },
              icon: onFlash ? const Icon(Icons.flash_off,color: Colors.black,) : const Icon(Icons.flash_on,color: Colors.white,),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10.0),
        child: FutureBuilder<void>(
          future: _initializeFutureController,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return CameraPreview(_controller);
            }
            else{
              return const Center(child: CircularProgressIndicator(color: Colors.black,),);
            }
          },
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.black,
              child: IconButton(
                onPressed: () async{
                  setState(() {
                    isFlipped = !isFlipped;
                  });
                  if(isFlipped){
                    final cam = await availableCameras();
                    _controller = CameraController(cam[1], ResolutionPreset.high);
                    setState(() {
                      _initializeFutureController = _controller.initialize();
                    });
                  }
                  else{
                    final cam = await availableCameras();
                    _controller = CameraController(cam[0], ResolutionPreset.high);
                    setState(() {
                      _initializeFutureController = _controller.initialize();
                    });
                  }
                },
                icon: const Icon(Icons.flip_camera_android,color: Colors.white,size: 25.0,),
              ),
            ),
            const SizedBox(width: 10.0,),
            CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.blue,
                // child: GestureDetector(
                //   onTap: (){
                //     print('Tap 2');
                //     takeImage();
                //   },
                //   child: const Text(''),
                // )
                child: IconButton(
                    onPressed: () async{
                      print('Tap 2');
                      await takeImage();
                    },
                    icon: Icon(Icons.camera),
                ),
            ),
            const SizedBox(width: 10.0,),
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.black,
              child: GestureDetector(
                onTap: (){
                  pickImage();
                },
                child: const Icon(Icons.photo_library_outlined,color: Colors.white,size: 30.0,)
              ),
            )

          ],
        )
      ],
    );
  }
}
