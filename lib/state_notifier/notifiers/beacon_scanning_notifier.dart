// ignore_for_file: avoid_print

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/beacon_scanning_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'bluetooth_auth_notifier.dart';

// final beaconScanningStateProvider = StateNotifierProvider.autoDispose<
//     BeaconScanningNotifier, BeaconScanningState>((ref) {
//   return BeaconScanningNotifier(
//     ref.watch(bluetoothAuthStateProvider),
//     ref.read(beaconAdapterProvider),
//   );
// });

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

/// ビーコンリストのStream
/// - ※今回はなくても良いがBeaconリストをView用のデータに加工したいときに利用する。
final beaconScanningStateStreamProvider =
    StreamProvider.autoDispose<BeaconScanningState>((ref) {
  final beaconListStream = ref.watch(beaconListStreamProvider);

  if (beaconListStream.asData?.value == null) {
    return const Stream.empty();
  }

  final beacons = beaconListStream.asData!.value;

  return Stream.value(BeaconScanningState(beacons: beacons));
});

// class BeaconScanningNotifier extends StateNotifier<BeaconScanningState> {
//   BeaconScanningNotifier(
//     this._bluetoothAuthState,
//     this._beaconAdapter,
//   ) : super(BeaconScanningState()) {
//     if (_bluetoothAuthState.authorizationStatusOk &&
//         _bluetoothAuthState.locationServiceEnabled &&
//         _bluetoothAuthState.bluetoothEnabled) {
//       _listeningRanging(mounted);
//     }
//   }

//   final BluetoothAuthState _bluetoothAuthState;
//   final BeaconAdapterBase _beaconAdapter;

//   void _listeningRanging(bool mounted) {
//     _beaconAdapter.listeningRanging().listen((beacons) {
//       state = state.copyWith(beacons: beacons);
//     });

//     _beaconAdapter.startRanging(mounted);
//   }
// }
