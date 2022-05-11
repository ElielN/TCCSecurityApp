import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tcc_security_app/screens/sos.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                "Cadastre-se para continuar",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              const Divider(height: 20, color: Colors.transparent),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SOSPage()),
                    );
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
                        margin: const EdgeInsets.only(right: 5.0),
                        child: Image.asset(
                          "assets/icons/google_icon.png",
                          height: 28,
                          width: 28,
                        ),
                      ),
                      const Text(
                        "Cadastrar com a conta Google da UFV",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                        ),
                      )
                    ],
                  )
              ),
              const Divider(height: 10, color: Colors.transparent),
              const Text(
                "ou",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black
                ),
              ),
              const Divider(height: 10, color: Colors.transparent),
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    buildTextInput("Digite seu nome"),
                    const Divider(height: 10, color: Colors.transparent),
                    buildTextInput("Digite seu e-mail institucional"),
                    const Divider(height: 10, color: Colors.transparent),
                    buildTextInput("Confirme seu e-mail institucional"),
                    const Divider(height: 10, color: Colors.transparent),
                    buildTextInput("Digite sua senha"),
                  ],
                ),
              ),
              const Divider(height: 30, color: Colors.transparent),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SOSPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xff5ac4ff),
                      fixedSize: const Size(213, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                  child: const Text(
                    "Confirmar Cadastro",
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

  Widget buildTextInput(String label) {
    return TextFormField(
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

