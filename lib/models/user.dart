class User {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }
}
