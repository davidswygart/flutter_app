
class UUIDs{
  static const String device = 'HTT_001';
  static const String advertising = '4768cc06-151b-11ec-82a8-0242ac130003';


  static final GameMode gameMode = GameMode();
  static final status = Status();
  static final results = Results();
}

class GameMode{
  static const String service = '1901bce2-151b-11ec-82a8-0242ac130003';

  //Characteristic UUIDs
  static const String playerNum = '4768c9cc-151b-11ec-82a8-0242ac130003';
  static const String roundTimeout = '';
}

class Status{
  static const String service = '';
}

class Results{
  static const String service = '';
}