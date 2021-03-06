// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/beacon_scanning_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/bluetooth_auth_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BeaconScanningPage extends StatefulHookConsumerWidget {
  const BeaconScanningPage({Key? key}) : super(key: key);

  @override
  _BeaconScanningPageState createState() => _BeaconScanningPageState();
}

class _BeaconScanningPageState extends ConsumerState<BeaconScanningPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
    ref.read(bluetoothAuthStateProvider.notifier).listeningBluetoothState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    final bluetoothAuthNotifier = ref.read(bluetoothAuthStateProvider.notifier);

    if (state == AppLifecycleState.resumed) {
      await bluetoothAuthNotifier.checkAllRequirements();

      final bluetoothAuthState = ref.read(bluetoothAuthStateProvider);

      if (bluetoothAuthState.bluetoothEnabled) {
        await bluetoothAuthNotifier.initScanBeacon();
      }
    } else if (state == AppLifecycleState.paused) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    ref.read(bluetoothAuthStateProvider.notifier).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // それぞれ状態更新時にリビルドされる
    final bluetoothAuthState = ref.watch(bluetoothAuthStateProvider);
    final beaconScanningState = ref.watch(beaconScanningStateProvider);
    // .notifierでメソッドを使用可能 ※Stateは参照不可
    final bluetoothAuthNotifier =
        ref.watch(bluetoothAuthStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        actions: [
          if (!bluetoothAuthState.authorizationStatusOk &&
              bluetoothAuthState.locationServiceEnabled)
            IconButton(
              icon: const Icon(Icons.portable_wifi_off),
              color: Colors.red,
              onPressed: () async {
                await bluetoothAuthNotifier.requestLocationAuthorization();
              },
            ),
          if (!bluetoothAuthState.locationServiceEnabled)
            IconButton(
              icon: const Icon(Icons.location_off),
              color: Colors.red,
              onPressed: () async {
                if (Platform.isAndroid) {
                  await bluetoothAuthNotifier.openLocationSettings();
                } else if (Platform.isIOS) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Location Services Off'),
                        content: const Text(
                            'Please enable Location Services on Settings > Privacy > Location Services.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          bluetoothAuthState.bluetoothEnabled
              ? IconButton(
                  icon: const Icon(Icons.bluetooth_connected),
                  onPressed: () {},
                  color: Colors.lightBlueAccent,
                )
              : IconButton(
                  icon: const Icon(Icons.bluetooth),
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      try {
                        await bluetoothAuthNotifier.openBluetoothSettings();
                      } on PlatformException catch (e) {
                        print(e);
                      }
                    } else if (Platform.isIOS) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Bluetooth is Off'),
                            content: const Text(
                                'Please enable Bluetooth on Settings > Bluetooth.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  color: Colors.red,
                ),
        ],
      ),
      body: beaconScanningState.beacons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: beaconScanningState.beacons.map(
                  (beacon) {
                    return ListTile(
                      title: Text(
                        beacon.proximityUUID,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              'Major: ${beacon.major}\nMinor: ${beacon.minor}',
                              style: const TextStyle(fontSize: 13.0),
                            ),
                            flex: 1,
                            fit: FlexFit.tight,
                          ),
                          Flexible(
                            child: Text(
                              'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                              style: const TextStyle(fontSize: 13.0),
                            ),
                            flex: 2,
                            fit: FlexFit.tight,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ).toList(),
            ),
    );
  }
}
