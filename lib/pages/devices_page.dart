import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../bluetooth/bluetooth_handler.dart';

class DevicesPage extends StatelessWidget {
  DevicesPage({super.key});
  final BlueToothHandler bth = BlueToothHandler();




  @override
  Widget build(BuildContext context) {
    return Center(
      child: getFuture(),
    );
  }

  Widget getFuture() {
    return FutureBuilder<Widget>(
        future: getDeviceTable(),
        initialData: const Text('please wait for scan'),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          debugPrint("starting future build");
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          else {
            debugPrint("No data in snapshot");
            return const Text("No data in snapshot");
          }
        });
  }


  Future<DataTable> getDeviceTable() async {
    FlutterBlue fb = FlutterBlue.instance;
    Stream<ScanResult> scanStream = fb.scan(timeout: const Duration(seconds: 3));

    List<DataColumn> columns = [];
    columns.add(const DataColumn(label: Text("name")));
    columns.add(const DataColumn(label: Text("rssi")));
    columns.add(const DataColumn(label: Text("power")));

    List<DataRow> rows = [];
    await for (ScanResult r in scanStream) {
      List<DataCell> rowCells = [];

      rowCells.add(DataCell(Text(r.device.name)));
      rowCells.add(DataCell(Text(r.rssi.toString())));
      rowCells.add(DataCell(Text(r.advertisementData.txPowerLevel.toString())));

      rows.add(DataRow(cells: rowCells));
    }
    return DataTable(
        columns: columns,
        rows: rows
    );
  }

}
