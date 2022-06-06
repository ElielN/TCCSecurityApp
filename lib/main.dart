import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_security_app/screens/custom_help_request.dart';
import 'package:tcc_security_app/screens/edit_profile.dart';
import 'package:tcc_security_app/screens/sign_in.dart';
import 'package:tcc_security_app/screens/sign_up.dart';
import 'package:tcc_security_app/screens/sos.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  runApp(const MaterialApp(
    home: SOSPage(),
    debugShowCheckedModeBanner: false,
  ));
  await Firebase.initializeApp();
}

