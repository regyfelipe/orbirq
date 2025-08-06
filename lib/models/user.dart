import '../core/models/user_type.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final UserType userType;
  final String? profilePhoto;
  final DateTime createdAt;
  final bool termsAccepted;
  final DateTime? termsAcceptedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.userType,
    this.profilePhoto,
    required this.createdAt,
    required this.termsAccepted,
    this.termsAcceptedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userType': userType.name,
      'profilePhoto': profilePhoto,
      'createdAt': createdAt.toIso8601String(),
      'termsAccepted': termsAccepted,
      'termsAcceptedAt': termsAcceptedAt?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      userType: UserType.values.firstWhere((e) => e.name == json['userType']),
      profilePhoto: json['profilePhoto'],
      createdAt: DateTime.parse(json['createdAt']),
      termsAccepted: json['termsAccepted'],
      termsAcceptedAt: json['termsAcceptedAt'] != null
          ? DateTime.parse(json['termsAcceptedAt'])
          : null,
    );
  }
}
