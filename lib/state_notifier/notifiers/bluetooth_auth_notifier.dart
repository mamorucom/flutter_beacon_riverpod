import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dart:async';

final bluetoothAuthStateProvider = StateNotifierProvider.autoDispose<
    BluetoothAuthStateNotifier, BluetoothAuthState>((ref) {
  return BluetoothAuthStateNotifier(
    ref.read(beaconAdapterProvider),
    // ref.watch(bluetoothStateStreamProvider),
  );
});

// Bluetooth ON/OFFチェック
final bluetoothStateStreamProvider =
    StreamProvider.autoDispose<BluetoothState>((ref) {
  final adapter = ref.watch(beaconAdapterProvider);

  return adapter.listeningBluetoothState();
});

// ビーコンScan初期化/停止
final scanBeaconFutureProvider = FutureProvider.autoDispose<void>((ref) {
  final adapter = ref.watch(beaconAdapterProvider);
  final bluetoothStateStream = ref.watch(bluetoothStateStreamProvider);

  if (bluetoothStateStream.asData?.value == null) {
    return Future.value();
  }

  final bluetoothState = bluetoothStateStream.value!;

  if (bluetoothState == BluetoothState.stateOn) {
    // ビーコンスキャン初期化
    return adapter.initializeScanning();
  } else if (bluetoothState == BluetoothState.stateOff) {
    // ビーコンスキャン停止
    return adapter.pauseScanBeacon();
  }
});

// 権限取得
final bluetoothAuthStateFutureProvider =
    FutureProvider.autoDispose<BluetoothAuthState>((ref) {
  final adapter = ref.watch(beaconAdapterProvider);

  return adapter.getAllRequirements();
});

// final bluetoothAuthStateStreamProvider =
//     StreamProvider.autoDispose<BluetoothAuthState>((ref) {
//   final adapter = ref.watch(beaconAdapterProvider);

//   return adapter.getAllRequirements();
// });

class BluetoothAuthStateNotifier extends StateNotifier<BluetoothAuthState> {
  BluetoothAuthStateNotifier(
    this._beaconAdapter,
    // this._bluetoothStateStream,
  ) : super(BluetoothAuthState());

  final BeaconAdapterBase _beaconAdapter;
  // final AsyncValue<BluetoothState> _bluetoothStateStream;
  // final BluetoothState _bluetoothStateStream;

  ///
  /// アプリ側の位置情報権限許可リクエスト
  ///
  Future requestLocationAuthorization() async {
    await _beaconAdapter.requestLocationAuthorization();
  }

  ///
  /// 端末側の位置情報設定許可リクエスト
  ///
  Future openLocationSettings() async {
    await _beaconAdapter.openLocationSettings();
  }

  ///
  /// 端末のBluetooth設定許可リクエスト
  ///
  Future openBluetoothSettings() async {
    await _beaconAdapter.openBluetoothSettings();
  }

  ///
  /// Bluetooth ON/OFFチェック
  ///
  void listeningBluetoothState() {
    // Stream<BluetoothState> observable =
    //     _beaconAdapter.listeningBluetoothState();
    // observable.listen((bluetoothState) async {
    //   if (bluetoothState == BluetoothState.stateOn) {
    //     // ビーコンスキャン初期化
    //     initScanBeacon();
    //   } else if (bluetoothState == BluetoothState.stateOff) {
    //     // ビーコンスキャン停止
    //     pauseScanBeacon();
    //   }
    // });
  }

  // ///
  // /// ビーコンScan初期化
  // ///
  // Future initScanBeacon() async {
  //   await _beaconAdapter.initializeScanning();
  //   await checkAllRequirements();
  // }

  // ///
  // /// ビーコンScan停止
  // ///
  // Future pauseScanBeacon() async {
  //   await _beaconAdapter.pauseScanBeacon();
  //   await checkAllRequirements();
  // }

  ///
  /// 権限チェック
  /// - ビーコンアダプタより権限取得して更新する
  ///
  Future checkAllRequirements() async {
    state = await _beaconAdapter.getAllRequirements();
  }

  Future cancel() async {
    await _beaconAdapter.cancel();
  }
}
