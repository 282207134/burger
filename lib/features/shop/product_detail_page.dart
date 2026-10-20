import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';
import '../../state/app_state.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final review = TextEditingController();
  @override
  void dispose() {
    review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final state = AppScope.of(context);
    final saved = state.favorites.contains(p.id);
    final reviews = state.reviews[p.id] ?? [];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => back(context),
                    icon: const Icon(
                      CupertinoIcons.chevron_left,
                      size: 20,
                      color: Brand.yellow,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p.category,
                      style: const TextStyle(color: Brand.yellow, fontSize: 22),
                    ),
                  ),
                  IconButton(
                    tooltip: saved ? 'Remove favorite' : 'Save favorite',
                    onPressed: () => state.toggleFavorite(p.id),
                    icon: Icon(
                      saved ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: Brand.yellow,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Open cart',
                    onPressed: () => go(context, Routes.cart),
                    icon: const Icon(CupertinoIcons.cart, color: Brand.yellow),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
                child: SizedBox(
                  height: 392,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 8,
                        bottom: 18,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Brand.yellow,
                            borderRadius: Brand.radius,
                          ),
                          padding: const EdgeInsets.fromLTRB(18, 164, 18, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.description,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                state.money(p.price),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 35,
                        right: -12,
                        height: 235,
                        child: FoodImage(p.image),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -4,
                        child: CartCircle(
                          size: 76,
                          onPressed: () {
                            state.add(p.id);
                            message(context, '${p.name} added to cart');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(22, 5, 22, 10),
                child: Text(
                  'Reviews',
                  style: TextStyle(fontSize: 16, color: Brand.yellow),
                ),
              ),
              for (final text in reviews) reviewRow(state.name, text, 'avatar'),
              reviewRow(
                'Micra Solution',
                'Fresh, full of flavour. A new favourite!',
                'review_1',
              ),
              reviewRow(
                'Jenny Wilson',
                'The perfect bite. Will order again.',
                'review_2',
              ),
              reviewRow(
                'Albert Flores',
                'Arrived warm and tasted delicious.',
                'review_3',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
                child: TextField(
                  controller: review,
                  maxLines: 3,
                  maxLength: 300,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Write your review…',
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Brand.yellow),
                    ),
                    counterStyle: const TextStyle(color: Brand.muted),
                    suffixIcon: const Icon(
                      CupertinoIcons.smiley,
                      color: Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(55, 0, 55, 28),
                child: PrimaryButton(
                  'Save Review',
                  onPressed: () {
                    if (review.text.trim().isEmpty) {
                      message(context, 'Write a review first');
                      return;
                    }
                    state.addReview(p.id, review.text);
                    review.clear();
                    FocusScope.of(context).unfocus();
                    message(context, 'Thanks for your review!');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewRow(String name, String text, String image) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFF29220C))),
    ),
    child: Row(
      children: [
        ClipOval(
          child: FoodImage(image, width: 48, height: 48, fit: BoxFit.cover),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(color: Brand.yellow, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(fontSize: 11, color: Brand.muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(CupertinoIcons.star_fill, size: 12, color: Brand.yellow),
      ],
    ),
  );
}
