import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_chat/widgets/chat_messages.dart';
import 'package:quick_chat/widgets/new_messages.dart';

class ChatScreen extends StatefulWidget {
 const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 void setupPushNotification() async {
 final fcm = FirebaseMessaging.instance;
  fcm.requestPermission();
await fcm.requestPermission();
final token = await fcm.getToken();
print('Fcm reg = $token'); 
fcm.subscribeToTopic('chat');
 } 
  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Chat',style: GoogleFonts.patrickHand(
          fontSize: 36
          ,fontWeight: FontWeight.bold),),
          actions: [IconButton(color: Colors.black ,onPressed: () {
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.logout))],
      ),
      body:Column(children: [Expanded(child: ChatMessages()),
      NewMessage(),],),
    );
  }
}