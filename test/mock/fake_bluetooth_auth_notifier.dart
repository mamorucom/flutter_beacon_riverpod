import 'package:flutter_beacon_riverpod/state_notifier/notifiers/bluetooth_auth_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/bluetooth_auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeBluetoothAuthNotifier extends StateNotifier<BluetoothAuthState>
    implements BluetoothAuthStateNotifier {
  FakeBluetoothAuthNotifier(
    BluetoothAuthState bluetoothAuthState,
  ) : super(bluetoothAuthState);

  @override
  Future cancel() {
    throw UnimplementedError();
  }

  @override
  Future checkAllRequirements() {
    throw UnimplementedError();
  }

  // @override
  // Future initScanBeacon() {
  //   throw UnimplementedError();
  // }

  // @override
  // void listeningBluetoothState() {}

  @override
  Future openBluetoothSettings() {
    throw UnimplementedError();
  }

  @override
  Future openLocationSettings() {
    throw UnimplementedError();
  }

  // @override
  // Future pauseScanBeacon() {
  //   throw UnimplementedError();
  // }

  @override
  Future requestLocationAuthorization() {
    throw UnimplementedError();
  }
}
