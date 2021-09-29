import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/BlueToothDevices/BlueToothDevices.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/Dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text('Manage Users'),
            onTap: () {
              Navigator.pushNamed(context, '/Dashboard');
            }, // TODO: create account management
          ),
          ListTile(
            leading: Icon(Icons.settings_bluetooth),
            title: Text('Target Connection'),
            onTap: () {
              Navigator.pushNamed(context, BlueToothDevicesPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Advanced GameSettings'),
            onTap: () {
              Navigator.pushNamed(context, '/Dashboard');
            }, // TODO: Add advanced options (clear data cache)
          ),
        ],
      ),
    ));
  }
}
