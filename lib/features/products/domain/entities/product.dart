// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import '../../../auth/domain/entities/user.dart';

class Product {
  String id;
  String title;
  double price;
  String description;
  String slug;
  int stock;
  List<String> sizes;
  String gender;
  List<String> tags;
  List<String> images;
  User user;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.slug,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
    required this.user,
  });

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? description,
    String? slug,
    int? stock,
    List<String>? sizes,
    String? gender,
    List<String>? tags,
    List<String>? images,
    User? user,
  }) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        price: price ?? this.price,
        description: description ?? this.description,
        slug: slug ?? this.slug,
        stock: stock ?? this.stock,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        tags: tags ?? this.tags,
        images: images ?? this.images,
        user: user ?? this.user,
      );
}
