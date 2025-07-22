import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish/models/user_model.dart';

class UserNotifier extends Notifier<UserModel> {
  @override
  UserModel build() {
    return UserModel(username: '', phone: '', isVendor: false, profilePic: '', location: '',);
  }

  void updateName(String username) {
    state = state.copyWith(username: username);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }
  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  void updateProfilePicture(String profilePic) {
    state = state.copyWith(profilePic: profilePic);
  }

  void updateVendorStatus(bool isVendor) {
    state = state.copyWith(isVendor: isVendor);
  }

  void clearForm() {
    state = UserModel(username: '', phone: '', profilePic: '', isVendor: false, location: '', );
  }
}

final userProvider = NotifierProvider<UserNotifier, UserModel>(() {
  return UserNotifier();
});
