import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No message found.'),
            );
          }
          if (chatSnapshots.hasError) {
            return Center(
              child: Text('Something went wrong...'),
            );
          }
          final loadedMessages = chatSnapshots.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.only(bottom: 40,left: 13,right: 13,),
            reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {   
              final chatMessages = loadedMessages[index].data();
              final nextChatMessage = index+1 <loadedMessages.length? loadedMessages[index +1].data() :null;
             final currentMessageUsername  =chatMessages['username'];
              final nextMessagetUsername = nextChatMessage != null ? nextChatMessage['username'] : null ; 
              });
        });
  }
}