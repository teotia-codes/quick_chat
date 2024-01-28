import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
 const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Chat',style: GoogleFonts.patrickHand(fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Text('Loading'),
      ),
    );
  }
}