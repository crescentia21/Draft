class UserProfile {
  String fullName;
  String phone;
  String street;
  String city;
  String state;
  String zip;

  UserProfile({
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
    );
  }
}
