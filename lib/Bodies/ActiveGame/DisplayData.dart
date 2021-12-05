class DisplayData {
  final List<int> rgbVals;

  DisplayData(this.rgbVals);

  Map<String, dynamic> toJson() => {
  'rgb': rgbVals,
  };
}