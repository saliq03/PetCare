import '../models/facility_model.dart';

class DummyData {
  static List<Facility> get facilities => [
    Facility(
      id: '1',
      name: 'Paws & Claws Vet Clinic',
      category: 'Vet',
      rating: 4.5,
      price: 500,
      distance: 1.2,
      isOpen: true,
      imageUrl: 'https://picsum.photos/300/200?random=1',
      description: 'Comprehensive veterinary care for your pets with experienced doctors and modern equipment.',
      location: 'Hyderabad',
    ),
    Facility(
      id: '2',
      name: 'Grooming Paradise',
      category: 'Grooming',
      rating: 4.2,
      price: 800,
      distance: 2.5,
      isOpen: true,
      imageUrl: 'https://picsum.photos/300/200?random=2',
      description: 'Professional grooming services to keep your pet looking their best.',
      location: 'Hyderabad',
    ),
    Facility(
      id: '3',
      name: 'Happy Tails Boarding',
      category: 'Boarding',
      rating: 4.7,
      price: 1200,
      distance: 3.1,
      isOpen: false,
      imageUrl: 'https://picsum.photos/300/200?random=3',
      description: 'Safe and comfortable boarding facility with 24/7 supervision.',
      location: 'Bengaluru',
    ),
    // Add more dummy facilities...
  ];
}