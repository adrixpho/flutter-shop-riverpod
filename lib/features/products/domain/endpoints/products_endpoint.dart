enum ProductsEndpoint { list }

extension ProductsEndpointRawValues on ProductsEndpoint {
  String get path {
    switch (this) {
      case ProductsEndpoint.list:
        return '/products';

      default:
        throw UnimplementedError(
            'ProductsEndpoint not implemented ${toString()}');
    }
  }
}
