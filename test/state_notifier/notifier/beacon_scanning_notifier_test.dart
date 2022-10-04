import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/beacon_scanning_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/bluetooth_auth_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
import 'package:flutter_beacon_riverpod/util/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy/dummy_data.dart';
import '../../mock/fake_bluetooth_auth_notifier.dart';

class MockBeaconAdapterBase extends Mock implements BeaconAdapterBase {}

void main() {
  final dummyBeacons = [
    const Beacon(
      proximityUUID: kProximityUUID,
      // macAddress: ,
      major: kDummyBeaconMajor,
      minor: kDummyBeaconMinor,
      accuracy: kDummyAccuracy,
      proximity: Proximity.immediate,
    ),
  ];

  final json = {
    'region': {'identifier': 'beacon', 'major': null, 'minor': null},
    'beacons': [
      {
        'proximityUUID': dummyBeacons[0].proximityUUID,
        // 'macAddress': '12-34-56-78',
        'major': dummyBeacons[0].major,
        'minor': dummyBeacons[0].minor,
        // 'rssi': '60',
        // 'txPower': '70',
        'accuracy': dummyBeacons[0].accuracy,
        'proximity': 'immediate'
      }
    ],
  };

  group('BeaconScanningNotifier Test', () {
    test('beaconListStreamProvider test', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();

      final rangingResult = RangingResult.from(json);

      final container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          // bluetoothAuthStateProvider
          //     .overrideWithValue(fakeBluetoothAuthNotifier),
          beaconRangingStreamProvider.overrideWithValue(
            AsyncValue.data(rangingResult),
          ),
        ],
      );

      // expect(container.read(beaconListStreamProvider), dummyBeacons);

      // final aaaa = container.read(beaconListStreamProvider.stream);
      // The first read if the loading state
      expect(
        container.read(beaconListStreamProvider),
        const AsyncLoading<List<Beacon>>(),
      );

      // ウェイト
      await Future<void>.value();

      /// リストの中身を確認-isAは、リスト内オブジェクトのフィールド値が期待値通りかを判定する
      expect(container.read(beaconListStreamProvider).value, [
        isA<Beacon>()
            .having((beacon) => beacon.proximityUUID, 'proximityUUID',
                dummyBeacons.first.proximityUUID)
            .having((beacon) => beacon.major, 'major', dummyBeacons.first.major)
            .having(
                (beacon) => beacon.minor, 'minor', dummyBeacons.first.minor),
      ]);

      // expect(
      //   container.read(beaconListStreamProvider),
      //   AsyncData<List<Beacon>>(dummyBeacons),
      // );

      // TODO:調べたやり方 ※あとで削除

      // expectLater(
      //   controller.stream,
      //   emitsInOrder([
      //     EmailPasswordSignInState(
      //       formType: EmailPasswordSignInFormType.signIn,
      //       value: const AsyncLoading<void>(),
      //     ),
      //     predicate<EmailPasswordSignInState>((state) {
      //       expect(state.formType, EmailPasswordSignInFormType.signIn);
      //       expect(state.value.hasError, true);
      //       return true;
      //     }),
      //   ]),
      // );
      // run
      // final result = await controller.submit(testEmail, testPassword);
      // verify
      // expect(result, false);
      // final target = container.read(cartMapProvider.notifier);
      // expect(container.read(cartEmptyProvider), isTrue);
      // expect(container.read(cartTotalQuantityProvider), 0);
      // expect(container.read(cartTotalPriceLabelProvider), '合計金額 0円+税');
    });

    // test('レンジング監視により、ダミーのビーコンを検出し、stateを更新できること', () async {
    //   final mockBeaconAdapter = MockBeaconAdapterBase();

    //   when(() => mockBeaconAdapter.listeningRanging())
    //       .thenAnswer((_) => Stream.value(dummyBeacons));

    //   final fakeBluetoothAuthNotifier =
    //       FakeBluetoothAuthNotifier(BluetoothAuthState(
    //     authorizationStatusOk: true,
    //     locationServiceEnabled: true,
    //     bluetoothEnabled: true,
    //   ));

    //   final container = ProviderContainer(
    //     overrides: [
    //       beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
    //       bluetoothAuthStateProvider
    //           .overrideWithValue(fakeBluetoothAuthNotifier),
    //     ],
    //   );

    //   final beaconScanningState = container
    //       .listen(beaconScanningStateProvider, (previous, next) {})
    //       .read();
    //   expect(beaconScanningState.beacons, []);

    //   verify(() => mockBeaconAdapter.listeningRanging()).called(1);
    //   verify(() => mockBeaconAdapter.startRanging(true)).called(1);

    //   await Future.delayed(const Duration(seconds: 3));

    //   expect(container.read(beaconScanningStateProvider).beacons, dummyBeacons);
    // });
  });
}
