// import 'package:flutter_beacon/flutter_beacon.dart';
// import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
// import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mocktail/mocktail.dart';

// import '../dummy/dummy_data.dart';

// class MockBeaconAdapterBase extends Mock implements BeaconAdapterBase {}

// void main() {
//   // group:テストケースをグループ化しておく際に利用
//   group('BeaconAdapter providers Test', () {
//     test('''
//       bluetoothStateStreamProvider Test
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();

//       when(() => mockBeaconAdapter.listeningBluetoothState())
//           .thenAnswer((_) => Stream.value(BluetoothState.stateOn));

//       final container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(bluetoothStateStreamProvider),
//         const AsyncLoading<BluetoothState>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verify(() => mockBeaconAdapter.listeningBluetoothState()).called(1);
//       expect(
//         container.read(bluetoothStateStreamProvider),
//         const AsyncData<BluetoothState>(BluetoothState.stateOn),
//       );
//     });

//     test('''
//       initializeScanningFutureProvider Test
//       BluetoothState.stateOff → verifyNever
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();

//       when(() => mockBeaconAdapter.initializeScanning())
//           .thenAnswer((_) => Future<void>.value());

//       final container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothStateStreamProvider.overrideWithValue(
//             const AsyncData<BluetoothState>(BluetoothState.stateOff),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(initializeScanningFutureProvider),
//         const AsyncLoading<void>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verifyNever(() => mockBeaconAdapter.initializeScanning());
//     });
//     test('''
//       initializeScanningFutureProvider Test
//       BluetoothState.stateOff → verify
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();

//       when(() => mockBeaconAdapter.initializeScanning())
//           .thenAnswer((_) => Future<void>.value());

//       final container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothStateStreamProvider.overrideWithValue(
//             const AsyncData<BluetoothState>(BluetoothState.stateOn),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(initializeScanningFutureProvider),
//         const AsyncLoading<void>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verify(() => mockBeaconAdapter.initializeScanning()).called(1);
//     });

//     test('''
//       bluetoothAuthStateFutureProvider Test
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();

//       when(() => mockBeaconAdapter.getAllRequirements())
//           .thenAnswer((_) => Future.value(BluetoothAuthState.empty()));

//       final container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothStateStreamProvider.overrideWithValue(
//             const AsyncData<BluetoothState>(BluetoothState.stateOn),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(bluetoothAuthStateFutureProvider),
//         const AsyncLoading<BluetoothAuthState>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verify(() => mockBeaconAdapter.initializeScanning()).called(1);
//       expect(
//         container.read(bluetoothAuthStateFutureProvider),
//         AsyncData<BluetoothAuthState>(BluetoothAuthState.empty()),
//       );
//     });

//     test('''
//       beaconRangingStreamProvider Test 1
//       VerifyNever mockBeaconAdapter.watchRanging()
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();
//       final rangingResult = RangingResult.from(dummyRangingResultJson);
//       when(() => mockBeaconAdapter.watchRanging())
//           .thenAnswer((_) => Stream.value(rangingResult));

//       final container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothAuthStateFutureProvider.overrideWithValue(
//             AsyncValue.data(BluetoothAuthState(
//               authorizationStatusOk: false,
//               bluetoothEnabled: false,
//               locationServiceEnabled: false,
//             )),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(beaconRangingStreamProvider),
//         const AsyncLoading<RangingResult>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verifyNever(() => mockBeaconAdapter.watchRanging());
//     });

//     test('''
//       beaconRangingStreamProvider Test 2
//       VerifyNever mockBeaconAdapter.watchRanging()
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();
//       final rangingResult = RangingResult.from(dummyRangingResultJson);
//       when(() => mockBeaconAdapter.watchRanging())
//           .thenAnswer((_) => Stream.value(rangingResult));

//       var container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothAuthStateFutureProvider.overrideWithValue(
//             AsyncValue.data(BluetoothAuthState(
//               authorizationStatusOk: true,
//               bluetoothEnabled: true,
//               locationServiceEnabled: false,
//             )),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(beaconRangingStreamProvider),
//         const AsyncLoading<RangingResult>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verifyNever(() => mockBeaconAdapter.watchRanging());
//     });

//     test('''
//       beaconRangingStreamProvider Test 3
//       VerifyNever mockBeaconAdapter.watchRanging()
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();
//       final rangingResult = RangingResult.from(dummyRangingResultJson);
//       when(() => mockBeaconAdapter.watchRanging())
//           .thenAnswer((_) => Stream.value(rangingResult));

//       var container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothAuthStateFutureProvider.overrideWithValue(
//             AsyncValue.data(BluetoothAuthState(
//               authorizationStatusOk: true,
//               bluetoothEnabled: false,
//               locationServiceEnabled: true,
//             )),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(beaconRangingStreamProvider),
//         const AsyncLoading<RangingResult>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verifyNever(() => mockBeaconAdapter.watchRanging());
//     });
//     test('''
//       beaconRangingStreamProvider Test 4
//       VerifyNever mockBeaconAdapter.watchRanging()
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();
//       final rangingResult = RangingResult.from(dummyRangingResultJson);
//       when(() => mockBeaconAdapter.watchRanging())
//           .thenAnswer((_) => Stream.value(rangingResult));

//       var container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothAuthStateFutureProvider.overrideWithValue(
//             AsyncValue.data(BluetoothAuthState(
//               authorizationStatusOk: false,
//               bluetoothEnabled: true,
//               locationServiceEnabled: true,
//             )),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(beaconRangingStreamProvider),
//         const AsyncLoading<RangingResult>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verifyNever(() => mockBeaconAdapter.watchRanging());
//     });

//     test('''
//       beaconRangingStreamProvider Test 5
//       mockBeaconAdapter.watchRanging()).called(1)
//         ''', () async {
//       final mockBeaconAdapter = MockBeaconAdapterBase();
//       final rangingResult = RangingResult.from(dummyRangingResultJson);
//       when(() => mockBeaconAdapter.watchRanging())
//           .thenAnswer((_) => Stream.value(rangingResult));

//       var container = ProviderContainer(
//         overrides: [
//           beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
//           bluetoothAuthStateFutureProvider.overrideWithValue(
//             AsyncValue.data(BluetoothAuthState(
//               authorizationStatusOk: true,
//               bluetoothEnabled: true,
//               locationServiceEnabled: true,
//             )),
//           ),
//         ],
//       );

//       // The first read if the loading state
//       expect(
//         container.read(beaconRangingStreamProvider),
//         const AsyncLoading<RangingResult>(),
//       );

//       // ウェイト
//       await Future<void>.value();

//       verify(() => mockBeaconAdapter.watchRanging()).called(1);
//       expect(
//         container.read(beaconRangingStreamProvider),
//         AsyncData<RangingResult>(rangingResult),
//       );
//     });
//   });
// }
