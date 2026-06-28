class Restaurant {
  final int id;
  final String name;
  final String description;
  final String? coverImageUrl;
  final double rating;
  final bool isOpen;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    this.coverImageUrl,
    required this.rating,
    required this.isOpen,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      coverImageUrl: json['coverImageUrl'],
      rating: (json['rating'] ?? 0).toDouble(),
      isOpen: json['isOpen'] ?? true,
    );
  }
}
