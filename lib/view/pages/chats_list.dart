import 'package:chat_app/model/add_contact_model.dart';
import 'package:chat_app/view_model/add_contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  final AddContactViewModel _addContactViewModel = Get.find<AddContactViewModel>();
  bool isLoaded = false, isShowed = false;
  int selectedIndex = 0;

  String userNum = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addContactViewModel.getAllContact(userNum);
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ChatsList', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          letterSpacing: 1.8,
          fontFamily: 'Poppins',
        ),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () async{
                var result = await logout();
                if(result.toString() == 'true'){
                  setState(() {
                    Get.back();
                  });
                }
              },
              icon: const Icon(Icons.logout_rounded,color: Colors.red,),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.155,
          child: Obx (() => loadChatList()
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          onPressed: () async{
            var result = await Get.toNamed('/add_contact', arguments: userNum);
            if (result != null && result == 1) {
              _addContactViewModel.getAllContact(userNum);
            }
          },
          child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  loadChatList(){
    if(isLoaded && _addContactViewModel.contactList.isNotEmpty){
      return ListView.builder(
          itemCount: _addContactViewModel.contactList.length,
          itemBuilder: (context, index){
            var contact = _addContactViewModel.contactList[index];
            return Container(
              margin: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Slidable(
                    endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                              onPressed: (_) async{
                                var result = await Get.toNamed('/update_contact',arguments: contact);
                                if (result != null) {
                                  setState(() {
                                    _addContactViewModel.getAllContact(userNum);
                                  });
                                }
                              },
                              icon: Icons.edit,
                              label: 'Edit',
                              backgroundColor: Colors.green,
                          ),
                          SlidableAction(
                            onPressed: (_) async{
                              var result = await deleteContact(contact);
                              if(result.toString() == 'true'){
                                setState(() {
                                  _addContactViewModel.getAllContact(userNum);
                                });
                              }
                            },
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            backgroundColor: Colors.red,
                          ),
                        ],
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                          radius: 25.0,
                          child: Icon(Icons.person, color: Colors.black,)
                      ),
                      title: Text(contact.name!,style: const TextStyle(color: Colors.black,fontFamily: 'Poppins', fontWeight: FontWeight.bold),),
                      onTap: (){
                        Get.toNamed('/specific_chat',arguments: contact);
                      },
                    ),
                  ),
                  const Divider(indent: 75.0, endIndent: 15.0,thickness: 1.5,color: Colors.grey,),
                ],
              ),
            );
          }
      );
    }
    else if(isLoaded && _addContactViewModel.contactList.isEmpty){
      return const Center(child: Text('Empty Chats List',style: TextStyle(fontFamily: 'Poppins',),),);
    }
    else{
      return const Center(child: CircularProgressIndicator(color: Colors.black,),);
    }
  }

  deleteContact(AddContact addContact){
    Get.dialog(
      AlertDialog(
        title: const Text('Do You want to Delete this Contact, '
            'Once your delete this, then all your chats will also be deleted',
          textAlign: TextAlign.justify,
          style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: MaterialButton(
                  color: Colors.red,
                  onPressed: (){
                    _addContactViewModel.deleteContact(addContact);
                    Get.back(result: true);
                    setState(() {
                      _addContactViewModel.getAllContact(userNum);
                    });
                  },
                  child: const Text('Delete',style: TextStyle(color: Colors.black, fontFamily: 'Poppins',),),
                )
            ),
            const SizedBox(width: 10.0,),
            Expanded(
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    Get.back(result: false);
                  },
                  child: const Text('Cancel',style: TextStyle(color: Colors.black, fontFamily: 'Poppins',),),
                )
            )
          ],
        )
      )
    );
  }

  logout(){
    Get.dialog(
        AlertDialog(
            title: const Text('Do You want to Logout ',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: MaterialButton(
                      color: Colors.red,
                      onPressed: (){
                        Get.back(result: true);
                      },
                      child: const Text('Logout',style: TextStyle(color: Colors.black, fontFamily: 'Poppins',),),
                    )
                ),
                const SizedBox(width: 10.0,),
                Expanded(
                    child: MaterialButton(
                      color: Colors.green,
                      onPressed: (){
                        Get.back(result: false);
                      },
                      child: const Text('Cancel',style: TextStyle(color: Colors.black, fontFamily: 'Poppins',),),
                    )
                )
              ],
            )
        )
    );
  }
}
