import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_chat/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPass = '';
  var _isLogin = true;
  File? _selectedImage;
  var _enteredUdername = '';
  var _isAuthenticating = false;
  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid||!_isLogin && _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
         final storageRef =   FirebaseStorage.instance.ref().child('use_images').child('${userCredentials.user!.uid}.jpg');
    await  storageRef.putFile(_selectedImage!);
  final imageUrl = await  storageRef.getDownloadURL();
  await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
    'username' : _enteredUdername,
    'email' : _enteredEmail,
    'image_url' : imageUrl,
  });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating =false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset('assets/images/log.png'),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!_isLogin)
                  UserImagePicker(onPickImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },),
                  Card(
                    color: Colors.transparent,
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelText: 'Email Address',
                                      constraints:
                                          BoxConstraints(maxHeight: 30),
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  autofocus: false,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter valid email address';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredEmail = value!;
                                  },
                                ),
                               const SizedBox(height: 8,),
                                if(!_isLogin)
                                 TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      constraints:
                                          BoxConstraints(maxHeight: 30),
                                      labelText: 'Username',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                          enableSuggestions: false,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  autofocus: false,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 4 || value.isEmpty) {
                                      return 'Please enter a valid username ';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredUdername = value!;
                                  },
                                ),
                                const SizedBox(height: 8,),
                                TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      constraints:
                                          BoxConstraints(maxHeight: 30),
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  autofocus: false,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return 'Password must be atleast 6 characters long.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredPass = value!;
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                if(_isAuthenticating)
                                CircularProgressIndicator(),
                                if(!_isAuthenticating)
                                ElevatedButton(
                                  onPressed: _submit,
                                  child: Text(
                                    _isLogin ? 'Login' : 'Signup',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent),
                                ),
                                if(!_isAuthenticating)
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = _isLogin ? false : true;
                                      });
                                    },
                                    child: Text(
                                      _isLogin
                                          ? 'Create an account'
                                          : 'Already have an account',
                                      style: TextStyle(fontSize: 17),
                                    ))
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
