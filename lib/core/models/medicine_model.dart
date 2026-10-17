import 'package:flutter/material.dart';

class MedicineModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final double price;
  final String unit;
  final String category;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final List<String> benefits;
  int quantity;

  MedicineModel({
    required this.id,
    required this.name,
    required this.description,
    this.icon = Icons.eco_rounded,
    required this.price,
    required this.unit,
    required this.category,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.inStock = true,
    this.benefits = const [],
    this.quantity = 0,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      unit: json['dosage_info'] ?? 'Unit',
      category: json['category'] ?? 'General',
      rating: 4.5,
      reviewCount: 100,
      inStock: (json['stock_quantity'] ?? 0) > 0,
      benefits: [], 
    );
  }

  static List<MedicineModel> get catalog => [
        MedicineModel(
          id: 'm001',
          name: 'Ashwagandha Root',
          description: 'Adaptogenic herb for stress relief and vitality boost',
          icon: Icons.eco_rounded,
          price: 349,
          unit: '60 capsules',
          category: 'Adaptogens',
          rating: 4.8,
          reviewCount: 1240,
          benefits: ['Reduces stress', 'Boosts energy', 'Improves sleep'],
        ),
        MedicineModel(
          id: 'm002',
          name: 'Triphala Churna',
          description: 'Classic tri-fruit blend for digestive health and detox',
          icon: Icons.local_cafe_rounded,
          price: 199,
          unit: '100g powder',
          category: 'Digestive',
          rating: 4.7,
          reviewCount: 2180,
          benefits: [
            'Aids digestion',
            'Detoxification',
            'Rich in antioxidants'
          ],
        ),
        MedicineModel(
          id: 'm003',
          name: 'Brahmi Oil',
          description:
              'Brain tonic and memory enhancer with calming properties',
          icon: Icons.psychology_rounded,
          price: 279,
          unit: '100ml',
          category: 'Neuro Health',
          rating: 4.6,
          reviewCount: 890,
          benefits: ['Enhances memory', 'Reduces anxiety', 'Scalp nourishment'],
        ),
        MedicineModel(
          id: 'm004',
          name: 'Turmeric Latte Mix',
          description:
              'Golden milk blend with turmeric, ginger, and black pepper',
          icon: Icons.wb_sunny_rounded,
          price: 449,
          unit: '200g',
          category: 'Immunity',
          rating: 4.9,
          reviewCount: 3200,
          benefits: ['Anti-inflammatory', 'Immunity boost', 'Joint health'],
        ),
        MedicineModel(
          id: 'm005',
          name: 'Neem Capsules',
          description: 'Purifies blood and supports healthy skin from within',
          icon: Icons.grass_rounded,
          price: 249,
          unit: '60 capsules',
          category: 'Skin Health',
          rating: 4.5,
          reviewCount: 760,
          benefits: ['Blood purifier', 'Anti-bacterial', 'Skin clarity'],
        ),
        MedicineModel(
          id: 'm006',
          name: 'Shatavari Granules',
          description: 'Women\'s wellness tonic for hormonal balance',
          icon: Icons.spa_rounded,
          price: 320,
          unit: '200g granules',
          category: 'Women\'s Health',
          rating: 4.8,
          reviewCount: 1090,
          benefits: [
            'Hormonal balance',
            'Reproductive health',
            'Lactation support'
          ],
        ),
        MedicineModel(
          id: 'm007',
          name: 'Chyawanprash Plus',
          description: 'Premium immunity-boosting jam with 40+ herbs',
          icon: Icons.shield_rounded,
          price: 599,
          unit: '500g',
          category: 'Immunity',
          rating: 4.9,
          reviewCount: 4560,
          benefits: [
            'Strengthens immunity',
            'Anti-aging',
            'Respiratory health'
          ],
        ),
        MedicineModel(
          id: 'm008',
          name: 'Arjuna Heart Care',
          description: 'Supports healthy heart function and circulation',
          icon: Icons.favorite_rounded,
          price: 389,
          unit: '60 tablets',
          category: 'Heart Health',
          rating: 4.7,
          reviewCount: 640,
          benefits: ['Heart strength', 'Blood pressure', 'Cholesterol balance'],
        ),
      ];

  static List<String> get categories => [
        'All',
        'Adaptogens',
        'Digestive',
        'Immunity',
        'Skin Health',
        'Neuro Health',
        'Women\'s Health',
        'Heart Health',
      ];
}
