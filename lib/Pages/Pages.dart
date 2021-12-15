import 'package:flutter/material.dart';
import 'package:flutter_app/AppBar/BlueToothBar.dart';
import 'package:flutter_app/Bodies/ActiveGame/ActiveGame.dart';
import 'package:flutter_app/Bodies/BlueToothDevices/BlueToothDevices.dart';
import 'package:flutter_app/Bodies/Dashboard/Dashboard.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';
import 'package:flutter_app/Bodies/GameMode/GameMode.dart';
import 'package:flutter_app/Bodies/GameSettings/GameSettings.dart';
import 'package:flutter_app/Bodies/Players/PlayerBody.dart';
import 'package:flutter_app/Bodies/Users/Users.dart';
import 'package:flutter_app/NavigationDrawer/Drawer.dart';

import '../AdvanceButton.dart';

class DashPage extends StatelessWidget {
  const DashPage({Key? key}) : super(key: key);
  static const routeName = 'HTT Dashboard';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isActive = ModalRoute.of(context)?.isActive ?? false;
        bool isFirst = ModalRoute.of(context)?.isFirst ?? false;
        if (isActive && isFirst){
          return false;
        }
        else {
          return true;
        }
      },
      child: Scaffold(
        appBar: BlueToothBar(title: routeName),
        drawer: NavigationDrawer(currentPage: routeName),
        body: DashBody(),
        floatingActionButton: AdvanceButton(
          navigationFunction: () {Navigator.pushNamed(context, GameModePage.routeName);}, //TODO: Add dialog if not connected to bluetooth
          text: 'New Game',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class GameModePage extends StatelessWidget {
  const GameModePage({Key? key}) : super(key: key);
  static const routeName = 'Game Modes';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueToothBar(title: routeName),
      drawer: NavigationDrawer(currentPage: routeName),
      body: GameModeBody(),
    );
  }
}

class GameSettingsPage extends StatelessWidget {
  const GameSettingsPage({Key? key}) : super(key: key);
  static const routeName = 'Game Settings';
  @override
  Widget build(BuildContext context) {
    Preset p = ModalRoute.of(context)!.settings.arguments as Preset? ?? Preset();

    return Scaffold(
      appBar: BlueToothBar(title: routeName),
      drawer: NavigationDrawer(currentPage: routeName),
      body: GameSettingsBody(preset: p),
      floatingActionButton: AdvanceButton(
          text: 'Choose Players',
          navigationFunction: (){Navigator.pushNamed(
            context,
            PlayersPage.routeName,
            arguments: p,
          );},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PlayersPage extends StatelessWidget {
  const PlayersPage({Key? key}) : super(key: key);
  static const routeName = 'Choose Players';
  @override
  Widget build(BuildContext context) {
    Preset p = ModalRoute.of(context)!.settings.arguments as Preset? ?? Preset();

    return Scaffold(
      appBar: BlueToothBar(title: routeName),
      drawer: NavigationDrawer(currentPage: routeName),
      body: PlayerBody(preset: p),
      floatingActionButton: AdvanceButton(
          navigationFunction: (){Navigator.pushNamed(
              context,
              ActiveGamePage.routeName,
              arguments: p
          );},
          text: 'Start Game'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ActiveGamePage extends StatelessWidget {
  const ActiveGamePage({Key? key}) : super(key: key);
  static const routeName = 'Play Game';
  @override
  Widget build(BuildContext context) {
    Preset p = ModalRoute.of(context)!.settings.arguments as Preset? ?? Preset();
    return Scaffold(
      //appBar: BlueToothBar(title: routeName),
      body: ActiveBody(preset: p),
    );
  }
}

class BlueToothDevicesPage extends StatelessWidget {
  const BlueToothDevicesPage({Key? key}) : super(key: key);
  static const routeName = 'Bluetooth Devices';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueToothBar(title: routeName),
      drawer: NavigationDrawer(currentPage: routeName),
      body: BtDevicesBody(),
    );
  }
}


class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);
  static const routeName = 'Users';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BlueToothBar(title: routeName),
        drawer: NavigationDrawer(currentPage: routeName),
        body: UsersBody(),
      );
  }
}