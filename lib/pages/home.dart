import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/settings_go_no_go.dart';
import 'package:flutter_app/pages/scaffold_wrapper.dart';

import 'devices.dart';
import 'devices_advanced.dart';
import 'game/choose_game.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DevicesPage(),
          navigationButton(context: context, page: const SettingsGoNoGo(), label: "Play Game"),
        ],
      ),
    );
  }

  Widget navigationButton({required BuildContext context, required Widget page, required String label}){
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(20),),
        backgroundColor: MaterialStateProperty.all(Colors.green.shade600),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScaffoldWrapper(bodyPage: page)),
        );
      },
      child: Text(label, textScaleFactor: 2,));
  }
}


