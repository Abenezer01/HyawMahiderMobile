class UserModel {
  final String fullName;
  final List<String> roles;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String smallTeamId;
  final dynamic memberId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.fullName,
    required this.roles,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.smallTeamId,
    required this.memberId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['full_name'] ?? '',
      roles: List<String>.from(json['roles']),
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      smallTeamId: json['small_team_id'] ?? '',
      memberId: json['member_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'roles': roles,
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'small_team_id': smallTeamId,
      'member_id': memberId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Ability {
  final String action;
  final String subject;

  Ability({required this.action, required this.subject});
}

class AuthResponse {
  final String token;
  final UserModel user;
  final List<Ability> abilities;

  AuthResponse({
    required this.token,
    required this.user,
    required this.abilities,
  });
}
