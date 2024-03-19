import 'package:get/get.dart';


String? validateName(String? name) {
  if (name != null && name.trim().isNotEmpty) {
    if (name.trim().replaceAll(' ', '').isAlphabetOnly) {
      return null;
    } else {
      return 'Name must contain only alphabets and spaces';
    }
  } else {
    return 'Name should not be empty';
  }
}


String? validatePhone(String? phone){
  if(phone!.isNotEmpty){
    if(phone.isPhoneNumber){
      return null;
    }
    else{
      return 'Phone Number must contain only 10 Digits';
    }
  }
  else{
    return 'Phone Number must be Empty';
  }
}

String? validateText(String? text){
  if(text != null || text!.isNotEmpty){
    return null;
  }
  else{
    return 'Empty Text';
  }
}