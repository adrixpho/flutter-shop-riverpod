import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImp extends ProductsRepository {
  final ProductsDatasource datasource;

  ProductsRepositoryImp(this.datasource);
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) =>
      datasource.createUpdateProduct(productLike);

  @override
  Future<Product> getProductsById(String id) => datasource.getProductsById(id);

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) =>
      datasource.getProductsByPage(limit: limit, offset: offset);

  @override
  Future<List<Product>> getProductsByTerm(String term) =>
      datasource.getProductsByTerm(term);
}
