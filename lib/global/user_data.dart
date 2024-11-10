class UserData {
  static final UserData _instance = UserData._internal();
  String? userName;
  String? firstInitial;
  String? lastInitial;

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  void setUserName(String name) {
    userName = name;
    List<String> nameParts = name.split(' ');
    if (nameParts.isNotEmpty) {
      firstInitial = nameParts[0].isNotEmpty ? nameParts[0][0] : null;
      lastInitial = nameParts.length > 1 && nameParts[1].isNotEmpty
          ? nameParts[1][0]
          : null;
    }
  }
}
