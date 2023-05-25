class User {
  late String uuid;
  late String firstName;
  late String lastName;
  late String username;
  late String email;
  late String? avatarUrl;
  late String serialNumber;

  User({
    required this.uuid, 
    required this.firstName, 
    required this.lastName, 
    required this.username, 
    required this.email,
    this.avatarUrl,
    required this.serialNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      username: json['username'] ?? "",
      avatarUrl: json['avatar_url'] ?? "",
      serialNumber: json['serial_number'] ?? "",
      email: json['email'],
    );
  }
}