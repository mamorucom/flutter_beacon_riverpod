// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
import 'package:flutter_beacon_riverpod/util/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state_notifier/states/beacon_scanning_state.dart';

abstract class BeaconAdapterBase {
  ///
  /// 位置情報の権限許可リクエスト
  ///
  Future requestLocationAuthorization();

  ///
  /// 端末位置情報 ON
  ///
  Future openLocationSettings();

  ///
  /// 端末Bluetooth ON
  ///
  Future openBluetoothSettings();

  ///
  /// Bluetooth ON/OFF状態の検知
  ///
  Stream<BluetoothState> listeningBluetoothState();

  ///
  /// ビーコン初期化
  ///
  Future initializeScanning();

  ///
  /// 権限取得
  ///
  Future<BluetoothAuthState> getAllRequirements();

  // ///
  // /// レンジング監視開始
  // ///
  // void startRanging(bool mounted);
  ///
  /// レンジング監視開始
  ///
  Stream<RangingResult> watchRanging();

  // ///
  // /// レンジングによる監視
  // ///
  // Stream<List<Beacon>> listeningRanging();

  // ///
  // /// ビーコンスキャン停止
  // ///
  // Future pauseScanBeacon();

  ///
  /// キャンセル(破棄)処理
  ///
  Future cancel();

  ///
  /// 発信開始
  ///
  Future stopBroadcast();

  ///
  /// 発信停止
  ///
  Future startBroadcast(BeaconBroadcast beaconBroadcast);

  ///
  /// 発信中チェック
  ///
  Future<bool> isBroadcasting();
}

// Bluetooth ON/OFFチェック
final bluetoothStateStreamProvider =
    StreamProvider.autoDispose<BluetoothState>((ref) {
  final adapter = ref.watch(beaconAdapterProvider);

  return adapter.listeningBluetoothState();
});

// ビーコンScan初期化/停止
final initializeScanningFutureProvider =
    FutureProvider.autoDispose<void>((ref) {
  final adapter = ref.watch(beaconAdapterProvider);
  final bluetoothStateStream = ref.watch(bluetoothStateStreamProvider);

  if (bluetoothStateStream.asData?.value == null) {
    return Future.error('bluetoothStateStream error.');
  }

  final bluetoothState = bluetoothStateStream.value!;

  if (bluetoothState == BluetoothState.stateOn) {
    // ビーコンスキャン初期化
    return adapter.initializeScanning();
  } else if (bluetoothState == BluetoothState.stateOff) {
    // // ビーコンスキャン停止
    // return adapter.pauseScanBeacon();
  }
});

// 権限取得
final bluetoothAuthStateFutureProvider =
    FutureProvider.autoDispose<BluetoothAuthState>((ref) {
  final adapter = ref.watch(beaconAdapterProvider);
  final bluetoothStateStream = ref.watch(bluetoothStateStreamProvider);

  if (bluetoothStateStream.asData?.value == null) {
    return Future.error('bluetoothStateStream error.');
  }

  ref.refresh(initializeScanningFutureProvider);

  return adapter.getAllRequirements();
});

/// BeaconScanningStateのStream
/// - ※今回はなくても良いがBeaconリストをView用のデータに加工したいときに利用する。
final beaconScanningStateStreamProvider =
    StreamProvider.autoDispose<BeaconScanningState>((ref) {
  final beaconListStream = ref.watch(beaconListStreamProvider);

  return beaconListStream.when(data: (data) {
    return Stream.value(BeaconScanningState(beacons: data));
  }, error: (error, st) {
    return Stream.error('beaconScanningStateStreamProvider error.');
  }, loading: () {
    return const Stream.empty();
  });
});

/// ビーコンリストのStream（並び替え対応）
final sortedBeaconListStreamProvider =
    StreamProvider.autoDispose<List<Beacon>>((ref) {
  final beaconListStream = ref.watch(beaconListStreamProvider);

  final beacons = beaconListStream.asData?.value ?? [];

  // 1:proximityUUID, 2:major, 3:minorの順に並び替え
  beacons.sort(((a, b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }));

  return Stream.value(beacons);
});

/// ビーコンリストのStream
final beaconListStreamProvider =
    StreamProvider.autoDispose<List<Beacon>>((ref) {
  final beaconRangingStream = ref.watch(beaconRangingStreamProvider);

  if (beaconRangingStream.asData?.value == null) {
    return const Stream.empty();
  }

  final beaconRangingResult = beaconRangingStream.asData!.value;

  print(beaconRangingResult);

  final beacons = <Beacon>[];
  beacons.addAll(beaconRangingResult.beacons);
  // beacons.sort(_compareParameters);

  return Stream.value(beacons);
});

/// ビーコンレンジングによる受信結果のStream
final beaconRangingStreamProvider =
    StreamProvider.autoDispose<RangingResult>((ref) {
  final bluetoothAuthStateFuture = ref.watch(bluetoothAuthStateFutureProvider);
  final adapter = ref.watch(beaconAdapterProvider);

  if (bluetoothAuthStateFuture.asData?.value == null) {
    return const Stream.empty();
  }

  final bluetoothAuthState = bluetoothAuthStateFuture.asData!.value;
  // 権限チェック
  if (!bluetoothAuthState.authorizationStatusOk ||
      !bluetoothAuthState.locationServiceEnabled ||
      !bluetoothAuthState.bluetoothEnabled) {
    return const Stream.empty();
  }

  return adapter.watchRanging();
});

final beaconAdapterProvider = Provider.autoDispose<BeaconAdapterBase>((ref) {
  return BeaconAdapter();
});

///
/// BeaconAdapter実装クラス
///
class BeaconAdapter implements BeaconAdapterBase {
  BeaconAdapter();

  // StreamController<List<Beacon>>? _streamBeaconRangingController =
  //     StreamController();
  // StreamSubscription<RangingResult>? _streamRanging;

  @override
  Future requestLocationAuthorization() async {
    await flutterBeacon.requestAuthorization;
  }

  @override
  Future openLocationSettings() async {
    await flutterBeacon.openLocationSettings;
  }

  @override
  Future openBluetoothSettings() async {
    try {
      await flutterBeacon.openBluetoothSettings;
    } on PlatformException catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Stream<BluetoothState> listeningBluetoothState() {
    return flutterBeacon.bluetoothStateChanged();
  }

  @override
  Future initializeScanning() async {
    await flutterBeacon.initializeScanning;
  }

  @override
  Future<BluetoothAuthState> getAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;
    final authorizationStatus = await flutterBeacon.authorizationStatus;
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.whenInUse ||
            authorizationStatus == AuthorizationStatus.always;
    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;

    print('RETURNED, authorizationStatusOk=$authorizationStatusOk, '
        'locationServiceEnabled=$locationServiceEnabled, '
        'bluetoothEnabled=$bluetoothEnabled');

    return BluetoothAuthState(
      authorizationStatusOk: authorizationStatusOk,
      bluetoothEnabled: bluetoothEnabled,
      locationServiceEnabled: locationServiceEnabled,
    );
  }

  // @override
  // void startRanging(bool mounted) {
  //   final regions = <Region>[
  //     Region(
  //       identifier: 'Cubeacon',
  //       proximityUUID: kProximityUUID,
  //     ),
  //   ];

  //   // _streamRanging = flutterBeacon.ranging(regions);
  //   // _streamRanging = flutterBeacon.ranging(regions).listen(
  //   //   (RangingResult result) {
  //   //     print(result);
  //   //     if (mounted) {
  //   //       // if (isMounted()) {
  //   //       final beacons = <Beacon>[];
  //   //       beacons.addAll(result.beacons);
  //   //       beacons.sort(_compareParameters);
  //   //       // listenしているものにビーコン情報を届ける (1)
  //   //       _streamBeaconRangingController?.sink.add(beacons);
  //   //     }
  //   //   },
  //   // );
  // }

  @override
  Stream<RangingResult> watchRanging() {
    final regions = <Region>[
      Region(
        identifier: 'Cubeacon',
        proximityUUID: kProximityUUID,
      ),
    ];
    return flutterBeacon.ranging(regions);
  }

  // @override
  // Stream<List<Beacon>> listeningRanging() {
  //   return _streamBeaconRangingController!.stream;
  // }

  // ///
  // /// 並び替え
  // ///
  // int _compareParameters(Beacon a, Beacon b) {
  //   int compare = a.proximityUUID.compareTo(b.proximityUUID);

  //   if (compare == 0) {
  //     compare = a.major.compareTo(b.major);
  //   }

  //   if (compare == 0) {
  //     compare = a.minor.compareTo(b.minor);
  //   }

  //   return compare;
  // }

  // @override
  // Future pauseScanBeacon() async {
  //   _streamRanging?.pause();
  // }

  @override
  Future<void> cancel() async {
    // _streamRanging?.cancel();
    flutterBeacon.stopBroadcast();
    flutterBeacon.close;
  }

  @override
  Future startBroadcast(BeaconBroadcast beaconBroadcast) async {
    await flutterBeacon.startBroadcast(beaconBroadcast);
  }

  @override
  Future stopBroadcast() async {
    await flutterBeacon.stopBroadcast();
  }

  @override
  Future<bool> isBroadcasting() async {
    return await flutterBeacon.isBroadcasting();
  }
}
