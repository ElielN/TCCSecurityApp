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
  bool _obscurePassword = true;

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
    return StatefulBuilder(
      builder: (context, setState){
        return AlertDialog(
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          content: SizedBox(
              width: 350.0,
              height: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 15),
                    child: Text('test'),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: (){
                            setState((){
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: _obscurePassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 10),
                        width: 200,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: const InputDecoration(
                            labelText: "senha",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0,bottom: 10),
                        child: ElevatedButton(
                            onPressed: (){
                              setState(() {

                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                                elevation: 13.0,
                                fixedSize: const Size(120, 20),
                                textStyle: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800
                                )
                            ),
                            child: const Text("Enviar")
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 10),
                        child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                                elevation: 13.0,
                                fixedSize: const Size(120, 20),
                                textStyle: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800
                                )
                            ),
                            child: const Text("Cancelar")
                        ),
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
