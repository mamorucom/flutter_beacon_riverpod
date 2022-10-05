import 'package:freezed_annotation/freezed_annotation.dart';

part 'bluetooth_auth_state.freezed.dart'; // (1)
// part 'bt_state.g.dart';

@freezed
class BluetoothAuthState with _$BluetoothAuthState {
  // (2)
  factory BluetoothAuthState({
    // 認証ステータス
    @Default(false) bool authorizationStatusOk, // (3)
    // 位置情報認証許可
    @Default(false) bool locationServiceEnabled,
    // Bluetooth認証許可
    @Default(false) bool bluetoothEnabled,
  }) = _BluetoothAuthState; // (2)

  // factory BluetoothAuthState.fromJson(Map<String, dynamic> json) =>
  //     _$BluetoothAuthStateFromJson(json);

  factory BluetoothAuthState.empty() => BluetoothAuthState(
        authorizationStatusOk: false,
        locationServiceEnabled: false,
        bluetoothEnabled: false,
      );
}
