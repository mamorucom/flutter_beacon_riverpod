import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/beacon_scanning_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/beacon_scanning_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../dummy/dummy_data.dart';

// class MockBeaconAdapterBase extends Mock implements BeaconAdapterBase {}

void main() {
  group('BeaconScanningNotifier Test', () {
    test('beaconListStreamProvider Test', () async {
      final rangingResult = RangingResult.from(dummyRangingResultJson);

      final container = ProviderContainer(
        overrides: [
          beaconRangingStreamProvider.overrideWith((ref) {
            return Stream.value(rangingResult);
          }),
        ],
      );

      /// autoDisposeを使用するProviderは、container.readだけでは即座にdisposeされてしまうため、
      /// 以下のようにlistenしてあげることで、テスト終了までViewModelを破棄されることなく動作させることができるようです。
      /// https://zenn.dev/omtians9425/articles/4a74f982788bdb
      final beaconListStreamState = container
          .listen<AsyncValue<List<Beacon>>>(
              beaconListStreamProvider, (previous, next) {})
          .read();

      // The first read if the loading state
      expect(
        container.read(beaconListStreamProvider),
        const AsyncLoading<List<Beacon>>(),
      );

      await Future<void>.value();

      container.refresh(beaconListStreamProvider);
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
    });

    // test('sortedBeaconListStreamProvider Test-並び替えできること', () async {
    //   final container = ProviderContainer(
    //     overrides: [
    //       beaconListStreamProvider.overrideWithValue(
    //         AsyncValue.data([
    //           dummyBeacons[0],
    //           dummyBeacons[1],
    //         ]),
    //       ),
    //     ],
    //   );

    //   /// リストの中身を確認-isAは、リスト内オブジェクトのフィールド値が期待値通りかを判定する
    //   expect(container.read(sortedBeaconListProvider), [
    //     isA<Beacon>()
    //         .having((beacon) => beacon.proximityUUID, 'proximityUUID',
    //             dummyBeacons[1].proximityUUID)
    //         .having((beacon) => beacon.major, 'major', dummyBeacons[1].major)
    //         .having((beacon) => beacon.minor, 'minor', dummyBeacons[1].minor),
    //     isA<Beacon>()
    //         .having((beacon) => beacon.proximityUUID, 'proximityUUID',
    //             dummyBeacons.first.proximityUUID)
    //         .having((beacon) => beacon.major, 'major', dummyBeacons.first.major)
    //         .having(
    //             (beacon) => beacon.minor, 'minor', dummyBeacons.first.minor),
    //   ]);
    // });

    test('beaconScanningStateStreamProvider Test', () async {
      final container = ProviderContainer(
        overrides: [
          sortedBeaconListProvider.overrideWithValue([
            dummyBeacons[1],
            dummyBeacons[0],
          ]),
        ],
      );

      /// リストの中身を確認-isAは、リスト内オブジェクトのフィールド値が期待値通りかを判定する
      expect(
        container.read(beaconScanningStateProvider),
        BeaconScanningState(beacons: [
          dummyBeacons[1],
          dummyBeacons[0],
        ]),
      );
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
