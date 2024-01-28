import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quick_chat/screens/chat.dart';
import 'package:quick_chat/screens/splash.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
    
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(), builder: (ctx,snapshot) {
      if(snapshot.connectionState ==ConnectionState.waiting){
return SplashScreen();
      }
        if(snapshot.hasData) 
        {
          return ChatScreen();
        }
        return AuthScreen();
      }), //similiar to future builder, only diff is that future is done once it resolved produce only one value ,while stream prduces multiple values 
    );
  }
}