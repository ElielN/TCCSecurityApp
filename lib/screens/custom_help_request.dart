import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tcc_security_app/screens/sos.dart';

class CustomHelpPage extends StatefulWidget {
  const CustomHelpPage({Key? key}) : super(key: key);

  @override
  State<CustomHelpPage> createState() => _CustomHelpPageState();
}

class _CustomHelpPageState extends State<CustomHelpPage> {

  String? buttonSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      drawer: const Drawer(),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: Image.asset(
                  "assets/images/brasao_ufv.png",
                  height: 200.0,
                  width: 200.0,
                ),
              ),
              const Text(
                "Selecione a gravidade do pedido",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              const Divider(height: 25, color: Colors.transparent,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonOrderSeverity("Baixa", 0xffffffff),
                  const VerticalDivider(width: 10, color: Colors.transparent),
                  buttonOrderSeverity("Média", 0xff5ac4ff),
                  const VerticalDivider(width: 10, color: Colors.transparent),
                  buttonOrderSeverity("Alta", 0xffffef5c)
                ],
              ),
              const Divider(height: 35, color: Colors.transparent),
              const Text(
                "Título",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              const Divider(height: 10, color: Colors.transparent),
              SizedBox(
                width: 340,
                child: TextFormField(
                  maxLength: 20,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(19.0))
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Escreva um título",
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w100
                    ),
                  ),
                ),
              ),
              const Divider(height: 20, color: Colors.transparent),
              const Text(
                "Descrição breve do pedido",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              const Divider(height: 10, color: Colors.transparent),
              SizedBox(
                width: 340,
                child: TextFormField(
                  maxLength: 50,
                  maxLines: 4,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(19.0))
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Escreva um título",
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w100
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonConfirmCancel("Confirmar", 0xff4caf50),
                  const VerticalDivider(width: 10, color: Colors.transparent),
                  buttonConfirmCancel("Cancelar", 0xfff03131)
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  Widget buttonConfirmCancel(String text, int buttonColor) {
    return ElevatedButton(
        onPressed: () {
          if(text == "Confirmar") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SOSPage()),
            );
          } else {
            if (text == "Cancelar") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SOSPage()),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
            primary: Color(buttonColor),
            fixedSize: const Size(150, 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            )
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        )
    );
  }

  Widget buttonOrderSeverity(String label, int buttonColor) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            buttonSelected = label;
          });
        },
        style: ElevatedButton.styleFrom(
            primary: (buttonSelected == label || buttonSelected == null) ? Color(buttonColor) : const Color(0xffcdcdcd),
            fixedSize: const Size(110, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            )
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: Colors.black
          ),
        )
    );
  }
}
