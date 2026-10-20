import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routes.dart';
import '../data/catalog.dart';
import '../state/app_state.dart';
import 'theme.dart';

void message(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

void go(
  BuildContext context,
  String route, {
  Object? arguments,
  bool root = false,
}) {
  ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  if (root) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (_) => false, arguments: arguments);
  } else {
    Navigator.of(context).pushNamed(route, arguments: arguments);
  }
}

void back(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    go(context, Routes.home, root: true);
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton(this.label, {super.key, this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      child: Text(label, textAlign: TextAlign.center),
    ),
  );
}

class FoodImage extends StatelessWidget {
  final String name;
  final double? width, height;
  final BoxFit fit;
  const FoodImage(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: width,
    height: height,
    fit: fit,
    gaplessPlayback: true,
    errorBuilder: (_, _, _) => SizedBox(
      width: width,
      height: height,
      child: const Icon(CupertinoIcons.photo, color: Brand.yellow),
    ),
  );
}

class PageHeader extends StatelessWidget {
  final String title;
  final bool darkText, actions;
  final Widget? trailing;
  const PageHeader(
    this.title, {
    super.key,
    this.darkText = false,
    this.actions = true,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    final color = darkText ? Colors.black : Brand.yellow;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ?trailing,
          if (actions) ...[
            IconButton(
              tooltip: 'Favorites',
              onPressed: () => go(context, Routes.favorites),
              icon: Icon(CupertinoIcons.heart, color: color, size: 23),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => go(context, Routes.notifications),
              icon: Icon(CupertinoIcons.bell, color: color, size: 21),
            ),
          ],
        ],
      ),
    );
  }
}

class ShopScaffold extends StatelessWidget {
  final Widget body;
  final int selected;
  const ShopScaffold({super.key, required this.body, required this.selected});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: body,
    bottomNavigationBar: BottomBar(selected: selected),
  );
}

class BottomBar extends StatelessWidget {
  final int selected;
  const BottomBar({super.key, required this.selected});
  @override
  Widget build(BuildContext context) {
    final count = AppScope.of(context).itemCount;
    const icons = [
      CupertinoIcons.house,
      CupertinoIcons.square_grid_2x2,
      CupertinoIcons.cart,
      CupertinoIcons.person,
    ];
    const labels = ['Home', 'Categories', 'Cart', 'Profile'];
    const routes = [
      Routes.home,
      Routes.categories,
      Routes.cart,
      Routes.profile,
    ];
    return ColoredBox(
      color: Brand.yellow,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (i) => Semantics(
                selected: selected == i,
                button: true,
                label: labels[i],
                child: IconButton(
                  tooltip: labels[i],
                  onPressed: () {
                    if (i != selected) {
                      go(context, routes[i], root: true);
                    }
                  },
                  icon: Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? Colors.black : Colors.transparent,
                      borderRadius: Brand.radius,
                    ),
                    child: Badge(
                      isLabelVisible: i == 2 && count > 0,
                      label: Text('$count'),
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      child: Icon(
                        icons[i],
                        size: 25,
                        color: i == selected ? Brand.yellow : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartCircle extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  const CartCircle({super.key, required this.onPressed, this.size = 49});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
      border: Border.all(color: Brand.yellow.withValues(alpha: .3)),
      boxShadow: [
        BoxShadow(color: Brand.yellow.withValues(alpha: .12), blurRadius: 6),
      ],
    ),
    child: IconButton(
      tooltip: 'Add to cart',
      onPressed: onPressed,
      icon: Icon(CupertinoIcons.cart, color: Brand.yellow, size: size * .5),
    ),
  );
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return SizedBox(
      height: 230,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 29,
            left: 0,
            right: 0,
            bottom: 15,
            child: Material(
              color: Brand.yellow,
              borderRadius: Brand.radius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => go(context, Routes.detail, arguments: product),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 88, 10, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 9,
                          height: 1.4,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.money(product.price),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: -8,
            left: 25,
            height: 115,
            child: GestureDetector(
              onTap: () => go(context, Routes.detail, arguments: product),
              child: FoodImage(product.image),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -4,
            child: CartCircle(
              onPressed: () {
                state.add(product.id);
                message(context, '${product.name} added to cart');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title, description;
  final IconData icon;
  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon = CupertinoIcons.cart,
  });
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Brand.yellow),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 20, color: Brand.yellow),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Brand.muted),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            'Explore the menu',
            onPressed: () => go(context, Routes.categories, root: true),
          ),
        ],
      ),
    ),
  );
}
