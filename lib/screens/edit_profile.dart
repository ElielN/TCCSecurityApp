import 'package:flutter/material.dart';
import 'package:tcc_security_app/screens/sos.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
                    child: Image.asset(
                      "assets/images/random_person.jpg",
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
                    buildTextInput("Nome de exemplo"),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("email.de.exemplo@ufv.br"),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("Digite sua matrícula"),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("Digite seu CPF"),
                    const Divider(height: 20, color: Colors.transparent),
                    buildTextInput("Trocar senha"),
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
