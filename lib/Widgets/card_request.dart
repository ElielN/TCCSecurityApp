import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/models/user.dart';

class CardRequest extends StatefulWidget {
  final CurrentUser currentUser;
  final Map<String, dynamic> data;
  const CardRequest({Key? key, required this.currentUser, required this.data}) : super(key: key);

  @override
  State<CardRequest> createState() => _CardRequestState();
}

class _CardRequestState extends State<CardRequest> {

  late CurrentUser user;

  int urgencyColor = 0xffffffff;

  late final Map<String, dynamic> requestData;

  //late DateTime date;

  @override
  void initState() {
    super.initState();

    user = widget.currentUser;
    requestData = widget.data;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if(requestData["urgency"] == 1) {
      urgencyColor = 0xffffffff;
    } else {
      if(requestData["urgency"] == 2) {
        urgencyColor = 0x805AC4FF;
      } else {
        if(requestData["urgency"] == 3) {
          urgencyColor = 0x80FFEF5C;
        } else {
          if(requestData["urgency"] == 4) {
            urgencyColor = 0x80F03131;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
      decoration: BoxDecoration(
        color: Color(urgencyColor),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: requestData["loginByGoogle"] ?
              Image.network(
                requestData["avatar"],
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              )
                  :
              Image.asset(
                requestData["avatar"],
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(requestData["title"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )),
                Text(requestData["description"]),
                Text(DateFormat('dd/MM/yyyy - kk:mm').format(requestData["date"].toDate()).toString())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
