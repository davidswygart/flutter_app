import 'package:flutter/material.dart';
import 'nav_drawer.dart';

class MainScaffold extends StatelessWidget {
  final Widget bodyPage;
  MainScaffold({super.key, required this.bodyPage});


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      //body: DebugBlePage(),
      body: bodyPage,
      drawer: NavDrawer(),
    );
  }
}
