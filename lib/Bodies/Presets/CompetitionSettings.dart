const preset_colorInOrder = {
  'title': 'Colors in Order',
  'Number of Rounds': 3,
  'Delay between Rounds': 1,
  'Multiplayer Mode':
  4, //Indicates the number of paddles in async mode, 0 indicates simultaneous play
  'Movement Speed': 0,
  'Light Timeout': 0,
  'Round Timeout': 0,


  'key': 0,
  'editable': false,
  'Description': 'Each player shoots the colors in the set order',
  'Color Order': ['blue', 'green', 'red'], //Only applicable for asynch play
  'Delay Randomness': 0,
};

const preset_ShootOff = {
  'title': 'Shoot Off',
  'Number of Rounds': 5,
  'Delay between Rounds': 1,
  'Multiplayer Mode':
  0, //Indicates the number of paddles in async mode, 0 indicates simultaneous play
  'Movement Speed': 0,
  'Light Timeout': 0,
  'Round Timeout': 0,

  'key': 1,
  'editable': false,
  'Description': 'Each player shoots the colors in the set order',
  'Color Order': ['blue', 'green', 'red'], //Only applicable for asynch play
  'Delay Randomness': 0,
};

const preset_MovingTarget = {
  'title': 'Moving Target',
  'Number of Rounds': 5,
  'Delay between Rounds': 1,
  'Multiplayer Mode':
  0, //Indicates the number of paddles in async mode, 0 indicates simultaneous play
  'Movement Speed': 30,
  'Light Timeout': 0,
  'Round Timeout': 0,

  'key': 2,
  'editable': false,
  'Description': 'Color will swap targets',
  'Color Order': ['blue', 'green', 'red'], //Only applicable for asynch play
  'Delay Randomness': 0,
};

const preset_DisapearingLights = {
  'title': 'Disappearing Lights',
  'Number of Rounds': 5,
  'Delay between Rounds': 1,
  'Multiplayer Mode':
  4, //Indicates the number of paddles in async mode, 0 indicates simultaneous play
  'Movement Speed': 0,
  'Light Timeout': 500,
  'Round Timeout': 0,

  'key': 3,
  'editable': false,
  'Description': 'Color will swap targets',
  'Color Order': ['blue', 'green', 'red'], //Only applicable for asynch play
  'Delay Randomness': 0,
};

const CompPresets = [
  preset_ShootOff,
  preset_colorInOrder,
  preset_MovingTarget,
  preset_DisapearingLights,
];