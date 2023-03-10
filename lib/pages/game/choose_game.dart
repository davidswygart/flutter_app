import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app/pages/game/settings_color_discrimination.dart';
import 'package:flutter_app/pages/game/settings_memory.dart';
import 'package:flutter_app/pages/game/settings_moving_target.dart';
import 'package:flutter_app/pages/game/settings_shoot_your_color.dart';
import 'package:flutter_app/pages/game/settings_speed_switcher.dart';

import 'settings_go_no_go.dart';

class ChooseGamesPage extends StatelessWidget {
  const ChooseGamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CarouselOptions options = CarouselOptions(
      height: MediaQuery.of(context).size.height,
      viewportFraction: 0.8,
      enableInfiniteScroll: false,
    );

    return CarouselSlider(
      options: options,
      items: const [
        SettingsGoNoGo(),
        SettingsSpeedSwitcher(),
        SettingsShootYourColor(),
        SettingsMovingTarget(),
        SettingsMemory(),
        SettingsColorDiscrimination(),
      ],
    );

  }
}

class IntroFormat extends StatelessWidget{
  final String gameName;
  final String numPlayers;
  final String numPaddles;
  final String description;

  const IntroFormat({
    super.key,
    required this.gameName,
    required this.numPlayers,
    required this.numPaddles,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        makeTitle(),
        makeRequirements(),
        makeDescription(),
      ],
    );
  }

  Widget makeTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        gameName,
        textScaleFactor: 2,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget makeRequirements() {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        "players: $numPlayers",
        textScaleFactor: 1.5,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      Text(
        "targets: $numPaddles",
        textScaleFactor: 1.5,
        style: const TextStyle(fontStyle: FontStyle.italic),
      )
    ],
  );
    }

  Widget makeDescription(){
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          description,
          textScaleFactor: 1.1,
        ),
    );
  }

}
