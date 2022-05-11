import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_security_app/screens/edit_profile.dart';
import 'package:tcc_security_app/screens/sign_in.dart';
import 'package:tcc_security_app/screens/sign_up.dart';
import 'package:tcc_security_app/screens/sos.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

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
                    child: Image.asset(
                      "assets/images/random_person.jpg",
                      height: 200,
                      width: 200,
                    ),
                  )
                ),
                const Divider(height: 20, color: Colors.transparent),
                const Text(
                  "username",
                  style: TextStyle(
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