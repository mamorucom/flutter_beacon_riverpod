// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/beacon_broadcasting_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/notifiers/bluetooth_auth_notifier.dart';
import 'package:flutter_beacon_riverpod/state_notifier/states/beacon_broadcasting_state.dart';
import 'package:flutter_beacon_riverpod/util/constants.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BeaconBroadcastingPage extends StatefulHookConsumerWidget {
  const BeaconBroadcastingPage({Key? key}) : super(key: key);

  @override
  _BeaconBroadcastingPageState createState() => _BeaconBroadcastingPageState();
}

class _BeaconBroadcastingPageState extends ConsumerState<BeaconBroadcastingPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    ref.read(bluetoothAuthStateProvider.notifier).checkAllRequirements();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      await ref
          .read(bluetoothAuthStateProvider.notifier)
          .checkAllRequirements();
    } else if (state == AppLifecycleState.paused) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(bluetoothAuthStateProvider.notifier).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(beaconBroadcastingStateProvider);
    final notifier = ref.watch(beaconBroadcastingStateProvider.notifier);
    final clearFocus = useFocusNode();
    final uuidController = useTextEditingController(text: kProximityUUID);
    final majorController = useTextEditingController(text: '0');
    final minorController = useTextEditingController(text: '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast'),
      ),
      body: _BodyWidget(
        context: context,
        clearFocus: clearFocus,
        state: state,
        notifier: notifier,
        uuidController: uuidController,
        majorController: majorController,
        minorController: minorController,
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  _BodyWidget({
    Key? key,
    required this.context,
    required this.clearFocus,
    required this.state,
    required this.notifier,
    required this.uuidController,
    required this.majorController,
    required this.minorController,
  }) : super(key: key);

  final regexUUID = RegExp(
      r'[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}');

  final BuildContext context;
  final FocusNode clearFocus;
  final BeaconBroadcastingState state;
  final BeaconBroadcastingNotifier notifier;
  final TextEditingController uuidController;
  final TextEditingController majorController;
  final TextEditingController minorController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(clearFocus),
      child: state.broadcastReady != true
          ? const Center(child: Text('Please wait...'))
          : Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    uuidField,
                    majorField,
                    minorField,
                    const SizedBox(height: 16),
                    buttonBroadcast,
                  ],
                ),
              ),
            ),
    );
  }

  Widget get uuidField {
    return TextFormField(
      readOnly: state.isBroadcasting,
      controller: uuidController,
      decoration: const InputDecoration(
        labelText: 'Proximity UUID',
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Proximity UUID required';
        }

        if (!regexUUID.hasMatch(val)) {
          return 'Invalid Proxmity UUID format';
        }

        return null;
      },
    );
  }

  Widget get majorField {
    return TextFormField(
      readOnly: state.isBroadcasting,
      controller: majorController,
      decoration: const InputDecoration(
        labelText: 'Major',
      ),
      keyboardType: TextInputType.number,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Major required';
        }

        try {
          int major = int.parse(val);

          if (major < 0 || major > 65535) {
            return 'Major must be number between 0 and 65535';
          }
        } on FormatException {
          return 'Major must be number';
        }

        return null;
      },
    );
  }

  Widget get minorField {
    return TextFormField(
      readOnly: state.isBroadcasting,
      controller: minorController,
      decoration: const InputDecoration(
        labelText: 'Minor',
      ),
      keyboardType: TextInputType.number,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Minor required';
        }

        try {
          int minor = int.parse(val);

          if (minor < 0 || minor > 65535) {
            return 'Minor must be number between 0 and 65535';
          }
        } on FormatException {
          return 'Minor must be number';
        }

        return null;
      },
    );
  }

  Widget get buttonBroadcast {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary:
          state.isBroadcasting ? Colors.red : Theme.of(context).primaryColor,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () async {
        notifier.toggleBroadcasting(
          uuidController.text,
          int.tryParse(majorController.text) ?? 0,
          int.tryParse(minorController.text) ?? 0,
        );
      },
      child: Text('Broadcast${state.isBroadcasting ? 'ing' : ''}'),
    );
  }
}
