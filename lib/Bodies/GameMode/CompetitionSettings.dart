class Preset {
  static const String boxName = "savedPresets";

  String title;
  String description;

  int key;
  bool editable;

  int numRounds;
  double roundDelay;
  double delayRandomness;
  bool colorInOrder;
  double moveSpeed;
  double lightTimeout;
  double roundTimeout;
  List<int> colorOrder;

  Preset({
    this.title = 'Title',
    this.description = 'Add a short description',
    this.key = 100,
    this.editable = true,
    this.numRounds = 5,
    this.roundDelay = 1,
    this.delayRandomness = 0,
    this.colorInOrder = false,
    this.moveSpeed = 0,
    this.lightTimeout = 0,
    this.roundTimeout = 0,
    this.colorOrder = const [0, 1, 2, 3],
  });
}

List<Preset> compPresets = [
  Preset(
    title: 'Shoot Off',
    description: 'Compete with friends and try to shoot your color first',
    key: 0,
    editable: false,
  ),
  Preset(
    title: 'Colors in Order',
    description:
        'Shoot the paddles in order as directed by the indicator color',
    colorInOrder: true,
    key: 1,
    editable: false,
  ),
  Preset(
    title: 'Moving Target',
    description:
        'Anticipate the location of target as the indicator switches between paddles',
    key: 2,
    editable: false,
    moveSpeed: 1,
  ),
  Preset(
    title: 'Disappearing Lights',
    description: 'Memorize the order of the lights before they disappear',
    key: 3,
    colorInOrder: true,
    editable: false,
    lightTimeout: 1,
  ),
];
