import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import '../../../../config/const/environment.dart';

class ProductMapper {
  static Product fromJsonToEntity(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'],
        price: double.parse(json['price']),
        description: json['description'],
        slug: json['slug'],
        stock: int.parse(json['stock']),
        sizes: List.from(json['sizes'].map((item) => item)),
        gender: json['gender'],
        tags: List.from(json['tags'].map((item) => item)),
        images: List.from(
          json['images'].map((String image) => image.startsWith('http')
              ? image
              : '${Environment.apiURL}/files/product/$image'),
        ),
        user: UserMapper.userJsonToEntity(json['user']),
      );
}
