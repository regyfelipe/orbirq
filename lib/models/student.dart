import 'package:orbirq/core/models/user_type.dart';
import 'user.dart';

class Student extends User {
  final String? cpf;
  final DateTime? birthDate;
  final String? state;
  final String? targetExam;
  final String? inviteCode;

  Student({
    required super.id,
    required super.fullName,
    required super.email,
    required super.userType,
    super.profilePhoto,
    required super.createdAt,
    required super.termsAccepted,
    super.termsAcceptedAt,
    this.cpf,
    this.birthDate,
    this.state,
    this.targetExam,
    this.inviteCode,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'cpf': cpf,
      'birthDate': birthDate?.toIso8601String(),
      'state': state,
      'targetExam': targetExam,
      'inviteCode': inviteCode,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
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
      cpf: json['cpf'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      state: json['state'],
      targetExam: json['targetExam'],
      inviteCode: json['inviteCode'],
    );
  }
}
