import 'package:orbirq/core/models/user_type.dart';
import 'user.dart';

class Teacher extends User {
  final String miniBio;
  final String areaOfExpertise;
  final String? instagramOrWebsite;
  final String? proofDocument;
  final String? referralCode;

  Teacher({
    required super.id,
    required super.fullName,
    required super.email,
    required super.userType,
    required super.profilePhoto,
    required super.createdAt,
    required super.termsAccepted,
    super.termsAcceptedAt,
    required this.miniBio,
    required this.areaOfExpertise,
    this.instagramOrWebsite,
    this.proofDocument,
    this.referralCode,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'miniBio': miniBio,
      'areaOfExpertise': areaOfExpertise,
      'instagramOrWebsite': instagramOrWebsite,
      'proofDocument': proofDocument,
      'referralCode': referralCode,
    };
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
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
      miniBio: json['miniBio'],
      areaOfExpertise: json['areaOfExpertise'],
      instagramOrWebsite: json['instagramOrWebsite'],
      proofDocument: json['proofDocument'],
      referralCode: json['referralCode'],
    );
  }
}
