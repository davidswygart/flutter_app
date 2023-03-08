import 'package:flutter/material.dart';

class DevicesPageAdvanced extends StatefulWidget {
  const DevicesPageAdvanced({Key? key}) : super(key: key);

  @override
  State<DevicesPageAdvanced> createState() => _DevicesPageAdvanced();
}

class _DevicesPageAdvanced extends State<DevicesPageAdvanced> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [],);
  }

  ElevatedButton functionButton({required Function func, required String label}){
    return ElevatedButton(
      onPressed: () {func();},
      child: Text(label),
    );
  }
}
