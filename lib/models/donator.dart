class Donator {
  final String username;
  final String bloodType;
  final int age;
  final String country;
  final String telephone;
  final String email;
  final String zone; // Optional field for image URL
  final String name; // Optional field for image URL
  final String? description;
  final double longitude;
  final double latitude;
  final bool isEmergency;

  Donator(
      {required this.username,
      required this.bloodType,
      required this.age,
      required this.country,
      required this.telephone,
      required this.email,
      required this.zone,
      required this.name,
      required this.longitude,
      required this.latitude,
      required this.isEmergency,
      this.description});

  // Factory method to create a Donator object from JSON
  factory Donator.fromJson(Map<String, dynamic> json) {
    return Donator(
      name: json['name_visible'] == true
          ? json['firstname'] + json['lastname']
          : json['username'], // Optional field for image URL
      zone: 'tripoli',
      username: json['username'] ?? '',
      bloodType: json['blood_type'] ?? '',
      age: json['age'] ?? 0,
      country: '',
      telephone: json['telephone'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      longitude: 0.0,
      latitude: 0.0,
      isEmergency: json['type'] == "emergency" ? true : false,
    );
  }

  // Method to convert a Donator object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'blood_type': bloodType,
      'age': age,
      'country': country,
      'telephone': telephone,
      'email': email,
      'zone': zone,
    };
  }
}
