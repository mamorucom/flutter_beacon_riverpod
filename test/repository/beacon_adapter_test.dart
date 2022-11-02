import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../dummy/dummy_data.dart';

class MockBeaconAdapterBase extends Mock implements BeaconAdapterBase {}

void main() {
  // group:テストケースをグループ化しておく際に利用
  group('BeaconAdapter providers Test', () {
    test('''
      bluetoothStateStreamProvider Test
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();

      when(() => mockBeaconAdapter.listeningBluetoothState())
          .thenAnswer((_) => Stream.value(BluetoothState.stateOn));

      final container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
        ],
      );

      /// autoDisposeを使用するProviderは、container.readだけでは即座にdisposeされてしまうため、
      /// 以下のようにlistenしてあげることで、テスト終了までProviderが破棄されることなく動作させることができるようです。
      /// 参考;https://zenn.dev/omtians9425/articles/4a74f982788bdb
      container
          .listen(bluetoothStateStreamProvider, (previous, next) {})
          .read();

      // The first read if the loading state
      expect(
        container.read(bluetoothStateStreamProvider),
        const AsyncLoading<BluetoothState>(),
      );

      // ウェイト
      await Future<void>.value();

      verify(() => mockBeaconAdapter.listeningBluetoothState()).called(1);
      expect(
        container.read(bluetoothStateStreamProvider),
        const AsyncData<BluetoothState>(BluetoothState.stateOn),
      );
    });

    test('''
      initializeScanningFutureProvider Test
      BluetoothState.stateOff → verifyNever
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();

      when(() => mockBeaconAdapter.initializeScanning())
          .thenAnswer((_) => Future<void>.value());

      final container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothStateStreamProvider.overrideWith((ref) {
            return Stream.value(BluetoothState.stateOff);
          }),
        ],
      );

      container
          .listen(initializeScanningFutureProvider, (previous, next) {})
          .read();

      expect(
        container.read(initializeScanningFutureProvider),
        const AsyncLoading<void>(),
      );

      /// Streamの結果を受け取るためのウェイトを確保しています。
      await _refleshProcess(
          () => container.refresh(initializeScanningFutureProvider));

      verifyNever(() => mockBeaconAdapter.initializeScanning());
    });
    test('''
      initializeScanningFutureProvider Test
      BluetoothState.stateOff → verify
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();

      when(() => mockBeaconAdapter.initializeScanning())
          .thenAnswer((_) => Future<void>.value());

      final container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothStateStreamProvider.overrideWith((ref) {
            return Stream.value(BluetoothState.stateOn);
          }),
        ],
      );

      container
          .listen(initializeScanningFutureProvider, (previous, next) {})
          .read();

      expect(
        container.read(initializeScanningFutureProvider),
        const AsyncLoading<void>(),
      );

      await _refleshProcess(
          () => container.refresh(initializeScanningFutureProvider));

      verify(() => mockBeaconAdapter.initializeScanning()).called(1);
    });

    test('''
      bluetoothAuthStateFutureProvider Test
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();

      when(() => mockBeaconAdapter.getAllRequirements())
          .thenAnswer((_) => Future.value(BluetoothAuthState.empty()));

      final container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothStateStreamProvider.overrideWith((ref) {
            return Stream.value(BluetoothState.stateOn);
          }),
        ],
      );

      container
          .listen(bluetoothAuthStateFutureProvider, (previous, next) {})
          .read();

      expect(
        container.read(bluetoothAuthStateFutureProvider),
        const AsyncLoading<BluetoothAuthState>(),
      );

      await _refleshProcess(
          () => container.refresh(bluetoothAuthStateFutureProvider));

      verify(() => mockBeaconAdapter.initializeScanning()).called(1);
      expect(
        container.read(bluetoothAuthStateFutureProvider),
        AsyncData<BluetoothAuthState>(BluetoothAuthState.empty()),
      );
    });

    test('''
      beaconRangingStreamProvider Test 1
      VerifyNever mockBeaconAdapter.watchRanging()
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();
      final rangingResult = RangingResult.from(dummyRangingResultJson);
      when(() => mockBeaconAdapter.watchRanging())
          .thenAnswer((_) => Stream.value(rangingResult));

      final container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothAuthStateFutureProvider.overrideWith((ref) {
            return Future.value(BluetoothAuthState(
              authorizationStatusOk: false,
              bluetoothEnabled: false,
              locationServiceEnabled: false,
            ));
          }),
        ],
      );

      container.listen(beaconRangingStreamProvider, (previous, next) {}).read();

      expect(
        container.read(beaconRangingStreamProvider),
        const AsyncLoading<RangingResult>(),
      );

      await _refleshProcess(
          () => container.refresh(beaconRangingStreamProvider));

      verifyNever(() => mockBeaconAdapter.watchRanging());
    });

    test('''
      beaconRangingStreamProvider Test 2
      VerifyNever mockBeaconAdapter.watchRanging()
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();
      final rangingResult = RangingResult.from(dummyRangingResultJson);
      when(() => mockBeaconAdapter.watchRanging())
          .thenAnswer((_) => Stream.value(rangingResult));

      var container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothAuthStateFutureProvider.overrideWith((ref) {
            return Future.value(BluetoothAuthState(
              authorizationStatusOk: true,
              bluetoothEnabled: true,
              locationServiceEnabled: false,
            ));
          }),
        ],
      );

      container.listen(beaconRangingStreamProvider, (previous, next) {}).read();

      expect(
        container.read(beaconRangingStreamProvider),
        const AsyncLoading<RangingResult>(),
      );

      await _refleshProcess(
          () => container.refresh(beaconRangingStreamProvider));

      verifyNever(() => mockBeaconAdapter.watchRanging());
    });

    test('''
      beaconRangingStreamProvider Test 3
      VerifyNever mockBeaconAdapter.watchRanging()
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();
      final rangingResult = RangingResult.from(dummyRangingResultJson);
      when(() => mockBeaconAdapter.watchRanging())
          .thenAnswer((_) => Stream.value(rangingResult));

      var container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothAuthStateFutureProvider.overrideWith((ref) {
            return Future.value(BluetoothAuthState(
              authorizationStatusOk: true,
              bluetoothEnabled: false,
              locationServiceEnabled: true,
            ));
          }),
        ],
      );

      container.listen(beaconRangingStreamProvider, (previous, next) {}).read();

      expect(
        container.read(beaconRangingStreamProvider),
        const AsyncLoading<RangingResult>(),
      );

      await _refleshProcess(
          () => container.refresh(beaconRangingStreamProvider));

      verifyNever(() => mockBeaconAdapter.watchRanging());
    });
    test('''
      beaconRangingStreamProvider Test 4
      VerifyNever mockBeaconAdapter.watchRanging()
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();
      final rangingResult = RangingResult.from(dummyRangingResultJson);
      when(() => mockBeaconAdapter.watchRanging())
          .thenAnswer((_) => Stream.value(rangingResult));

      var container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothAuthStateFutureProvider.overrideWith((ref) {
            return Future.value(BluetoothAuthState(
              authorizationStatusOk: false,
              bluetoothEnabled: true,
              locationServiceEnabled: true,
            ));
          }),
        ],
      );

      container.listen(beaconRangingStreamProvider, (previous, next) {}).read();

      expect(
        container.read(beaconRangingStreamProvider),
        const AsyncLoading<RangingResult>(),
      );

      await _refleshProcess(
          () => container.refresh(beaconRangingStreamProvider));

      verifyNever(() => mockBeaconAdapter.watchRanging());
    });

    test('''
      beaconRangingStreamProvider Test 5
      mockBeaconAdapter.watchRanging()).called(1)
        ''', () async {
      final mockBeaconAdapter = MockBeaconAdapterBase();
      final rangingResult = RangingResult.from(dummyRangingResultJson);
      when(() => mockBeaconAdapter.watchRanging())
          .thenAnswer((_) => Stream.value(rangingResult));

      var container = ProviderContainer(
        overrides: [
          beaconAdapterProvider.overrideWithValue(mockBeaconAdapter),
          bluetoothAuthStateFutureProvider.overrideWith((ref) {
            return Future.value(BluetoothAuthState(
              authorizationStatusOk: true,
              bluetoothEnabled: true,
              locationServiceEnabled: true,
            ));
          }),
        ],
      );

      container.listen(beaconRangingStreamProvider, (previous, next) {}).read();

      expect(
        container.read(beaconRangingStreamProvider),
        const AsyncLoading<RangingResult>(),
      );

      await _refleshProcess(
          () => container.refresh(beaconRangingStreamProvider));

      verify(() => mockBeaconAdapter.watchRanging()).called(1);
      expect(
        container.read(beaconRangingStreamProvider),
        AsyncData<RangingResult>(rangingResult),
      );
    });
  });
}

// リフレッシュプロセス
Future<void> _refleshProcess(Function() refresh) async {
  // ウェイト
  await Future<void>.value();
  // リフレッシュしてデータを再取得
  refresh();
  // ウェイト
  await Future<void>.value();
}
