enum AppRoutesPaths { splash, login, register, main }

extension AppRoutesPathsRawValues on AppRoutesPaths {
  String get path {
    switch (this) {
      case AppRoutesPaths.splash:
        return '/splash';
      case AppRoutesPaths.login:
        return '/login';
      case AppRoutesPaths.register:
        return '/register';
      case AppRoutesPaths.main:
        return '/';
      default:
        throw UnimplementedError('AppRoutesPath not implemented ${toString()}');
    }
  }
}
