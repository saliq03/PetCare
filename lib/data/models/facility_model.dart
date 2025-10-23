class Facility {
  final String id;
  final String name;
  final String category;
  final double rating;
  final double price;
  final double distance;
  final bool isOpen;
  final String imageUrl;
  final String description;
  final String location;

  Facility({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.price,
    required this.distance,
    required this.isOpen,
    required this.imageUrl,
    required this.description,
    required this.location,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      rating: json['rating'].toDouble(),
      price: json['price'].toDouble(),
      distance: json['distance'].toDouble(),
      isOpen: json['isOpen'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      location: json['location'],
    );
  }
}