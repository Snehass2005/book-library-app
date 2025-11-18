import 'package:book_library_app/shared/models/user_data.dart';

class UserPreferences {
  UserPreferences._();
  static final UserPreferences instance = UserPreferences._();


  UserData? _user;
  String? _userRole;

  void setUser(UserData user) => _user = user;
  UserData? getUser() => _user;

  void setUserRole(String  role) => _userRole = role;
  String? getUserRole() => _userRole;

  void clearPreferences() {
    _user = null;
    _userRole = null;
  }
}
