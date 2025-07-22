class UserModel {
  final String username;
  // final String id;
  bool isVendor;
  final String phone;
  final String profilePic;
  final String location;
  UserModel({
    required this.username, 
    // required this.id, 
    required this.phone,
    required this.profilePic,
    required this.isVendor,
    required this.location
  });

  UserModel copyWith({
    String? username,
    // String? id,
    String? phone,
    String? profilePic,
    String? location,
    bool? isVendor,
  }) {
    return UserModel(
      username: username ?? this.username,
      // id: id ?? this.id,
      phone: phone ?? this.phone,
      profilePic: profilePic ?? this.profilePic,
      isVendor: isVendor ?? this.isVendor,
      location: location ?? this.location,
    );
  }
}
