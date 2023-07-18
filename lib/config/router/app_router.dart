import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/config/router/app_routes_keys.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:teslo_shop/features/products/products.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutesPaths.splash.path,
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      ///
      GoRoute(
        path: AppRoutesPaths.splash.path,
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: AppRoutesPaths.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutesPaths.register.path,
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: AppRoutesPaths.main.path,
        builder: (context, state) => const ProductsScreen(),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;
      final loginRoutes = [
        AppRoutesPaths.login.path,
        AppRoutesPaths.register.path,
      ];

      if (authStatus == AuthStatus.authenticated &&
          (loginRoutes.contains(isGoingTo) ||
              isGoingTo == AppRoutesPaths.splash.path)) {
        return AppRoutesPaths.main.path;
      }

      if (authStatus == AuthStatus.notAuthenticated &&
          !loginRoutes.contains(isGoingTo)) {
        return AppRoutesPaths.login.path;
      }

      if (isGoingTo == AppRoutesPaths.splash.path &&
          authStatus == AuthStatus.checking) return null;

      return null;
    },
  );
});
