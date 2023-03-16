import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app/pages/game/settings_color_discrimination.dart';
import 'package:flutter_app/pages/game/settings_memory.dart';
import 'package:flutter_app/pages/game/settings_moving_target.dart';
import 'package:flutter_app/pages/game/settings_shoot_your_color.dart';
import 'package:flutter_app/pages/game/settings_simone_says.dart';
import 'package:flutter_app/pages/game/settings_speed_switcher.dart';
import 'package:flutter_app/pages/game/settings_whack_a_mole.dart';
import 'settings_go_no_go.dart';

class ChooseGamesPage extends StatelessWidget {
  const ChooseGamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CarouselOptions options = CarouselOptions(
      height: MediaQuery.of(context).size.height,
      viewportFraction: 0.8,
      enableInfiniteScroll: false,
      enlargeCenterPage: false,
    );

    return CarouselSlider(
      options: options,
      items: [
        makePage(const SettingsGoNoGo()),
        makePage(const SettingsSpeedSwitcher()),
        makePage(const SettingsShootYourColor()),
        makePage(const SettingsMovingTarget()),
        makePage(const SettingsMemory()),
        makePage(const SettingsColorDiscrimination()),
        makePage(const SettingsSimoneSays()),
        makePage(const SettingsWhackAMole()),
      ],
    );
  }

  Widget makePage(Widget SettingsPage) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: SettingsPage,
      ),
    );
  }
}

class IntroFormat extends StatelessWidget {
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
        textAlign: TextAlign.center,
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

  Widget makeDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:5, horizontal:0),
      child: Text(
        textAlign: TextAlign.center,
        description,
        textScaleFactor: 1.2,
      ),
    );
  }
}
