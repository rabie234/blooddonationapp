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
  final bool mapVisible;
  final String? timeAgo;

  Donator(
      {required this.username,
      required this.bloodType,
      required this.age,
      required this.country,
      required this.telephone,
      required this.mapVisible,
      required this.email,
      required this.zone,
      required this.name,
      required this.longitude,
      required this.latitude,
      required this.isEmergency,
      this.description,
      this.timeAgo});

  // Factory method to create a Donator object from JSON
  factory Donator.fromJson(Map<String, dynamic> json) {
    return Donator(
      name: json['name_visible'] == true
          ? json['firstname'] + " " + json['lastname']
          : json['username'], // Optional field for image URL
      zone: json['address']['zone_name'] ?? '',
      username: json['username'] ?? '',
      bloodType: json['blood_type'] ?? '',
      mapVisible: json['map_visible'] ?? false,
      age: json['age'] ?? 0,
      country: json['address']['country_name'] ?? '',
      telephone: json['telephone'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      longitude: json['address']['longitude'] ?? 0.0,
      latitude: json['address']['latitude'] ?? 0.0,
      isEmergency: json['type'] == "emergency" ? true : false,
      timeAgo: json['timeAgo'] ?? '',
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
