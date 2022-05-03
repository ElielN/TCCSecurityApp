import 'dart:io';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          children: [
            Container(
              /*decoration: BoxDecoration(
                  border: Border.all()
              ),*/
              margin: const EdgeInsets.only(top: 40.0, bottom: 0.0),
              child: Image.asset(
                "assets/images/brasao_ufv.png",
                height: 300.0,
                width: 300.0,
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
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffffffff),
                  fixedSize: const Size(340, 45),
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
                      style: TextStyle(color: Colors.black),

                    )
                  ],
                )
            ),
            const Divider(height: 10, color: Colors.transparent),
            Row(
              children: const [
                VerticalDivider(
                  width: 50,
                  color: Colors.black,

                ),
                VerticalDivider(
                  width: 50,
                  color: Colors.black,
                ),
              ],
            ),
            const Text(
              "ou",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black
              ),
            ),
          ],
        ),
      ),
    );

  }
}

