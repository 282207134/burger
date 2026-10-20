import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';
import '../../state/app_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return ShopScaffold(
      selected: 2,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PageHeader('Your Cart'),
            Expanded(
              child: state.cart.isEmpty
                  ? const EmptyState(
                      title: 'A little hungry?',
                      description:
                          'Your cart is empty. Let’s find something delicious.',
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      children: [
                        for (final item in state.cart.entries)
                          CartItem(
                            product: productById(item.key),
                            quantity: item.value,
                          ),
                      ],
                    ),
            ),
            if (state.cart.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 12, 32, 28),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${state.itemCount} items',
                          style: const TextStyle(color: Brand.muted),
                        ),
                        const Spacer(),
                        Text(
                          state.money(state.total),
                          style: const TextStyle(
                            color: Brand.yellow,
                            fontSize: 23,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      'Check Out',
                      onPressed: () => go(context, Routes.checkout),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final Product product;
  final int quantity;
  const CartItem({super.key, required this.product, required this.quantity});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: SizedBox(
        height: 135,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 26,
              right: 0,
              top: 8,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Brand.yellow,
                  borderRadius: Brand.radius,
                ),
                padding: const EdgeInsets.fromLTRB(99, 16, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'By Navjivan Hotel',
                      style: TextStyle(color: Colors.black87, fontSize: 9),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          state.money(product.price * quantity),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        quantityButton(
                          context,
                          CupertinoIcons.minus,
                          quantity - 1,
                          'Decrease ${product.name}',
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        quantityButton(
                          context,
                          CupertinoIcons.plus,
                          quantity + 1,
                          'Increase ${product.name}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -5,
              left: -8,
              width: 140,
              height: 125,
              child: GestureDetector(
                onTap: () => go(context, Routes.detail, arguments: product),
                child: FoodImage(product.image),
              ),
            ),
            Positioned(
              right: -3,
              top: 3,
              child: IconButton(
                tooltip: 'Remove ${product.name}',
                onPressed: () => state.quantity(product.id, 0),
                icon: const Icon(
                  CupertinoIcons.xmark,
                  color: Colors.black,
                  size: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantityButton(
    BuildContext context,
    IconData icon,
    int value,
    String label,
  ) => SizedBox(
    width: 32,
    height: 36,
    child: IconButton(
      tooltip: label,
      padding: EdgeInsets.zero,
      onPressed: () => AppScope.of(context).quantity(product.id, value),
      icon: Icon(icon, color: Colors.black, size: 13),
    ),
  );
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool cash = true, ordering = false;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: state.cart.isEmpty
            ? const EmptyState(
                title: 'Your cart is empty',
                description: 'Add your favourites to start an order.',
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PageHeader('Check out'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Column(
                        children: [
                          for (final item in state.cart.entries)
                            CartItem(
                              product: productById(item.key),
                              quantity: item.value,
                            ),
                        ],
                      ),
                    ),
                    section(
                      'Shipping Address',
                      () => go(context, Routes.shipping),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: Brand.radius,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.deliveryAddress,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  height: 1.7,
                                ),
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Brand.yellow,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    section(
                      'Payment Method',
                      () => go(context, Routes.payment),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          paymentOption(
                            'Cash on delivery',
                            CupertinoIcons.money_dollar_circle,
                            cash,
                            () => setState(() => cash = true),
                          ),
                          if (state.cardLast4 != null) ...[
                            const SizedBox(height: 10),
                            paymentOption(
                              'Mastercard  •••• ${state.cardLast4}',
                              CupertinoIcons.creditcard,
                              !cash,
                              () => setState(() => cash = false),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 26, 24, 12),
                      child: Column(
                        children: [
                          for (final item in state.cart.entries)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${productById(item.key).name} × ${item.value}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Text(
                                    state.money(
                                      productById(item.key).price * item.value,
                                    ),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(color: Color(0xFF493600)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    color: Brand.yellow,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                state.money(state.total),
                                style: const TextStyle(
                                  color: Brand.yellow,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 24),
                      child: PrimaryButton(
                        ordering ? 'Placing order…' : 'Place Order',
                        onPressed: ordering ? null : () => placeOrder(state),
                      ),
                    ),
                    TextButton(
                      onPressed: () => back(context),
                      child: const Text('Back to cart'),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
      ),
    );
  }

  Widget section(String title, VoidCallback onAdd) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 14, 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Brand.yellow, fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: onAdd,
          child: const Text(
            'Add New',
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ],
    ),
  );
  Widget paymentOption(
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) => Material(
    color: selected ? Brand.yellow : Colors.white,
    borderRadius: Brand.radius,
    child: InkWell(
      onTap: onTap,
      borderRadius: Brand.radius,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            Icon(
              selected
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    ),
  );
  Future<void> placeOrder(AppState state) async {
    if (state.cart.isEmpty) {
      return;
    }
    if (state.address.trim().isEmpty || state.city.trim().isEmpty) {
      go(context, Routes.shipping);
      return;
    }
    setState(() => ordering = true);
    final total = state.total;
    final order = state.placeOrder();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Brand.panel,
        icon: const Icon(
          CupertinoIcons.check_mark_circled,
          size: 60,
          color: Brand.yellow,
        ),
        title: const Text(
          'Your burger is on its way!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21),
        ),
        content: Text(
          'Demo order $order\n${state.money(total)} · 30–45 min\n\nThis is a local demo. No payment was taken.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, height: 1.8),
        ),
        actions: [
          PrimaryButton(
            'Back to Explore',
            onPressed: () {
              Navigator.pop(context);
              go(this.context, Routes.home, root: true);
            },
          ),
        ],
      ),
    );
  }
}
