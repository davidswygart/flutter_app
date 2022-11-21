//
//
// class BleState {
//
//   // enum BlueStates {
//   // error,
//   // notSupported,
//   // unauthorized,
//   // turnedOff,
//   // notConnected,
//   // scanning,
//   // connecting,
//   // connected,
//   // }
//
//   // Called in app initialization to begin looking for BLE connections
//   bool _runningLoop = false;
//   Future<bool> startStateHandler() async {
//     debugPrint('State handler started_________________');
//     if (_runningLoop) {
//       debugPrint(
//           'State handler already running loop. I will not start another one_________________');
//       return false;
//     }
//     while (_runningLoop) {
//       try {
//         debugPrint('State handler top of loop_________________');
//         if (await isConnected(_btDev)) {
//           if (_btDev != null) {
//             await _readBattery();
//           }
//           debugPrint(
//               'State handler determined we were connected_________________');
//           //TODO: allow for connection to multiple devices. Need to check connection status for each.  Setup device names on first app run or in settings.
//           //TODO: set checks for bluetooth turned off
//         } else {
//           debugPrint(
//               'State handler determined we need to connect_________________');
//           _updateState(BlueStates.connecting);
//           Future<bool> connectFuture = _attemptConnect();
//           Future<bool> futureTimeout =
//           connectFuture.timeout(const Duration(seconds: 10));
//           bool connectSuccess = await futureTimeout;
//           if (connectSuccess) {
//             //Try to connect from the beginning.
//             _updateState(BlueStates.connected);
//             debugPrint(
//                 'State handler was successful in connecting_________________');
//           } else {
//             //broadcast that we are disconnected
//             debugPrint(
//                 'State handler tried and failed at connecting_________________');
//             _updateState(BlueStates.notConnected);
//           }
//         }
//         debugPrint('State handler is taking a 1s rest break_________________');
//         await Future.delayed(const Duration(seconds: 1));
//       } catch (error) {
//         debugPrint('An error occurred while trying to connect________________');
//         await Future.delayed(const Duration(seconds: 1));
//         _updateState(BlueStates.notConnected);
//         continue;
//       }
//     }
//     debugPrint('State handler has exited the loop_________________');
//     return true;
//   }
//
//
//
//
//
//   stopStateHandler() {
//     _runningLoop = false;
//   }
//
//
//
//   void _updateState(BlueStates b) {
//     _lastState = b;
//     _stateBroadcaster.add(b);
//   }
//
//
//   final StreamController<BlueStates> _stateBroadcaster =
//   StreamController<BlueStates>.broadcast();
//   BlueStates _lastState =
//       BlueStates.error; //Should be overwritten when we first assess the state
//
//
//   Stream<BlueStates> get stateStream => _stateBroadcaster.stream;
//   BlueStates get lastState => _lastState;
//
//
// }