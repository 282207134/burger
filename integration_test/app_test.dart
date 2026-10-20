import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burger_app/app.dart';
import 'package:burger_app/data/local_store.dart';
import 'package:burger_app/features/onboarding/onboarding_page.dart';
import 'package:burger_app/state/app_state.dart';

import 'responsive_suite.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  runResponsiveTests();
  testWidgets('capture every Pixso screen and complete an order', (
    tester,
  ) async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
      ),
    );
    await binding.convertFlutterSurfaceToImage();
    SharedPreferences.setMockInitialValues({});
    final state = AppState(await LocalStore.open());
    state.add('veg');
    state.add('aloo');
    state.add('zinger');
    final pages = <String, String>{
      '01-welcome-delivery': Routes.welcome,
      '04-sign-in': Routes.signIn,
      '05-password': Routes.password,
      '06-forgot-password': Routes.forgot,
      '07-sign-up': Routes.signUp,
      '08-phone': Routes.phone,
      '09-verification': Routes.verify,
      '10-notifications': Routes.notifications,
      '11-location': Routes.location,
      '12-home': Routes.home,
      '13-categories': Routes.categories,
      '14-products': Routes.products,
      '15-product-detail': Routes.detail,
      '16-cart': Routes.cart,
      '17-checkout': Routes.checkout,
      '18-profile': Routes.profile,
      '19-change-password': Routes.changePassword,
      '20-shipping': Routes.shipping,
      '21-payment': Routes.payment,
    };
    for (final entry in pages.entries) {
      await tester.pumpWidget(
        BurgerApp(key: UniqueKey(), state: state, initialRoute: entry.value),
      );
      if (entry.value == Routes.welcome) {
        final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
        final context = tester.element(find.byType(MaterialApp));
        await Future.wait(
          manifest
              .listAssets()
              .where((path) => path.startsWith('assets/images/'))
              .map((path) => precacheImage(AssetImage(path), context)),
        );
      }
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: entry.key);
      await binding.takeScreenshot(entry.key);
      if (entry.value == Routes.welcome) {
        for (var i = 1; i <= 2; i++) {
          await tester.drag(find.byType(PageView), const Offset(-400, 0));
          await tester.pumpAndSettle();
          await tester.pump(const Duration(milliseconds: 300));
          await binding.takeScreenshot(
            i == 1 ? '02-welcome-customise' : '03-welcome-coming',
          );
        }
        expect(find.byType(OnboardingPage), findsOneWidget);
      }
      if ([
        Routes.detail,
        Routes.checkout,
        Routes.profile,
      ].contains(entry.value)) {
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -600),
        );
        await tester.pumpAndSettle();
        await binding.takeScreenshot('${entry.key}-bottom');
      }
    }
    await tester.pumpWidget(
      BurgerApp(key: UniqueKey(), state: state, initialRoute: Routes.home),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Categories'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Burgers'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aloo Tikki Burger'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save favorite'));
    await tester.pumpAndSettle();
    expect(state.favorites, contains('aloo'));
    final before = state.itemCount;
    await tester.tap(find.byTooltip('Add to cart'));
    await tester.pumpAndSettle();
    expect(state.itemCount, before + 1);
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Increase Aloo Tikki Burger'));
    await tester.pumpAndSettle();
    expect(state.cart['aloo'], 3);
    expect(state.total, 125);
    await tester.tap(find.text('Check Out'));
    await tester.pumpAndSettle();
    expect(find.text('Check out'), findsOneWidget);
    await tester.ensureVisible(find.text('Add New').last);
    await tester.tap(find.text('Add New').last);
    await tester.pumpAndSettle();
    const card = ['4242424242424242', 'Micra Solution', '12/39', '123'];
    for (var i = 0; i < card.length; i++) {
      await tester.enterText(find.byType(TextFormField).at(i), card[i]);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Update Profile'));
    await tester.tap(find.text('Update Profile'));
    await tester.pumpAndSettle();
    expect(state.cardLast4, '4242');
    await tester.ensureVisible(find.text('Mastercard  •••• 4242'));
    await tester.tap(find.text('Mastercard  •••• 4242'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Place Order'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();
    expect(find.text('Your burger is on its way!'), findsOneWidget);
    expect(state.cart, isEmpty);
    await binding.takeScreenshot('22-order-confirmation');
    await tester.tap(find.text('Back to Explore'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('23-empty-cart');
    await state.flushed;
  });
}
