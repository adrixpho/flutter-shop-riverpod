import 'package:dio/dio.dart';
import 'package:teslo_shop/config/const/environment.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/products_mapper.dart';

import '../../domain/domain.dart';

class ProductsDatasourceImp extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImp({required this.accessToken})
      : dio = Dio(BaseOptions(
          baseUrl: Environment.apiURL,
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductsById(String id) {
    // TODO: implement getProductsById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>(
      ProductsEndpoint.list.path,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final List<Product> productResults = [];
    for (final prod in response.data ?? []) {
      final productMapped = ProductMapper.fromJsonToEntity(prod);
      productResults.add(productMapped);
    }

    return productResults;
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    // TODO: implement getProductsByTerm
    throw UnimplementedError();
  }
}
