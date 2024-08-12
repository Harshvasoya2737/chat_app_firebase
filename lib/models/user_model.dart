class UserModel {
  final String email;

  UserModel({required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
