import 'package:flutter/material.dart';
import 'package:flutter_app/pages/test_page.dart';

import 'debug_ble.dart';
import 'devices_page.dart';
import 'games_page.dart';
import 'main_scaffold.dart';

class NavigationDrawer extends StatelessWidget {
  final String currentPage;
  const NavigationDrawer({super.key, this.currentPage = 'nan'});

  @override
  Widget build(BuildContext context) {
    return (Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: const Text('games'),
            enabled: currentPage == 'nothing' ? false : true,
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScaffold(bodyPage: GamesPage(),)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_bluetooth),
            title: const Text('Device page'),
            enabled: currentPage == 'nothing' ? false : true,
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScaffold(bodyPage: DevicesPage(),)),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Debug page'),
            enabled: currentPage == 'nothing' ? false : true,
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScaffold(bodyPage: DebugBlePage(),)),
              );
            },
          ),
        ],
      ),
    ));
  }
}