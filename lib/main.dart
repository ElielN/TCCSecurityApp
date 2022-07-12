import 'package:flutter/material.dart';
import 'package:tcc_security_app/screens/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: SignInPage(),
    debugShowCheckedModeBanner: false,
  ));
  //await Firebase.initializeApp();
}

