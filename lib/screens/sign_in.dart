import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc_security_app/screens/sign_up.dart';
import 'package:tcc_security_app/screens/sos.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../shared/models/user.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GoogleSignIn googleSingIn = GoogleSignIn();

  User? _currentUser;
  late CurrentUser userObj;

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
      userObj = CurrentUser(_currentUser!.displayName!, _currentUser!.email!, avatar: _currentUser!.photoURL!, loginByGoogle: true);
      if (!(await _emailAlreadyExists(_currentUser?.email))) {
        final userByGoogle = <String, dynamic>{
          "email": _currentUser?.email,
          "name": _currentUser?.displayName,
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
            content: Text("Apenas e-mails da UFV são permitidos"),
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
              content: Text("Apenas e-mails da UFV são permitidos"),
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

    if (!(await _emailAlreadyExists(userAuth?.email))) {
      final userByGoogle = <String, dynamic>{
        "email": userAuth?.email,
        "name": userAuth?.displayName,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth?.email)
          .set(userByGoogle);

      userObj = CurrentUser(userAuth!.displayName!, userAuth.email!, avatar: userAuth.photoURL!, loginByGoogle: true);
    } else {
      var docSnapshot = await FirebaseFirestore.instance.collection("users").doc(userAuth?.email!).get();
      if(docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        userObj = CurrentUser(data!["name"], data!["email"], avatar: userAuth!.photoURL!, loginByGoogle: true);
      }
      print("O usuário já existe no banco de dados");
    }
    return userAuth;
  }

  Future<bool> _signIn() async {
    var docSnapshot = await FirebaseFirestore.instance.collection("users").doc(emailController.text).get();
    if(docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      if(passwordController.text == data!["password"]){
        userObj = CurrentUser(data!["name"], data!["email"], loginByGoogle: false);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      fontWeight: FontWeight.bold
                  ),
                ),
                const Text(
                  "Faça login para continuar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const Divider(height: 80, color: Colors.transparent),
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
                            borderRadius: BorderRadius.circular(10.0)
                        )
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: Image.asset(
                            "assets/icons/google_icon.png",
                            height: 28,
                            width: 28,
                          ),
                        ),
                        const Text(
                          "Entrar com a conta Google da UFV",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12
                          ),
                        )
                      ],
                    )
                ),
                const Divider(height: 20, color: Colors.transparent),
                const Text(
                  "ou",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 12
                  ),
                ),
                const Divider(height: 20, color: Colors.transparent),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      buildTextInput("Digite seu e-mail institucional", emailController),
                      const Divider(height: 20, color: Colors.transparent),
                      buildTextInput("Digite sua senha", passwordController),
                    ],
                  ),
                ),
                const Divider(height: 10, color: Colors.transparent),
                GestureDetector(
                  onTap: () {
                    debugPrint("Esqueci minha senha");
                  },
                  child: const Text(
                    "Esqueci minha senha",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Color(0xff1976d2)
                    ),
                  ),
                ),
                const Divider(height: 5, color: Colors.transparent),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Color(0xff1976d2)
                    ),
                  ),
                ),
                const Divider(height: 30, color: Colors.transparent),
                ElevatedButton(
                    onPressed: () async {
                      if(await _signIn()){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SOSPage(currentUser: userObj)),
                        );
                      } else {
                        emailController.clear();
                        passwordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("E-mail e/ou senha inválidos :("),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xff5ac4ff),
                        fixedSize: const Size(213, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        )
                    ),
                    child: const Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        )
                    )
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget buildTextInput(String label, TextEditingController inputController) {
    return TextFormField(
      controller: inputController,
      obscureText: (label == "Digite sua senha") ? true : false,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w100
        ),
      ),
    );
  }
}
