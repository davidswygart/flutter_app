import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/Pages.dart';

class NavigationDrawer extends StatelessWidget {
  final String currentPage;
  NavigationDrawer({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return (Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            enabled: currentPage == DashPage.routeName ? false : true,
            onTap: () {
              Navigator.pushNamed(context, DashPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text('Manage Users'),
            enabled: currentPage == UsersPage.routeName ? false : true,
            onTap: () {
              Navigator.pushNamed(context, UsersPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_bluetooth),
            title: Text('Target Connection'),
            enabled: currentPage == BlueToothDevicesPage.routeName ? false : true,
            onTap: () {
              Navigator.pushNamed(context, BlueToothDevicesPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            enabled: false,
            title: Text('Advanced GameSettings'),
            onTap: () {
            },
          ),
        ],
      ),
    ));
  }
}
