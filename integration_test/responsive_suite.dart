import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burger_app/app.dart';
import 'package:burger_app/data/local_store.dart';
import 'package:burger_app/state/app_state.dart';

const screens = [
  Routes.welcome,
  Routes.signIn,
  Routes.password,
  Routes.forgot,
  Routes.signUp,
  Routes.phone,
  Routes.verify,
  Routes.notifications,
  Routes.location,
  Routes.home,
  Routes.categories,
  Routes.products,
  Routes.detail,
  Routes.cart,
  Routes.checkout,
  Routes.profile,
  Routes.changePassword,
  Routes.shipping,
  Routes.payment,
  Routes.favorites,
];

void runResponsiveTests() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Poppins')
      ..addFont(rootBundle.load('assets/fonts/Poppins-Regular.ttf'));
    await loader.load();
  });
  for (final size in [const Size(375, 812), const Size(320, 700)]) {
    testWidgets('all screens render without overflow at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final route in screens) {
        SharedPreferences.setMockInitialValues({});
        final state = AppState(await LocalStore.open());
        state.add('aloo');
        state.add('veg');
        await tester.pumpWidget(
          BurgerApp(key: UniqueKey(), state: state, initialRoute: route),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$route at $size');
        await tester.pumpWidget(const SizedBox());
        await state.flushed;
        state.dispose();
      }
    });
  }
  testWidgets('email form validates before navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(await LocalStore.open());
    await tester.pumpWidget(
      BurgerApp(state: state, initialRoute: Routes.signIn),
    );
    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).first,
      'test@example.com',
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your Credentials'), findsOneWidget);
    expect(state.email, 'test@example.com');
    await state.flushed;
  });
  testWidgets('cart navigation clears feedback so checkout stays tappable', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(await LocalStore.open());
    await tester.pumpWidget(
      BurgerApp(state: state, initialRoute: Routes.detail),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add to cart'));
    await tester.pumpAndSettle();
    expect(find.text('Aloo Tikki Burger added to cart'), findsOneWidget);
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    expect(find.text('Aloo Tikki Burger added to cart'), findsNothing);
    await tester.tap(find.text('Check Out'));
    await tester.pumpAndSettle();
    expect(find.text('Check out'), findsOneWidget);
    await state.flushed;
  });
}
