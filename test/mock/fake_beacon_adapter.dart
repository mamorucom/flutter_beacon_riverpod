import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
import 'package:flutter_beacon_riverpod/util/constants.dart';

import '../dummy/dummy_data.dart';

class FakeBeaconAdapter implements BeaconAdapterBase {
  bool _isRequestLocationAuthorization = false;
  bool _isOpenLocationSettings = false;
  bool _isopenBluetoothSettings = false;

  bool _isBroadcasting = false;

  // StreamController<List<Beacon>>? _streamBeaconRangingController =
  //     StreamController();

  @override
  Future requestLocationAuthorization() async {
    // リクエストにより許可されたと想定(1)
    _isRequestLocationAuthorization = await Future.value(true);
  }

  @override
  Future openLocationSettings() async {
    // リクエストにより許可されたと想定(1)
    _isOpenLocationSettings = await Future.value(true);
  }

  @override
  Future openBluetoothSettings() async {
    // リクエストにより許可されたと想定(1)
    _isopenBluetoothSettings = await Future.value(true);
  }

  @override
  Stream<BluetoothState> listeningBluetoothState() {
    return Stream.value(BluetoothState.stateOn);
  }

  // @override
  // void startRanging(bool mounted) {
  //   // ignore: unused_local_variable
  //   Timer _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
  //     // ダミーの信号データを返す(2)
  //     final dummyBeaons = [
  //       const Beacon(
  //         proximityUUID: kProximityUUID,
  //         major: kDummyBeaconMajor,
  //         minor: kDummyBeaconMinor,
  //         accuracy: kDummyAccuracy,
  //       ),
  //     ];
  //     _streamBeaconRangingController?.sink.add(dummyBeaons);
  //   });
  // }

  // @override
  // Stream<List<Beacon>> listeningRanging() {
  //   return _streamBeaconRangingController!.stream;
  // }

  @override
  Future pauseScanBeacon() {
    // TODO: implement pauseScanBeacon
    throw UnimplementedError();
  }

  @override
  Future<BluetoothAuthState> getAllRequirements() async {
    final _authorizationStatusOk = _isRequestLocationAuthorization;
    final _bluetoothEnabled = _isopenBluetoothSettings;
    final _locationServiceEnabled = _isOpenLocationSettings;

    return BluetoothAuthState(
      authorizationStatusOk: _authorizationStatusOk,
      bluetoothEnabled: _bluetoothEnabled,
      locationServiceEnabled: _locationServiceEnabled,
    );
  }

  @override
  Future initializeScanning() => Future.value(true);

  @override
  Future<void> cancel() {
    // TODO: implement cancel
    throw UnimplementedError();
  }

  @override
  Future startBroadcast(BeaconBroadcast beaconBroadcast) async {
    _isBroadcasting = await Future.value(true);
  }

  @override
  Future stopBroadcast() async {
    _isBroadcasting = await Future.value(false);
  }

  @override
  Future<bool> isBroadcasting() {
    return Future.value(_isBroadcasting);
  }

  @override
  Stream<RangingResult> watchRanging() {
    final dummyBeaons = [
      const Beacon(
        proximityUUID: kProximityUUID,
        major: kDummyBeaconMajor,
        minor: kDummyBeaconMinor,
        accuracy: kDummyAccuracy,
      ),
    ];

    final json = {
      'region': {
        'identifier': 'beacon',
        'major': null,
        'minor': null,
      },
      'beacons': dummyBeaons,
    };

    final rangingResult = RangingResult.from(json);

    return Stream.value(rangingResult);
  }
}
