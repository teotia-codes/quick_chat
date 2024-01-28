import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<StatefulWidget> createState() {
   
   return  _NewMessage();
  }
}
class _NewMessage extends State<NewMessage> {
 final  _messageController = TextEditingController();
  @override
  void dispose() {
_messageController.dispose();
    super.dispose();
  }
  void submitMessage()async {
final enteredMessage = _messageController.text;
_messageController.clear();
if(enteredMessage.trim().isEmpty) {
  return;
}
FocusScope.of(context).unfocus();
final user = FirebaseAuth.instance.currentUser;
final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
FirebaseFirestore.instance.collection('chat').add({
  'text' : enteredMessage,
  'createdAt' : Timestamp.now(),
  'userID' : user.uid,
  'username' : userData.data()?['username'],
  'userImage' : userData.data()?['image_url'],
});


  }
  @override
  Widget build(BuildContext context) {
 return Padding(padding: EdgeInsets.only(left: 15,right: 1,bottom: 14),
 child: Row(
  children: [Expanded(child: TextField(
    autocorrect: true,
    enableSuggestions: true,
    decoration: InputDecoration(
      labelText: 'Message',
    ),
    controller: _messageController,
  )),
  IconButton(onPressed: submitMessage, icon: Icon(Icons.send))],
 ),);
  }
}