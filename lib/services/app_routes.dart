import 'package:chat_app/view/pages/show_img.dart';
import 'package:chat_app/view/pages/specific_chat.dart';
import 'package:chat_app/view/pages/take_image.dart';
import 'package:get/get.dart';

import '../view/pages/add_contact.dart';
import '../view/pages/chats_list.dart';
import '../view/pages/send_image.dart';
import '../view/pages/signup.dart';
import '../view/pages/update_contact.dart';

appRoutes() => [
  GetPage(name: '/chats_list', page: () => const ChatsList()),
  GetPage(name: '/add_contact', page: () => const AddNewContact(),transition: Transition.fadeIn, transitionDuration: const Duration(seconds: 2)),
  GetPage(name: '/specific_chat', page: () => const SpecificChat()),
  GetPage(name: '/take_image', page: () => const TakeImage()),
  GetPage(name: '/send_image', page: () => const SendImage()),
  GetPage(name: '/signup', page: () => const RegisterContact()),
  GetPage(name: '/update_contact', page: () => const UpdateContact()),
  GetPage(name: '/show_image', page: () => const ShowImage(),transition: Transition.zoom, transitionDuration: const Duration(seconds: 1)),
];