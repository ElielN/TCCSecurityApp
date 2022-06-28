import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_security_app/screens/sos.dart';

import '../shared/models/user.dart';

class EditProfilePage extends StatefulWidget {
  final CurrentUser currentUser;
  const EditProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late CurrentUser user;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if(widget.currentUser == null) {
      user = CurrentUser("name default error", "e-mail default error");
    } else {
      user = widget.currentUser;
      var docSnapshot = await FirebaseFirestore.instance.collection("users").doc(user.email).get();
      if(docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if(data!.containsKey('registration')) {
          _registrationController.text = data["registration"];
        } else {
          _registrationController.text = " ";
        }
        if(data.containsKey('cpf')) {
          _cpfController.text = data["cpf"];
        } else {
          _cpfController.text = " ";
        }
        if(data.containsKey('password')) {
          _passwordController.text = data["password"];
        } else {
          _passwordController.text = " ";
        }
        _nameController.text = data["name"];
        _emailController.text = data["email"];
      }
    }
    //super.setState(() {});
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
                  margin: const EdgeInsets.only(top:70),
                  decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff5ac4ff),
                          spreadRadius: 3,
                          blurRadius: 10,
                        )
                      ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: user.loginByGoogle ?
                      Image.network(
                        user.avatar!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ) :
                      Image.asset(
                        user.avatar!,
                        height: 150,
                        width: 150,
                      ),
                  )
              ),
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    const Divider(height: 40, color: Colors.transparent),
                    buildTextInput("Nome", _nameController, hint: _nameController.text),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("E-mail UFV", _emailController, hint: _nameController.text),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("Matrícula", _registrationController, hint: _nameController.text),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("CPF", _cpfController, hint: _nameController.text),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("Senha", _passwordController, obscure: true, hint: _nameController.text),
                  ],
                ),
              ),
              const Divider(height: 40, color: Colors.transparent),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xff5ac4ff),
                      fixedSize: const Size(213, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                  child: const Text(
                      "Salvar Alterações",
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

  Widget buildTextInput(String label, TextEditingController inputController, {bool obscure = false, String hint = ''}) {
    return TextFormField(
      controller: inputController,
      obscureText: obscure,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            //borderSide: BorderSide(color: Color(0xff5ac4ff), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        enabledBorder: const OutlineInputBorder( //Define a cor da borda do campo input antes de ser clicada
          borderSide: BorderSide(color: Colors.amber, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        focusedBorder: const OutlineInputBorder( //Define a cor da borda do campo input ao ser clicada
            borderSide: BorderSide(color: Color(0xff5ac4ff), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,

        ),
        hintText: hint,
        hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w100
        ),

      ),
    );
  }
}
