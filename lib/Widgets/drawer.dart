import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          /*const DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))
            ),
          ),*/
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Editar informações'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Deslogar'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text(
              'Deletar conta',
              style: TextStyle(color: Color(0xfff03131))
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}