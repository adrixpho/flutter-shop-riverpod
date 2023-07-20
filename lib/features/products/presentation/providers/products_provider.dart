import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repo_provider.dart';

import '../../domain/entities/product.dart';

//MARK - PROVIDER
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final repository = ref.watch(productsRepoProvider);
  return ProductsNotifier(
    repository: repository,
  );
});

//MARK - Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository repository;
  ProductsNotifier({required this.repository}) : super(ProductsState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;
    state = state.copyWith(
      isLastPage: false,
      isLoading: true,
    );

    final products = await repository.getProductsByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (products.isEmpty) {
      state = state.copyWith(
        isLastPage: true,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}

//MARK - State
class ProductsState {
  final bool isLastPage;
  final bool isLoading;
  final int limit;
  final int offset;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.isLoading = false,
    this.limit = 10,
    this.offset = 0,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? limit,
    int? offset,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        products: products ?? this.products,
      );
}
