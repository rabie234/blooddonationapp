class Zone {
  final String city;
  final String country;

  Zone({required this.city, required this.country});

  // Factory method to create a Zone object from JSON
  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      // Default to an empty string if id is null
      city: json['city'] ?? '', // Default to an empty string if name is null
      country:
          json['country'] ?? '', // Default to an empty string if name is null
    );
  }

  // Method to convert a Zone object to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'zone_id': id,
  //     'name': name,
  //   };
  // }
}
