import 'package:flutter/material.dart';

import 'core/routes.dart';
import 'core/theme.dart';
import 'data/catalog.dart';
import 'features/account/account_pages.dart';
import 'features/auth/auth_page.dart';
import 'features/cart/cart_pages.dart';
import 'features/location/location_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/shop/product_detail_page.dart';
import 'features/shop/shop_pages.dart';
import 'state/app_state.dart';

export 'core/routes.dart';

class BurgerApp extends StatelessWidget {
  final AppState state;
  final String? initialRoute;
  const BurgerApp({super.key, required this.state, this.initialRoute});
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: MaterialApp(
      title: 'Burger',
      debugShowCheckedModeBanner: false,
      theme: Brand.theme,
      initialRoute:
          initialRoute ?? (state.onboarded ? Routes.home : Routes.welcome),
      onGenerateInitialRoutes: (route) => [_route(RouteSettings(name: route))],
      onGenerateRoute: _route,
      builder: (context, child) => ColoredBox(
        color: const Color(0xFF111111),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: child!,
          ),
        ),
      ),
    ),
  );
  Route<dynamic> _route(RouteSettings settings) {
    final screen = switch (settings.name) {
      Routes.welcome => OnboardingPage(
        initialPage: settings.arguments as int? ?? 0,
      ),
      Routes.signIn ||
      Routes.password ||
      Routes.forgot ||
      Routes.signUp ||
      Routes.phone ||
      Routes.verify ||
      Routes.notifications => AuthPage(mode: settings.name!),
      Routes.location => const LocationPage(),
      Routes.home => const HomePage(),
      Routes.categories => const CategoriesPage(),
      Routes.products => ProductsPage(
        category: settings.arguments as String? ?? 'Burgers',
      ),
      Routes.detail => ProductDetailPage(
        product: settings.arguments as Product? ?? productById('aloo'),
      ),
      Routes.cart => const CartPage(),
      Routes.checkout => const CheckoutPage(),
      Routes.profile => const ProfilePage(),
      Routes.changePassword ||
      Routes.shipping ||
      Routes.payment => AccountFormPage(mode: settings.name!),
      Routes.favorites => const ProductsPage(favoritesOnly: true),
      _ => const HomePage(),
    };
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}
