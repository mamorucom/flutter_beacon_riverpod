import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_riverpod/util/constants.dart';

const int kDummyBeaconMajor = 1;
const int kDummyBeaconMinor = 13;
const double kDummyAccuracy = 50.6;

final dummyBeacons = [
  const Beacon(
    proximityUUID: kProximityUUID,
    // macAddress: ,
    major: kDummyBeaconMajor,
    minor: kDummyBeaconMinor,
    accuracy: kDummyAccuracy,
    proximity: Proximity.immediate,
  ),
  const Beacon(
    proximityUUID: kProximityUUID,
    // macAddress: ,
    major: kDummyBeaconMajor - 1,
    minor: kDummyBeaconMinor - 1,
    accuracy: kDummyAccuracy - 1,
    proximity: Proximity.far,
  ),
];

final dummyRangingResultJson = {
  'region': {'identifier': 'beacon', 'major': null, 'minor': null},
  'beacons': [
    {
      'proximityUUID': dummyBeacons[0].proximityUUID,
      // 'macAddress': '12-34-56-78',
      'major': dummyBeacons[0].major,
      'minor': dummyBeacons[0].minor,
      // 'rssi': '60',
      // 'txPower': '70',
      'accuracy': dummyBeacons[0].accuracy,
      'proximity': 'immediate'
    }
  ],
};
