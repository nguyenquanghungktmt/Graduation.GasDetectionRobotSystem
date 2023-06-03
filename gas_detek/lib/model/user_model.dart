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
      email: json['email'] ?? "",
      serialNumber: json['device_serial_number'] ?? "",
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, Object?> toJson() => {
    'uuid': uuid,
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'email': email,
    'device_serial_number': serialNumber,
    'avatar_url': avatarUrl
  };

  String getFullName() {
    return "$firstName $lastName";
  }
}
