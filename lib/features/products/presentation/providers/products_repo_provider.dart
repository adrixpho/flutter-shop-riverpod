import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/infrastructure/datasources/products_datasource_imp.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_imp.dart';

final productsRepoProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  return ProductsRepositoryImp(ProductsDatasourceImp(accessToken: accessToken));
});
