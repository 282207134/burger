import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';
import '../../state/app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => ShopScaffold(
    selected: 0,
    body: LayoutBuilder(
      builder: (context, bounds) {
        final heroHeight = (bounds.maxHeight * .53).clamp(310.0, 460.0);
        return SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight + 28,
                child: const FoodImage('welcome_2', fit: BoxFit.cover),
              ),
              Column(
                children: [
                  SizedBox(
                    height: heroHeight,
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const PageHeader('Explore', darkText: true),
                          const Padding(
                            padding: EdgeInsets.only(left: 22),
                            child: Text(
                              'What would you like to eat?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 28),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Popular Today',
                                style: TextStyle(
                                  color: Brand.yellow,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => go(context, Routes.products),
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: ProductCard(productById('aloo'))),
                            const SizedBox(width: 22),
                            Expanded(child: ProductCard(productById('fries'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context) => ShopScaffold(
    selected: 1,
    body: SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: PageHeader('Category')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 185,
                mainAxisSpacing: 10,
                crossAxisSpacing: 22,
              ),
              delegate: SliverChildBuilderDelegate((context, i) {
                final category = categories[i];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 27,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Material(
                        color: Brand.yellow,
                        borderRadius: Brand.radius,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => go(
                            context,
                            Routes.products,
                            arguments: category.name,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 8, 25),
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 24,
                      right: -8,
                      height: 125,
                      child: GestureDetector(
                        onTap: () => go(
                          context,
                          Routes.products,
                          arguments: category.name,
                        ),
                        child: FoodImage(category.image),
                      ),
                    ),
                  ],
                );
              }, childCount: categories.length),
            ),
          ),
        ],
      ),
    ),
  );
}

class ProductsPage extends StatelessWidget {
  final String category;
  final bool favoritesOnly;
  const ProductsPage({
    super.key,
    this.category = 'Burgers',
    this.favoritesOnly = false,
  });
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final items = products
        .where(
          (p) => favoritesOnly
              ? state.favorites.contains(p.id)
              : p.category == category,
        )
        .toList();
    return ShopScaffold(
      selected: 1,
      body: items.isEmpty
          ? const SafeArea(
              child: EmptyState(
                title: 'Your favourites live here',
                description: 'Tap the heart on a burger to keep it close.',
                icon: CupertinoIcons.heart,
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: favoritesOnly ? 110 : 245,
                    child: Stack(
                      children: [
                        if (!favoritesOnly)
                          const Positioned.fill(
                            child: FoodImage('welcome_1', fit: BoxFit.cover),
                          ),
                        SafeArea(
                          bottom: false,
                          child: PageHeader(
                            favoritesOnly ? 'Favorites' : category,
                            darkText: !favoritesOnly,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 230,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 22,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => ProductCard(items[i]),
                      childCount: items.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
