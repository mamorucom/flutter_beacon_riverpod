// ignore_for_file: avoid_print

// import 'package:flutter_beacon/flutter_beacon.dart';
// import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
// import 'package:flutter_beacon_riverpod/state_notifier/states/beacon_scanning_state.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'bluetooth_auth_notifier.dart';


// final beaconScanningStateProvider = StateNotifierProvider.autoDispose<
//     BeaconScanningNotifier, BeaconScanningState>((ref) {
//   return BeaconScanningNotifier(
//     ref.watch(bluetoothAuthStateProvider),
//     ref.read(beaconAdapterProvider),
//   );
// });


// class BeaconScanningNotifier extends StateNotifier<BeaconScanningState> {
//   BeaconScanningNotifier(
//     this._bluetoothAuthState,
//     this._beaconAdapter,
//   ) : super(BeaconScanningState()) {
//     if (_bluetoothAuthState.authorizationStatusOk &&
//         _bluetoothAuthState.locationServiceEnabled &&
//         _bluetoothAuthState.bluetoothEnabled) {
//       _listeningRanging(mounted);
//     }
//   }

//   final BluetoothAuthState _bluetoothAuthState;
//   final BeaconAdapterBase _beaconAdapter;

//   void _listeningRanging(bool mounted) {
//     _beaconAdapter.listeningRanging().listen((beacons) {
//       state = state.copyWith(beacons: beacons);
//     });

//     _beaconAdapter.startRanging(mounted);
//   }
// }
