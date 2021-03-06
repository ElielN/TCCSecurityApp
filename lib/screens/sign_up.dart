import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc_security_app/screens/sos.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:email_validator/email_validator.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:crypt/crypt.dart';
import '../shared/models/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GoogleSignIn googleSingIn = GoogleSignIn();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? _currentUser;

  late CurrentUser userObj;

  final password = RandomPasswordGenerator();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }


  Future<bool> _emailAlreadyExists(String? userEmail) async {
    bool exist = false;
    if (userEmail != null) {
      await FirebaseFirestore.instance
          .doc("users/$userEmail")
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      return exist;
    }
    return false;
  }

  Future<User?> _signInGoogle(BuildContext context) async {
    if (_currentUser != null && _currentUser!.email!.contains("@ufv.br")) {
      userObj = CurrentUser(_currentUser!.displayName!, _currentUser!.email!, avatar: _currentUser!.photoURL!, loginByGoogle: true, number: _currentUser?.phoneNumber);
      if (!(await _emailAlreadyExists(_currentUser?.email))) {
        String newPassword = password.randomPassword(letters: true, numbers: true, passwordLength: 10);
        final passCrypt = Crypt.sha256(newPassword);
        final userByGoogle = <String, dynamic>{
          "email": _currentUser?.email,
          "name": _currentUser?.displayName,
          "loginByGoogle": true,
          "avatar": _currentUser?.photoURL,
          "password": passCrypt.toString(),
          "number": _currentUser?.phoneNumber,
          "registration": ""
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser?.email)
            .set(userByGoogle);

        userObj = CurrentUser(_currentUser!.displayName!, _currentUser!.email!, avatar: _currentUser!.photoURL!, loginByGoogle: true);
      }
      return _currentUser;
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userAuth;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        if(!userCredential.user!.email!.contains("@ufv.br")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Apenas e-mails da UFV s??o permitidos"),
            backgroundColor: Colors.red,
          ));
          await auth.currentUser!.delete();
          return null;
        } else {
          userAuth = userCredential.user;
        }
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {

          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          if(!userCredential.user!.email!.contains("@ufv.br")) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Apenas e-mails da UFV s??o permitidos"),
              backgroundColor: Colors.red,
            ));
            await googleSignIn.signOut();
            await auth.currentUser!.delete();
            return null;
          } else {
            userAuth = userCredential.user;
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            return null;
          } else if (e.code == 'invalid-credential') {
            return null;
          }
        } catch (e) {
          return null;
        }
      }
    }

    String newPassword = password.randomPassword(letters: true, numbers: true, passwordLength: 10);
    final passCrypt = Crypt.sha256(newPassword);
    if (!(await _emailAlreadyExists(userAuth?.email))) {
      final userByGoogle = <String, dynamic>{
        "email": userAuth?.email,
        "name": userAuth?.displayName,
        "loginByGoogle": true,
        "avatar": userAuth?.photoURL,
        "password": passCrypt.toString(),
        "number": "",
        "registration": ""
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth?.email)
          .set(userByGoogle);

      userObj = CurrentUser(userAuth!.displayName!, userAuth.email!, avatar: userAuth.photoURL!, loginByGoogle: true);

    } else {
      print("O usu??rio j?? existe no banco de dados");
    }
    return userAuth;
  }

  bool _validateEmail() {
    if (EmailValidator.validate(emailController.text)) return true;
    return false;
  }

  bool _validateUFVEmail() {
    emailController.text = emailController.text.replaceAll(" ", "");
    if (!emailController.text.contains("@ufv.br")) {
      return false;
    }
    return true;
  }

  bool _validateConfirmEmail() {
    confirmEmailController.text =
        confirmEmailController.text.replaceAll(" ", "");
    if (emailController.text != confirmEmailController.text) {
      return false;
    }
    return true;
  }

  Future<bool> _signUp() async {
    if (await _emailAlreadyExists(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Este e-mail j?? est?? cadastrado"),
        backgroundColor: Colors.red,
      ));
      return false;
    } else {
      passwordController.text = passwordController.text.replaceAll(" ", "");
      final passCrypt = Crypt.sha256(passwordController.text);
      final user = <String, dynamic>{
        "email": emailController.text,
        "name": nameController.text,
        "loginByGoogle": false,
        "password": passCrypt.toString(),
        "number": "",
        "registration": ""
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(emailController.text)
          .set(user);

      userObj = CurrentUser(user["name"], user["email"], loginByGoogle: false);

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffe5e5e5),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 0.0),
                  child: Image.asset(
                    "assets/images/brasao_ufv.png",
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
                const Text(
                  "Seja bem vindo!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Cadastre-se para continuar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                const Divider(height: 20, color: Colors.transparent),
                ElevatedButton(
                    onPressed: () async {
                      final User? user = await _signInGoogle(context);
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SOSPage(currentUser: userObj)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xffffffff),
                        fixedSize: const Size(300, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          child: Image.asset(
                            "assets/icons/google_icon.png",
                            height: 28,
                            width: 28,
                          ),
                        ),
                        const Text(
                          "Cadastrar com a conta Google da UFV",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )
                      ],
                    )),
                const Divider(height: 10, color: Colors.transparent),
                const Text(
                  "ou",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                ),
                const Divider(height: 10, color: Colors.transparent),
                SizedBox(
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextInput("Digite seu nome", nameController),
                          const Divider(height: 10, color: Colors.transparent),
                          buildTextInput("Digite seu e-mail institucional",
                              emailController),
                          const Divider(height: 10, color: Colors.transparent),
                          buildTextInput("Confirme seu e-mail institucional",
                              confirmEmailController),
                          const Divider(height: 10, color: Colors.transparent),
                          buildTextInput(
                              "Digite sua senha", passwordController, obscure: true),
                        ],
                      ),
                    )),
                const Divider(height: 30, color: Colors.transparent),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          await _signUp()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SOSPage(currentUser: userObj)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5ac4ff),
                        fixedSize: const Size(213, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    child: const Text("Confirmar Cadastro",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        )
                    )
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildTextInput(String label, TextEditingController inputController, {bool obscure = false}) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        hintStyle: const TextStyle(
            fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w100),
      ),
      controller: inputController,
      obscureText: obscure,
      validator: (value) {
        if (value!.isEmpty) {
          return "O preenchimento deste campo ?? obrigat??rio";
        }
        if (label == "Digite seu e-mail institucional" &&
            !_validateUFVEmail()) {
          return "Apenas e-mail da UFV ?? permitido";
        }
        if (label == "Digite seu e-mail institucional" && !_validateEmail()) {
          return "Este e-mail n??o ?? v??lido";
        }
        if (label == "Confirme seu e-mail institucional" &&
            !_validateConfirmEmail()) {
          return "E-mails diferentes";
        }
      },
    );
  }
}
