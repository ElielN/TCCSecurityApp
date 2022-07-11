import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Widgets/card_request.dart';
import '../Widgets/drawer.dart';
import '../shared/models/user.dart';

class MapPage extends StatefulWidget {
  final CurrentUser currentUser;
  const MapPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late CurrentUser user;

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-20.760968964329745, -42.870195388449055);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    if(widget.currentUser == null) {
      user = CurrentUser("name default error", "e-mail default error");
    } else {
      user = widget.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(19)),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 17.0
                    )
                  ),
                )
              ),
              const Divider(height: 30, color: Colors.transparent,),
              SizedBox(
                height: 320,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("requests").orderBy("urgency").snapshots(),
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center (
                          child: CircularProgressIndicator(),
                        );
                      default:
                        List<DocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();
                        print("CHEGOU AQUI!!!!!!!!");
                        return ListView.builder(
                          itemCount: documents.length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            return CardRequest(currentUser: user, data: documents[index].data()!);
                          }
                        );
                    }
                  },
                ),
              )
              /*
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("requests").orderBy("urgency").snapshots(),
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center (
                          child: CircularProgressIndicator(),
                        );
                      default:
                        List<DocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();
                        print("CHEGOU AQUI!!!!!!!!");
                        return ListView.builder(
                          itemCount: documents.length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 200,
                              height: 200,
                              child: Text(documents[index].id),
                            );
                          }
                        );
                      }
                    },
                )
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
