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
  final List<String> services;
  final String address;
  final String phone;
  final String hours;

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
    required this.services,
    required this.address,
    required this.phone,
    required this.hours,
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
      services: List<String>.from(json['services']),
      address: json['address'],
      phone: json['phone'],
      hours: json['hours'],
    );
  }

  String get priceRange => 'From ₹$price';

  String get distanceText => '${distance}km away';

  String get ratingText => rating.toStringAsFixed(1);
}