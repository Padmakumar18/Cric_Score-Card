import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;
  bool get hasProfile => _userProfile != null;

  void createProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _userProfile = profile.copyWith(updatedAt: DateTime.now());
    notifyListeners();
  }

  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }
}
