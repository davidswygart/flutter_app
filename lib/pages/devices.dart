import 'package:flutter/material.dart';
import 'package:flutter_app/pages/scaffold_wrapper.dart';
import '../bluetooth/bluetooth_handler.dart';
import '../bluetooth/single_target.dart';
import 'devices_advanced.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);
  @override
  State<DevicesPage> createState() => _DevicesPage();
}

class _DevicesPage extends State<DevicesPage> {
  @override
  void initState() {
    periodicConnectionChecker(); //hacky
    super.initState();
  }

  bool periodicallyCheckTargets = true;
  Future<void> periodicConnectionChecker() async {
    await BlueToothHandler().connectToTargets();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});

    while(periodicallyCheckTargets){
      if (BlueToothHandler().anyLostConnections()){
        setState((){buttonsEnabled = false;});
        await BlueToothHandler().clearTargets();
        await Future.delayed(const Duration(seconds: 1)); //give time for ESP32 to begin advertising again
        await BlueToothHandler().connectToTargets();
        setState(() {buttonsEnabled = true;});
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  void dispose(){
    periodicallyCheckTargets = false;
    super.dispose();
  }

  bool buttonsEnabled = true;
  @override
  Widget build(BuildContext context) {
    Widget connectButton;
    Widget disconnectButton;
    if (buttonsEnabled){
      connectButton = functionButton(func: addTargetsAndUpdate, label:"Scan for targets");
      disconnectButton = functionButton(func: clearTargets, label:"Disconnect from targets");
    } else {
      connectButton = functionButton(func: null, label:"Scan for targets");
      disconnectButton = functionButton(func: null, label:"Disconnect from targets");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Targets", textAlign: TextAlign.center,textScaleFactor: 2,style: TextStyle(fontWeight:FontWeight.bold),),
          getDeviceTable(),
          connectButton,
          disconnectButton,
          functionButton(func: goToAdvancedSettings, label:"Advanced settings"),
        ],
      ),
    );
  }

  Container getDeviceTable() {
    List<DataColumn> columns = [
    const DataColumn(label: Text("Name",textScaleFactor: 1.1,)),
    const DataColumn(label: Text("Decibels",textScaleFactor: 1.1,)),
    ];
    List<DataRow> rows = [];
    for (SingleTarget target in BlueToothHandler().targetList) {
      debugPrint(target.device.name);
      List<DataCell> rowCells = [
        DataCell(Text(target.device.name.substring(13))), //last 6 of MAC
        DataCell(Text(target.device.rssi.toString())),
      ];
      rows.add(DataRow(cells: rowCells));
    }
    return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: DataTable(columns: columns, rows: rows)
    );
  }

  ElevatedButton functionButton({required void Function()? func, required String label}){
    return ElevatedButton(
      onPressed: func,
      child: Text(label,textScaleFactor: 1.5,),
    );
  }

  addTargetsAndUpdate() async {
    setState((){buttonsEnabled = false;});
    await BlueToothHandler().connectToTargets();
    setState((){buttonsEnabled = true;});
  }

  clearTargets() async {
    setState((){buttonsEnabled = false;});
    await BlueToothHandler().clearTargets();
    setState((){buttonsEnabled = true;});
  }

  goToAdvancedSettings(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          const ScaffoldWrapper(bodyPage: DevicesPageAdvanced())),
    );
  }
}
