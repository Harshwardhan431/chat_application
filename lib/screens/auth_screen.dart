import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/widgets/auth/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading=false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
      File image,
    bool loginIn,
    BuildContext ctx,

  ) async {
    var authResult;
    try {
      setState(() {
        _isLoading=true;
      });
      if (loginIn) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

       final ref= FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(authResult.user.uid+'.jpg');
       
       await ref.putFile(image);

       final url=await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
          'image_url':url,
        });
      }
    } on PlatformException catch (err) {
      String? message = 'An error occured plzz check your credianals';

      if (err.message != null) {
        message = err.message;

        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }
      setState(() {
        _isLoading=false;
      });
    } catch (er) {
      print(er);
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(_submitAuthForm,_isLoading),
    );
  }
}
