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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          functionButton(func: addTargetsAndUpdate, label: "Connect to targets"),
          getDeviceTable(),
          functionButton(func: clearTargets, label: "Disconnect from targets"),
          const Divider(),
          functionButton(func:LedDisplay().cycleLeds, label: "Flash LEDs"),
          const Divider(),
          navigateToAdvanced(context: context),
        ],
      ),
    );
  }

  Container getDeviceTable() {
    List<DataColumn> columns = [
    const DataColumn(label: Text("name",textScaleFactor: 1.5,)),
    const DataColumn(label: Text("rssi",textScaleFactor: 1.5,)),
    ];
    List<DataRow> rows = [];
    for (SingleTarget target in BlueToothHandler().targetList) {
      debugPrint(target.device.name);
      List<DataCell> rowCells = [
        DataCell(Text(target.device.name)),
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
    await BlueToothHandler().clearTargets(); //TODO make disconnect if connected and ESP32 start advertising again
    setState(() {});
  }

  Widget navigateToAdvanced({required BuildContext context}){
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScaffoldWrapper(bodyPage: DevicesPageAdvanced())),
        );
      },
      child: const Text("advanced settings",textScaleFactor: 1.5,),
    );
  }
}
