class User {
  final String username;
  final String email;
  final bool isDonor;
  final String id;
  final String? firstName;
  final String? lastName;
  final String? birthday;
  final String? bloodType;
  final String? gender;
  final String? country;
  final String? zone;
  final double? longitude;
  final double? latitude;
  final String? telephone;
  final bool? isMapVisible;
  final bool? allowAllNotification;
  final bool? isNameVisible;

  User(
      {required this.username,
      required this.email,
      required this.isDonor,
      required this.id,
      this.country,
      this.firstName,
      this.lastName,
      this.telephone,
      this.birthday,
      this.bloodType,
      this.gender,
      this.zone,
      this.longitude,
      this.latitude,
      this.isMapVisible,
      this.allowAllNotification,
      this.isNameVisible});

  // Factory method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      isDonor: json['is_donor'],
      firstName: json['firstname'],
      id: json['_id'],
      lastName: json['lastname'],
      birthday: json['birthday'],
      country: json['country'],
      zone: json['zone'],
      bloodType: json['blood_type'],
      gender: json['gender'],
      longitude: json['longitude'],
      telephone: json['telephone'],
      latitude: json['latitude'],
      isMapVisible: json['map_visible'],
      allowAllNotification: json['notification_all'],
      isNameVisible: json['name_visible'],
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'isDonor': isDonor,
      'firstName': firstName,
      'country': country,
      'lastName': lastName,
      'birthday': birthday,
      'bloodType': bloodType,
      'gender': gender,
      'zone': zone,
    };
  }
}
