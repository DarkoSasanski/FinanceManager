import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: const Color.fromRGBO(16, 19, 37, 1),
      child: ListView(
        padding: const EdgeInsets.only(top: 25),
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.close_outlined,
              color: Color.fromRGBO(159, 162, 169, 1),
              size: 35,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Item 1',
                style: TextStyle(color: Colors.white, fontSize: 25)),
            hoverColor: Colors.white,
            onTap: () {
              // Handle item 1 tap
            },
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Item 2',
                style: TextStyle(color: Colors.white, fontSize: 25)),
            hoverColor: Colors.white,
            onTap: () {
              // Handle item 2 tap
            },
          ),
        ],
      ),
    );
  }
}
