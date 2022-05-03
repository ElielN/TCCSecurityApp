import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({Key? key}) : super(key: key);

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
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
              margin: const EdgeInsets.only(top: 20.0, bottom: 0.0),
              child: Image.asset(
                "assets/images/brasao_ufv.png",
                height: 200.0,
                width: 200.0,
              ),
            ),
            const Divider(height: 20, color: Colors.transparent),
            Container(
              height: 260,
              width: 260,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.all(Radius.circular(200)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xfff03131),
                    spreadRadius: 8,
                    blurRadius: 10,
                  )
                ]
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
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

            )
          ],
        ),
      ),
    );
  }
}
