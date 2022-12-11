import 'package:flutter/material.dart';
import 'package:flutter_app/pages/debug_ble.dart';
import 'package:flutter_app/pages/test_page.dart';

import 'navigation_drawer.dart';

class MainScaffold extends StatelessWidget {
  final Widget bodyPage;
  MainScaffold({super.key, required this.bodyPage});


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      //body: DebugBlePage(),
      body: bodyPage,
      drawer: NavigationDrawer(),
    );
  }
}
