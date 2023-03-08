import 'package:flutter/material.dart';
import 'package:flutter_app/pages/scaffold_wrapper.dart';

import 'debug_ble.dart';
import 'devices_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        navigationButton(context:context, page:const DevicesPage(), label:"Devices"),
        navigationButton(context:context, page:const DebugBlePage(), label:"Debug"),
      ],
    );
  }

  Widget navigationButton({required BuildContext context, required Widget page, required String label}){
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScaffoldWrapper(bodyPage: page)),
        );
      },
      child: Text(label),
    );
  }
}


