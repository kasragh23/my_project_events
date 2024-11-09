class RegisterDto {
  int? id;
  final String username;
  final String password;

  RegisterDto({
    this.id,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
