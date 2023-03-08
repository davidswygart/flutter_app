import 'package:flutter/material.dart';

import 'debug_ble.dart';
import 'devices_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DevicesPage()),
              );
            },
            child: const Text("Devices"),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DebugBlePage()),
              );
            },
            child: const Text("Debug"),
          ),

        ],
      ),
    );
  }
}
