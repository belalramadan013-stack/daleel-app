class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String accountType; // 'individual' or 'lawyer'
  final String? selectedCountry;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.accountType,
    this.selectedCountry,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      accountType: json['accountType'] as String? ?? 'individual',
      selectedCountry: json['selectedCountry'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'accountType': accountType,
      'selectedCountry': selectedCountry,
      'profileImage': profileImage,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? accountType,
    String? selectedCountry,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accountType: accountType ?? this.accountType,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
