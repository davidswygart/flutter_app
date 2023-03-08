import 'package:flutter/material.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Widget bodyPage;
  const ScaffoldWrapper({super.key, required this.bodyPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyPage,
    );
  }
}