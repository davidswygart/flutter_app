import 'package:flutter/material.dart';
import 'package:flutter_app/BlueTooth/BlueServices.dart';
import 'package:flutter_app/NavigationDrawer/Drawer.dart';
import 'package:flutter_blue/flutter_blue.dart';


import '../../AppBar/BlueToothBar.dart';

class BlueToothDevicesPage extends StatelessWidget {
  const BlueToothDevicesPage({Key? key}) : super(key: key);
  static const routeName = '/BlueToothDevicesPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueToothBar(title: 'BlueTooth Devices'),
      drawer: NavigationDrawer(),
      body: BtDevicesBody(),
    );
  }
}

class BtDevicesBody extends StatefulWidget {
  const BtDevicesBody({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BtDevicesBody();
  }
}

class _BtDevicesBody extends State<BtDevicesBody>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: BlueServices.getEternalScanResults(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot){
        List<ScanResult> scanList = [];
        if (snapshot.hasData && !snapshot.hasError){
          scanList = snapshot.data ?? [];
        }
        return ListView.builder(
          itemCount: scanList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(scanList[index].device.name),
              );
              },
        );
      },);
  }
}
