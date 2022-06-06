import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tcc_security_app/Widgets/drawer.dart';
import 'package:tcc_security_app/screens/custom_help_request.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({Key? key}) : super(key: key);

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {

  final TextEditingController _passwordController = TextEditingController();

  int sosColor = 0xfff03131;
  final bool _obscurePassword = true;
  /*
  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      backgroundColor: const Color(0xffe5e5e5),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 0.0),
              child: Image.asset(
                "assets/images/brasao_ufv.png",
                height: 200.0,
                width: 200.0,
              ),
            ),
            const Divider(height: 20, color: Colors.transparent),
            GestureDetector(
              onTap: () {
                setState(() {
                  if(sosColor == 0xfff03131) {
                    sosColor = 0xff4caf50;
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return alertDialogPassword();
                      }
                    );
                    sosColor = 0xfff03131;
                  }
                });
              },
              child: Container(
                height: 260,
                width: 260,
                decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: const BorderRadius.all(Radius.circular(200)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(sosColor),
                        spreadRadius: 8,
                        blurRadius: 10,
                      )
                    ]
                ),
                child: const Center(
                  child: Text(
                    "SOS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 60,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 40, color: Colors.transparent),
            buildButton("Pedido de ajuda personalizado", 0xfff03131),
            const Divider(height: 20, color: Colors.transparent),
            buildButton("Abrir mapa de pedidos", 0xff4caf50),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text, int color) {
    return ElevatedButton(
        onPressed: () {
          if(text == "Pedido de ajuda personalizado") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustomHelpPage()),
            );
          } else {
            if(text == "Abrir mapa de pedidos") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomHelpPage()),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
            primary: Color(color),
            fixedSize: const Size(275, 60),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            )
        ),
        child: Text(
            text,
            style: const TextStyle(
              color: Color(0xffffffff),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500
            )
        )
    );
  }

  Widget alertDialogPassword(){
    /*
    final user = <String, dynamic>{
      "first": "Ada",
      "last": "Lovelace",
      "born": 1815
    };
    FirebaseFirestore.instance.collection('teste').add(user);
    */
    return StatefulBuilder(
      builder: (context, setState){
        return AlertDialog(
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(19.0))
          ),
          content: SizedBox(
              width: 350.0,
              height: 320.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 15),
                    child: Center(
                      child: Text(
                        "!",
                        style: TextStyle(
                          color: Color(0xffbe212f),
                          fontSize: 60,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Digite sua senha para desativar o pedido de ajuda urgente",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ),
                  const Divider(height: 20, color: Colors.transparent),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      filled: true,
                      fillColor: Color(0x20c4c4c4),
                      hintText: "Digite sua senha",
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w100
                      ),
                    ),
                  ),
                  const Divider(height: 40, color: Colors.transparent),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            setState(() {

                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xff4caf50),
                              elevation: 5.0,
                              fixedSize: const Size(123, 40),
                              textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800
                              )
                          ),
                          child: const Text("Confirmar")
                      ),
                      const VerticalDivider(width: 20, color: Colors.transparent),
                      ElevatedButton(
                          onPressed: (){
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xfff03131),
                              elevation: 5.0,
                              fixedSize: const Size(123, 40),
                              textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800
                              )
                          ),
                          child: const Text("Cancelar")
                      ),
                    ],
                  ),
                ],
              )
          ),
        );
      },
    );
  }
}
