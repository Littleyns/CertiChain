import '../models/AuthenticatedUser.dart';

class UserSession {
  static AuthenticatedUser? _currentUser;

  static AuthenticatedUser get currentUser {
    if (_currentUser == null) {
      throw Exception("Aucun utilisateur n'est actuellement connecté.");
    }
    return _currentUser!;
  }

  static void loginUser(AuthenticatedUser user) {
    _currentUser = user;
  }

  static void logoutUser() {
    _currentUser = null;
  }
}
