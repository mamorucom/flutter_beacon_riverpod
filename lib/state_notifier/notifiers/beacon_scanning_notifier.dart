// ignore_for_file: avoid_print

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/repository/beacon_adapter.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/beacon_scanning_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

// final beaconScanningStateProvider = StateNotifierProvider.autoDispose<
//     BeaconScanningNotifier, BeaconScanningState>((ref) {
//   return BeaconScanningNotifier(
//     ref.watch(bluetoothAuthStateProvider),
//     ref.read(beaconAdapterProvider),
//   );
// });


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
