import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tcc_security_app/Widgets/drawer.dart';
import 'package:tcc_security_app/screens/custom_help_request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tcc_security_app/screens/requisition_map.dart';

import '../shared/models/user.dart';

class SOSPage extends StatefulWidget {
  final CurrentUser currentUser;
  const SOSPage({Key? key, required this.currentUser}) : super(key: key);


  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {

  int sosColor = 0xfff03131;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final bool _obscurePassword = true;

  late CurrentUser user;

  late Position currentLocation;

  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.currentUser == null) {
      user = CurrentUser("name default error", "e-mail default error");
      print(widget.currentUser.name);
    } else {
      user = widget.currentUser;
    }
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
    return position;
  }

  Future<bool> verifyPass(String pass) async {
    bool success = false;
    if(pass.contains("@ufv.br")){
      await FirebaseFirestore.instance
          .doc("users/$pass")
          .get().then((doc) {
            if(doc.exists && pass == user.email) {
              success = true;
            } else {
              success = false;
            }
      });
    } else {
      var docSnapshot = await FirebaseFirestore.instance.collection("users").doc(user.email).get();
      if(docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if(data?["password"] == pass) {
          success = true;
        } else {
          success = false;
        }
      }
    }
    return success;
  }

  void turnOnSOS(Position location) {
    final sosData = <String, dynamic>{
      "currentLocation": {
        "latitude": location.latitude,
        "longitude": location.longitude,
      },
      "description": "",
      "urgency": 4,
      "showNumber": true,
      "date": DateTime.now(),
      "userData": user.email
    };
    FirebaseFirestore.instance
        .collection('requests')
        .doc(user.email)
        .set(sosData);
  }

  void turnOffSOS() {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(user.email).delete();
  }

  Future<void> sosButton() async {
    if(sosColor == 0xfff03131) {
      if(await Geolocator.isLocationServiceEnabled()) {
        getCurrentLocation().then((value) {
          turnOnSOS(value);
          print(value.latitude);
          print(value.longitude);
          });
        setState(() {
          sosColor = 0xff4caf50;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por favor, ligue seu GPS"),
          backgroundColor: Colors.red,
        ));
        const AndroidIntent intent = AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');
        await intent.launch();
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialogPassword();
        });
      setState(() {
        sosColor = 0xfff03131;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(currentUser: user),
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
        child: SingleChildScrollView(
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
                onTap: () async {
                  sosButton();
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
        )
      ),
    );
  }

  Widget buildButton(String text, int color) {
    return ElevatedButton(
        onPressed: () {
          if(text == "Pedido de ajuda personalizado") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomHelpPage(currentUser: user)),
            );
          } else {
            if(text == "Abrir mapa de pedidos") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage(currentUser: user)),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(color),
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
                      "Digite sua senha ou e-mail para desativar o pedido de ajuda urgente",
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
                    controller: _passController,
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
                          onPressed: () async {
                            if(await verifyPass(_passController.text)) {
                              setState((){
                                turnOffSOS();
                                _passController.clear();
                                Navigator.pop(context);
                              });
                            }
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
