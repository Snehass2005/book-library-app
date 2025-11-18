class UserData {
  final String id;
  final String name;
  final String email;
  final String role;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
  };
}
