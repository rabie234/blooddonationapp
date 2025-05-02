class Zone {
  final String id;
  final String name;

  Zone({required this.id, required this.name});

  // Factory method to create a Zone object from JSON
  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['zone_id'] ?? '', // Default to an empty string if id is null
      name: json['name'] ?? '', // Default to an empty string if name is null
    );
  }

  // Method to convert a Zone object to JSON
  Map<String, dynamic> toJson() {
    return {
      'zone_id': id,
      'name': name,
    };
  }
}
