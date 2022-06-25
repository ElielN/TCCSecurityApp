import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc_security_app/screens/sos.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:email_validator/email_validator.dart';

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
    if (_currentUser != null) return _currentUser;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
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

          user = userCredential.user;
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

    if (!(await _emailAlreadyExists(user?.email))) {
      final userByGoogle = <String, dynamic>{
        "email": user?.email,
        "name": user?.displayName,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(user?.email)
          .set(userByGoogle);
    } else {
      print("O usuário já existe no banco de dados");
    }
    return user;
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
        content: Text("Este e-mail já está cadastrado"),
        backgroundColor: Colors.red,
      ));
      return false;
    } else {
      final user = <String, dynamic>{
        "email": emailController.text,
        "name": nameController.text,
        "password": passwordController.text
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(emailController.text)
          .set(user);
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
                              builder: (context) => const SOSPage()),
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
                              "Digite sua senha", passwordController),
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
                              builder: (context) => const SOSPage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xff5ac4ff),
                        fixedSize: const Size(213, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    child: const Text("Confirmar Cadastro",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ))),
              ],
            ),
          ),
        ));
  }

  Widget buildTextInput(String label, TextEditingController inputController) {
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
      validator: (value) {
        if (value!.isEmpty) {
          return "O preenchimento deste campo é obrigatório";
        }
        if (label == "Digite seu e-mail institucional" &&
            !_validateUFVEmail()) {
          return "Apenas e-mail da UFV é permitido";
        }
        if (label == "Digite seu e-mail institucional" && !_validateEmail()) {
          return "Este e-mail não é válido";
        }
        if (label == "Confirme seu e-mail institucional" &&
            !_validateConfirmEmail()) {
          return "E-mails diferentes";
        }
      },
    );
  }
}
