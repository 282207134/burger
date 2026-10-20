import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burger_app/core/validators.dart';
import 'package:burger_app/data/local_store.dart';
import 'package:burger_app/state/app_state.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('cart totals, deletion and quantity bounds remain consistent', () async {
    final state = AppState(await LocalStore.open());
    state.add('aloo');
    state.add('aloo');
    state.add('veg');
    expect(state.itemCount, 3);
    expect(state.total, 75);
    state.quantity('aloo', 1000);
    expect(state.cart['aloo'], 99);
    state.quantity('veg', 0);
    expect(state.cart.containsKey('veg'), false);
    state.quantity('aloo', -1);
    expect(state.total, 0);
    expect(() => state.placeOrder(), throwsStateError);
    await state.flushed;
  });
  test('rapid edits persist the newest complete state', () async {
    final store = await LocalStore.open();
    final state = AppState(store);
    state.add('aloo');
    state.add('veg');
    state.quantity('aloo', 3);
    state.toggleFavorite('zinger');
    state.city = 'Tokyo';
    state.notifications = false;
    state.save();
    await state.flushed;
    final restored = AppState(store);
    expect(restored.cart, {'aloo': 3, 'veg': 1});
    expect(restored.total, 100);
    expect(restored.favorites, {'zinger'});
    expect(restored.city, 'Tokyo');
    expect(restored.notifications, false);
    expect(store.read().keys, isNot(contains('password')));
    expect(store.read().keys, isNot(contains('cardNumber')));
    expect(store.read().keys, isNot(contains('cvc')));
  });
  test(
    'placing an order clears cart while retaining address and favorites',
    () async {
      final state = AppState(await LocalStore.open());
      state.add('veg');
      state.toggleFavorite('veg');
      expect(state.placeOrder(), startsWith('BG'));
      expect(state.cart, isEmpty);
      expect(state.favorites, {'veg'});
      expect(state.address, isNotEmpty);
      await state.flushed;
    },
  );
  test('corrupt and removed catalog data does not break startup', () async {
    SharedPreferences.setMockInitialValues({'burger.v1': 'not json'});
    expect(AppState(await LocalStore.open()).cart, isEmpty);
    SharedPreferences.setMockInitialValues({
      'burger.v1': '{"cart":{"removed":3,"veg":-1,"aloo":2},"favorites":["removed","veg"]}',
    });
    final state = AppState(await LocalStore.open());
    expect(state.cart, {'aloo': 2});
    expect(state.favorites, {'veg'});
  });
  test(
    'forms reject invalid email, phone, card checksum and expired cards',
    () {
      expect(Validate.email('bad@'), isNotNull);
      expect(Validate.email('a@example.com'), isNull);
      expect(Validate.phone('123'), isNotNull);
      expect(Validate.phone('+81 90 1234 5678'), isNull);
      expect(Validate.password('123'), isNotNull);
      expect(Validate.card('4242424242424242'), isNull);
      expect(Validate.card('4242424242424243'), isNotNull);
      expect(Validate.expiry('13/30'), isNotNull);
      expect(Validate.expiry('01/20'), isNotNull);
      expect(Validate.expiry('12/39'), isNull);
    },
  );
}
