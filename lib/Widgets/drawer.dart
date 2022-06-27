import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_security_app/screens/edit_profile.dart';
import 'package:tcc_security_app/screens/sign_in.dart';
import 'package:tcc_security_app/screens/sign_up.dart';
import 'package:tcc_security_app/screens/sos.dart';

import '../shared/models/user.dart';

class NavDrawer extends StatelessWidget {
  final CurrentUser currentUser;
  const NavDrawer({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top:60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: currentUser.loginByGoogle ?
                    Image.network(
                      currentUser.avatar!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                    :
                    Image.asset(
                      currentUser.avatar!,
                      height: 150,
                      width: 150,
                    ),
                  )
                ),
                const Divider(height: 20, color: Colors.transparent),
                Text(
                  currentUser!.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
          ),
          const Divider(height: 50, color: Colors.transparent),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Editar informações'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Deslogar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text(
              'Deletar conta',
              style: TextStyle(color: Color(0xfff03131))
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}