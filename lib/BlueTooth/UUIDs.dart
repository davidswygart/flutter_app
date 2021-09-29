class UUIDs {
  static const String deviceName = 'HTT_001';

  //Service UUIDs
  static const String settingsService = 'bbbbbbbb-151b-11ec-82a8-0242ac130003';

  //Characteristic UUIDs
  static const Map <String, String> settingsChar = {
    'numColors': "00000001-151b-11ec-82a8-0242ac130003",
    'numRounds': "00000002-151b-11ec-82a8-0242ac130003",
    'roundDelay': "00000003-151b-11ec-82a8-0242ac130003",
    'delayRand': "00000004-151b-11ec-82a8-0242ac130003",
    'colorInOrder': "00000005-151b-11ec-82a8-0242ac130003",
    'moveSpeed': "00000006-151b-11ec-82a8-0242ac130003",
    'lightTimeout': "00000007-151b-11ec-82a8-0242ac130003",
    'roundTimeout': "00000008-151b-11ec-82a8-0242ac130003",
  };
}