import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({Key? key}) : super(key: key);

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {

  int sosColor = 0xfff03131;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: () => {},
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
}
