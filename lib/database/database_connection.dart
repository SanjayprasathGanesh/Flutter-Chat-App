import 'package:chat_app/model/add_contact_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseConnection{
  Future<void> addContact(AddContact addContact) async{
    return await FirebaseFirestore
        .instance
        .collection('contacts')
        .doc()
        .set(addContact.toJson(addContact));
  }

  Future<void> updateContact(AddContact addContact, AddContact updated) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('contacts')
        .where('name', isEqualTo: addContact.name)
        .where('phoneNum', isEqualTo: addContact.phoneNum)
        .where('createdBy', isEqualTo: addContact.createdBy)
        .get();

    String docId = querySnapshot.docs[0].id!;

    return await FirebaseFirestore
        .instance
        .collection('contacts')
        .doc(docId)
        .update(updated.toJson(updated));
  }

  Future<void> deleteContact(AddContact addContact) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('contacts')
        .where('name', isEqualTo: addContact.name)
        .where('phoneNum', isEqualTo: addContact.phoneNum)
        .where('createdBy', isEqualTo: addContact.createdBy)
        .get();

    String docId = querySnapshot.docs[0].id!;

    return await FirebaseFirestore
        .instance
        .collection('contacts')
        .doc(docId)
        .delete();
  }

  Future<bool> login(String phone) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('login')
        .where('phoneNum', isEqualTo: phone)
        .get();

    if(querySnapshot.docs.isNotEmpty){
      return true;
    }
    else{
      return false;
    }
  }

  addUser(AddContact addContact) async{
    return await FirebaseFirestore
        .instance
        .collection('login')
        .doc()
        .set(addContact.toJson(addContact));
  }

  Future<QuerySnapshot> getAllContact(String createdBy) async{
    return await FirebaseFirestore
        .instance
        .collection('contacts')
        .where('createdBy', isEqualTo: createdBy)
        .get();
  }
  
  Future<bool> checkContactExist(AddContact addContact) async{
    QuerySnapshot querySnapshot =  await FirebaseFirestore
        .instance
        .collection('contacts')
        .where('name', isEqualTo: addContact.name)
        .where('phoneNum', isEqualTo: addContact.phoneNum)
        .where('createdBy', isEqualTo: addContact.createdBy)
        .get();

    if(querySnapshot.docs.isNotEmpty){
      return true;
    }
    return false;
  }

  Future<bool> checkUserExist(AddContact addContact) async{
    QuerySnapshot querySnapshot =  await FirebaseFirestore
        .instance
        .collection('login')
        .where('name', isEqualTo: addContact.name)
        .where('phoneNum', isEqualTo: addContact.phoneNum)
        .where('createdBy', isEqualTo: addContact.createdBy)
        .get();

    if(querySnapshot.docs.isNotEmpty){
      return true;
    }
    return false;
  }

  Future<void> sendMessage(String chatId, String chatId2, Message message) async{
    DocumentReference documentReference = FirebaseFirestore
        .instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.set(documentReference, message.toJson());
    });

    DocumentReference documentReference2 = FirebaseFirestore
        .instance
        .collection('messages')
        .doc(chatId2)
        .collection(chatId2)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.set(documentReference2, message.toJson());
    });
  }

  Future<bool> checkMessage(String groupChatId) async{
    QuerySnapshot<Map<String, dynamic>> q1 = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .get();

    print('Q size: ${q1.docs.isEmpty}');
    return q1.docs.isEmpty;
  }

  Stream<QuerySnapshot> getSpecificChat(String groupChatId) {
    return FirebaseFirestore
        .instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }
}