/// Pizza veri modeli — REST API ile uyumlu
class PizzaModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double basePrice;
  final String category;
  final List<String> ingredients;
  final bool isPopular;
  final bool isVegetarian;
  final double rating;
  final int reviewCount;

  PizzaModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.category,
    required this.ingredients,
    this.isPopular = false,
    this.isVegetarian = false,
    this.rating = 4.0,
    this.reviewCount = 0,
  });

  double getPriceBySize(String size) {
    switch (size) {
      case 'Küçük':
        return basePrice;
      case 'Orta':
        return basePrice * 1.3;
      case 'Büyük':
        return basePrice * 1.6;
      case 'Ekstra Büyük':
        return basePrice * 2.0;
      default:
        return basePrice;
    }
  }

  factory PizzaModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return PizzaModel(
      id: docId ?? (map['id'] ?? '').toString(),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? map['image_url'] ?? '',
      basePrice: (map['basePrice'] ?? map['base_price'] ?? 0).toDouble(),
      category: map['category'] ?? 'Klasik',
      ingredients: map['ingredients'] is List
          ? List<String>.from(map['ingredients'])
          : [],
      isPopular: map['isPopular'] == true || map['is_popular'] == true || map['isPopular'] == 1 || map['is_popular'] == 1,
      isVegetarian: map['isVegetarian'] == true || map['is_vegetarian'] == true || map['isVegetarian'] == 1 || map['is_vegetarian'] == 1,
      rating: (map['rating'] ?? 4.0).toDouble(),
      reviewCount: (map['reviewCount'] ?? map['review_count'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'basePrice': basePrice,
      'category': category,
      'ingredients': ingredients,
      'isPopular': isPopular,
      'isVegetarian': isVegetarian,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  @override
  String toString() => 'PizzaModel(id: $id, name: $name, price: $basePrice)';
}
