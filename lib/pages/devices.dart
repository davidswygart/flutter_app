import 'package:flutter/material.dart';
import 'package:flutter_app/pages/scaffold_wrapper.dart';

import '../bluetooth/bluetooth_handler.dart';
import '../bluetooth/led_display.dart';
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
    delayedUpdater(); //hacky way to handle connections completing after build
    super.initState();
  }
  Future<void> delayedUpdater() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Targets", textAlign: TextAlign.center,textScaleFactor: 2,style: TextStyle(fontWeight:FontWeight.bold),),
          getDeviceTable(),
          functionButton(func: addTargetsAndUpdate, label:"Scan for targets"),
          functionButton(func: clearTargets, label:"Disconnect from targets"),
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
        decoration: BoxDecoration(
            border: Border.all()
        ),
        child: DataTable(columns: columns, rows: rows)
    );
  }

  ElevatedButton functionButton({required Function func, required String label}){
    return ElevatedButton(
      onPressed: () {func();},
      child: Text(label,textScaleFactor: 1.5,),
    );
  }

  addTargetsAndUpdate() async {
    await BlueToothHandler().connectToTargets();
    setState(() {});
  }

  clearTargets() async {
    await BlueToothHandler().clearTargets();
    setState(() {});
  }

  goToAdvancedSettings(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          ScaffoldWrapper(bodyPage: DevicesPageAdvanced())),
    );
  }
}
