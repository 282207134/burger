import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class OnboardingPage extends StatefulWidget {
  final int initialPage;
  const OnboardingPage({super.key, this.initialPage = 0});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController controller = PageController(
    initialPage: widget.initialPage,
  );
  late int index = widget.initialPage;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: LayoutBuilder(
      builder: (context, bounds) {
        const titles = [
          'Delivery Address',
          'Customised Burger',
          'Your Burger is Coming!',
        ];
        const descriptions = [
          'Start your order by typing\nyour address.',
          'Make it yours with fresh ingredients\nand your favourite flavours.',
          'Submit your order and sit back.\nYour next great bite is on its way.',
        ];
        return Column(
          children: [
            Expanded(
              flex: 64,
              child: PageView.builder(
                controller: controller,
                itemCount: 3,
                onPageChanged: (value) => setState(() => index = value),
                itemBuilder: (_, i) => SizedBox.expand(
                  child: FoodImage('welcome_${i + 1}', fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(
              height:
                  (bounds.maxHeight * .36).clamp(306.0, 360.0) +
                  MediaQuery.paddingOf(context).bottom,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 22, 32, 6),
                  child: Column(
                    children: [
                      Text(
                        titles[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        descriptions[index],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD0D0D0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (i) => GestureDetector(
                            onTap: () => controller.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            ),
                            child: Semantics(
                              label: 'Welcome page ${i + 1}',
                              selected: i == index,
                              button: true,
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Container(
                                  width: i == index ? 20 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: i == index
                                        ? Brand.yellow
                                        : const Color(0xFF555555),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        'Set Delivery Location',
                        onPressed: () => go(context, Routes.location),
                      ),
                      const SizedBox(height: 7),
                      TextButton(
                        onPressed: () => go(context, Routes.signIn),
                        child: const Text.rich(
                          TextSpan(
                            text: 'Have an account? ',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                            children: [
                              TextSpan(
                                text: 'LOGIN',
                                style: TextStyle(
                                  color: Brand.yellow,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
