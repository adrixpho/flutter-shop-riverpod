import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<List<Product>> getProductsByTerm(String term);
  Future<Product> getProductsById(String id);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
