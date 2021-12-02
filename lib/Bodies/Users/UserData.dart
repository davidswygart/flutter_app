
class User {
  static const String boxName = "savedUsers";
  String name;
  int id;
  bool authenticated;
  //bool authenticated = false;


  User({
    this.name = 'Guest',
    this.id = 0,
    this.authenticated = false
  });
}