// lib/product_model.dart
class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  List likedBy;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.likedBy = const [],
  });
  // Product copyWith({
  //   String? id,
  //   String? name,
  //   String? description,
  //   String? imageUrl,
  //   double? price,
  //   bool? isLiked,
  // }) {
  //   return Product(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     description: description ?? this.description,
  //     imageUrl: imageUrl ?? this.imageUrl,
  //     price: price ?? this.price,
  //     isLiked: isLiked ?? this.isLiked,
  //   );
  // }
}