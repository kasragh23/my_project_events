class LoginModel {
  int? id;
  final String? username;
  final String? password;

  LoginModel({
    this.id,
    required this.username,
    required this.password,
  });

  factory LoginModel.fromJson(final Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }
}
