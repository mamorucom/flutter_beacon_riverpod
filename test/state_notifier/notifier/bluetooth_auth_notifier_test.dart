import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/bluetooth_auth_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../mock/fake_beacon_adapter.dart';

void main() {
  // Riverpodが管理するProviderを使用できるようにする
  late ProviderContainer container;

  setUp(() {
    // モックに置き換える
    container = ProviderContainer(
      overrides: [
        beaconAdapterProvider.overrideWithValue(FakeBeaconAdapter()),
      ],
    );
  });

  // group:テストケースをグループ化しておく際に利用
  group('BluetoothAuthNotifier Test', () {
    test('初期値の確認', () async {
      /// Providerの参照を破棄しないための処置
      /// 参考:https://zenn.dev/omtians9425/articles/4a74f982788bdb
      final bluetoothAuthState = container
          .listen(bluetoothAuthStateProvider, (previous, next) {})
          .read();

      expect(bluetoothAuthState, BluetoothAuthState());

      expect(
        container.read(bluetoothAuthStateProvider).locationServiceEnabled,
        false,
      );
      expect(
        container.read(bluetoothAuthStateProvider).authorizationStatusOk,
        false,
      );
      expect(
        container.read(bluetoothAuthStateProvider).bluetoothEnabled,
        false,
      );
    });

    test('openLocationSettings()実行時、checkAllRequirements()にて、権限OKとなること',
        () async {
      final bluetoothAuthState = container
          .listen(bluetoothAuthStateProvider, (previous, next) {})
          .read();

      expect(bluetoothAuthState, BluetoothAuthState());

      final bluetoothAuthNotifier =
          container.read(bluetoothAuthStateProvider.notifier);

      await bluetoothAuthNotifier.openLocationSettings();
      // await bluetoothAuthNotifier.requestLocationAuthorization();
      // await bluetoothAuthNotifier.openBluetoothSettings();

      await bluetoothAuthNotifier.checkAllRequirements();

      expect(
        container.read(bluetoothAuthStateProvider).locationServiceEnabled,
        true,
      );
      expect(
        container.read(bluetoothAuthStateProvider).authorizationStatusOk,
        false,
      );
      expect(
        container.read(bluetoothAuthStateProvider).bluetoothEnabled,
        false,
      );
    });

    test('requestLocationAuthorization()実行時、checkAllRequirements()にて、権限OKとなること',
        () async {
      final bluetoothAuthState = container
          .listen(bluetoothAuthStateProvider, (previous, next) {})
          .read();

      expect(bluetoothAuthState, BluetoothAuthState());

      final bluetoothAuthNotifier =
          container.read(bluetoothAuthStateProvider.notifier);

      // await bluetoothAuthNotifier.openLocationSettings();
      await bluetoothAuthNotifier.requestLocationAuthorization();
      // await bluetoothAuthNotifier.openBluetoothSettings();

      await bluetoothAuthNotifier.checkAllRequirements();

      expect(
        container.read(bluetoothAuthStateProvider).locationServiceEnabled,
        false,
      );
      expect(
        container.read(bluetoothAuthStateProvider).authorizationStatusOk,
        true,
      );
      expect(
        container.read(bluetoothAuthStateProvider).bluetoothEnabled,
        false,
      );
    });

    test('openBluetoothSettings()実行時、checkAllRequirements()にて、権限OKとなること',
        () async {
      final bluetoothAuthState = container
          .listen(bluetoothAuthStateProvider, (previous, next) {})
          .read();

      expect(bluetoothAuthState, BluetoothAuthState());

      final bluetoothAuthNotifier =
          container.read(bluetoothAuthStateProvider.notifier);

      // await bluetoothAuthNotifier.openLocationSettings();
      // await bluetoothAuthNotifier.requestLocationAuthorization();
      await bluetoothAuthNotifier.openBluetoothSettings();

      await bluetoothAuthNotifier.checkAllRequirements();

      expect(
        container.read(bluetoothAuthStateProvider).locationServiceEnabled,
        false,
      );
      expect(
        container.read(bluetoothAuthStateProvider).authorizationStatusOk,
        false,
      );
      expect(
        container.read(bluetoothAuthStateProvider).bluetoothEnabled,
        true,
      );
    });

    test('全権限許可後、checkAllRequirements()にて、全権限OKとなること', () async {
      final bluetoothAuthState = container
          .listen(bluetoothAuthStateProvider, (previous, next) {})
          .read();

      expect(bluetoothAuthState, BluetoothAuthState());

      final bluetoothAuthNotifier =
          container.read(bluetoothAuthStateProvider.notifier);

      await bluetoothAuthNotifier.openLocationSettings();
      await bluetoothAuthNotifier.requestLocationAuthorization();
      await bluetoothAuthNotifier.openBluetoothSettings();

      await bluetoothAuthNotifier.checkAllRequirements();

      expect(
        container.read(bluetoothAuthStateProvider).authorizationStatusOk,
        true,
      );
      expect(
        container.read(bluetoothAuthStateProvider).bluetoothEnabled,
        true,
      );
      expect(
        container.read(bluetoothAuthStateProvider).locationServiceEnabled,
        true,
      );
    });

    test(
        'listeningBluetoothState()による監視でBluetooth ON → checkAllRequirements()にて、全権限OKとなること',
        () async {
      final bluetoothAuthState = container
          .listen(bluetoothAuthStateProvider, (previous, next) {})
          .read();

      expect(bluetoothAuthState, BluetoothAuthState());

      final bluetoothAuthNotifier =
          container.read(bluetoothAuthStateProvider.notifier);

      await bluetoothAuthNotifier.openLocationSettings();
      await bluetoothAuthNotifier.requestLocationAuthorization();
      await bluetoothAuthNotifier.openBluetoothSettings();

      final bluetoothStateStream = container.read(bluetoothStateStreamProvider);

      // bluetoothAuthNotifier.listeningBluetoothState();

      // 適当な時間を設けてメソッド内のlisten以下の処理が実行されるようwaitをしている
      await Future.delayed(const Duration(seconds: 3));

      expect(
        container.read(bluetoothAuthStateProvider).authorizationStatusOk,
        true,
      );
      expect(
        container.read(bluetoothAuthStateProvider).bluetoothEnabled,
        true,
      );
      expect(
        container.read(bluetoothAuthStateProvider).locationServiceEnabled,
        true,
      );
    });
  });
}

// import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
// import 'package:flutter_beacon_riverpod/state_notifier/notifiers/bluetooth_auth_notifier.dart';
// import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../repository/fake_beacon_adapter.dart';

// class MockBeaconAdapter extends Mock implements BeaconAdapter {}

// void main() {
//   late ProviderContainer container;

//   setUp(() {
//     container = ProviderContainer(
//       overrides: [
//         beaconAdapterProvider.overrideWithValue(FakeBeaconAdapter()),
//       ],
//     );
//   });
//   group('BluetoothStateNotifier Test', () {
//     test('初期値の確認', () async {
//       /// Providerの参照を破棄しないための処置
//       /// 参考:https://zenn.dev/omtians9425/articles/4a74f982788bdb
//       final bluetoothAuthState = container
//           .listen(bluetoothAuthStateProvider, (previous, next) {})
//           .read();

//       expect(bluetoothAuthState, BluetoothAuthState());

//       expect(
//         container.read(bluetoothAuthStateProvider).locationServiceEnabled,
//         false,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).authorizationStatusOk,
//         false,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).bluetoothEnabled,
//         false,
//       );
//     });

//     test('openLocationSettings()実行時、checkAllRequirements()にて、権限OKとなること',
//         () async {
//       final bluetoothAuthState = container
//           .listen(bluetoothAuthStateProvider, (previous, next) {})
//           .read();

//       expect(bluetoothAuthState, BluetoothAuthState());

//       final bluetoothAuthNotifier =
//           container.read(bluetoothAuthStateProvider.notifier);

//       await bluetoothAuthNotifier.openLocationSettings();
//       // await bluetoothAuthNotifier.requestLocationAuthorization();
//       // await bluetoothAuthNotifier.openBluetoothSettings();

//       await bluetoothAuthNotifier.checkAllRequirements();

//       expect(
//         container.read(bluetoothAuthStateProvider).locationServiceEnabled,
//         true,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).authorizationStatusOk,
//         false,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).bluetoothEnabled,
//         false,
//       );
//     });

//     test('requestLocationAuthorization()実行時、checkAllRequirements()にて、権限OKとなること',
//         () async {
//       final bluetoothAuthState = container
//           .listen(bluetoothAuthStateProvider, (previous, next) {})
//           .read();

//       expect(bluetoothAuthState, BluetoothAuthState());

//       final bluetoothAuthNotifier =
//           container.read(bluetoothAuthStateProvider.notifier);

//       // await bluetoothAuthNotifier.openLocationSettings();
//       await bluetoothAuthNotifier.requestLocationAuthorization();
//       // await bluetoothAuthNotifier.openBluetoothSettings();

//       await bluetoothAuthNotifier.checkAllRequirements();

//       expect(
//         container.read(bluetoothAuthStateProvider).locationServiceEnabled,
//         false,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).authorizationStatusOk,
//         true,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).bluetoothEnabled,
//         false,
//       );
//     });

//     test('openBluetoothSettings()実行時、checkAllRequirements()にて、権限OKとなること',
//         () async {
//       final bluetoothAuthState = container
//           .listen(bluetoothAuthStateProvider, (previous, next) {})
//           .read();

//       expect(bluetoothAuthState, BluetoothAuthState());

//       final bluetoothAuthNotifier =
//           container.read(bluetoothAuthStateProvider.notifier);

//       // await bluetoothAuthNotifier.openLocationSettings();
//       // await bluetoothAuthNotifier.requestLocationAuthorization();
//       await bluetoothAuthNotifier.openBluetoothSettings();

//       await bluetoothAuthNotifier.checkAllRequirements();

//       expect(
//         container.read(bluetoothAuthStateProvider).locationServiceEnabled,
//         false,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).authorizationStatusOk,
//         false,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).bluetoothEnabled,
//         true,
//       );
//     });

//     test('全権限許可後、checkAllRequirements()にて、全権限OKとなること', () async {
//       final bluetoothAuthState = container
//           .listen(bluetoothAuthStateProvider, (previous, next) {})
//           .read();

//       expect(bluetoothAuthState, BluetoothAuthState());

//       final bluetoothAuthNotifier =
//           container.read(bluetoothAuthStateProvider.notifier);

//       await bluetoothAuthNotifier.openLocationSettings();
//       await bluetoothAuthNotifier.requestLocationAuthorization();
//       await bluetoothAuthNotifier.openBluetoothSettings();

//       await bluetoothAuthNotifier.checkAllRequirements();

//       // await Future.delayed(const Duration(seconds: 3));

//       expect(
//         container.read(bluetoothAuthStateProvider).authorizationStatusOk,
//         true,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).bluetoothEnabled,
//         true,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).locationServiceEnabled,
//         true,
//       );
//     });

//     test(
//         'listeningBluetoothState()による監視でBluetooth ON → checkAllRequirements()にて、全権限OKとなること',
//         () async {
//       final bluetoothAuthState = container
//           .listen(bluetoothAuthStateProvider, (previous, next) {})
//           .read();

//       expect(bluetoothAuthState, BluetoothAuthState());

//       final bluetoothAuthNotifier =
//           container.read(bluetoothAuthStateProvider.notifier);

//       await bluetoothAuthNotifier.openLocationSettings();
//       await bluetoothAuthNotifier.requestLocationAuthorization();
//       await bluetoothAuthNotifier.openBluetoothSettings();

//       bluetoothAuthNotifier.listeningBluetoothState();

//       await Future.delayed(const Duration(seconds: 3));

//       expect(
//         container.read(bluetoothAuthStateProvider).authorizationStatusOk,
//         true,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).bluetoothEnabled,
//         true,
//       );
//       expect(
//         container.read(bluetoothAuthStateProvider).locationServiceEnabled,
//         true,
//       );
//     });
//   });
// }
