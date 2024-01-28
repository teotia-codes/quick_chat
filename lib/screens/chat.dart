import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_chat/widgets/chat_messages.dart';
import 'package:quick_chat/widgets/new_messages.dart';

class ChatScreen extends StatelessWidget {
 const ChatScreen({super.key});
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