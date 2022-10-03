// import 'package:flutter_beacon/flutter_beacon.dart';
// import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
// import 'package:flutter_beacon_riverpod/state_notifier/notifiers/beacon_scanning_notifier.dart';
// import 'package:flutter_beacon_riverpod/state_notifier/notifiers/bluetooth_auth_notifier.dart';
// import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
// import 'package:flutter_beacon_riverpod/util/constants.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../dummy/dummy_data.dart';
// import '../../mock/fake_bluetooth_auth_notifier.dart';

// class MockBeaconAdapterBase extends Mock implements BeaconAdapterBase {}

// void main() {
//   group('BeaconScanningNotifier Test', () {
//     test('レンジング監視により、ダミーのビーコンを検出し、stateを更新できること', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();

//       final dummyBeacons = [
//         const Beacon(
//           proximityUUID: kProximityUUID,
//           major: kDummyBeaconMajor,
//           minor: kDummyBeaconMinor,
//           accuracy: kDummyAccuracy,
//         ),
//       ];

//       when(() => mockBeaconAdapter.listeningRanging())
//           .thenAnswer((_) => Stream.value(dummyBeacons));

//       final fakeBluetoothAuthNotifier =
//           FakeBluetoothAuthNotifier(BluetoothAuthState(
//         authorizationStatusOk: true,
//         locationServiceEnabled: true,
//         bluetoothEnabled: true,
//       ));

//       final container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothAuthStateProvider
//               .overrideWithValue(fakeBluetoothAuthNotifier),
//         ],
//       );

//       final beaconScanningState = container
//           .listen(beaconScanningStateProvider, (previous, next) {})
//           .read();
//       expect(beaconScanningState.beacons, []);

//       verify(() => mockBeaconAdapter.listeningRanging()).called(1);
//       verify(() => mockBeaconAdapter.startRanging(true)).called(1);

//       await Future.delayed(const Duration(seconds: 3));

//       expect(container.read(beaconScanningStateProvider).beacons, dummyBeacons);
//     });
//   });
// }
