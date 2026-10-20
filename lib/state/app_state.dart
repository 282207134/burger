import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../data/local_store.dart';

class AppState extends ChangeNotifier {
  final LocalStore store;
  final Map<String, int> _cart = {};
  final Set<String> _favorites = {};
  final Map<String, List<String>> reviews = {};
  String name = 'Micra Solution',
      email = 'hello@micrasolution.com',
      phone = '7069495636';
  String city = 'Surat',
      address = 'Yogi Chowk Ground, Chikuwadi',
      apartment = '201',
      floor = '2';
  String region = 'India +91';
  String? cardLast4, cardHolder, cardExpiry;
  bool notifications = true, locationTracking = true, onboarded = false;
  Future<void> _pending = Future.value();
  AppState(this.store) {
    final data = store.read();
    name = data['name'] as String? ?? name;
    email = data['email'] as String? ?? email;
    phone = data['phone'] as String? ?? phone;
    city = data['city'] as String? ?? city;
    address = data['address'] as String? ?? address;
    apartment = data['apartment'] as String? ?? apartment;
    floor = data['floor'] as String? ?? floor;
    notifications = data['notifications'] as bool? ?? true;
    locationTracking = data['locationTracking'] as bool? ?? true;
    onboarded = data['onboarded'] as bool? ?? false;
    region = data['region'] as String? ?? region;
    cardLast4 = data['cardLast4'] as String?;
    cardHolder = data['cardHolder'] as String?;
    cardExpiry = data['cardExpiry'] as String?;
    final cart = data['cart'];
    if (cart is Map) {
      for (final item in cart.entries) {
        if (products.any((p) => p.id == item.key) &&
            item.value is int &&
            item.value > 0) {
          _cart[item.key as String] = (item.value as int).clamp(1, 99);
        }
      }
    }
    final favorites = data['favorites'];
    if (favorites is List) {
      _favorites.addAll(
        favorites.whereType<String>().where(
          (id) => products.any((p) => p.id == id),
        ),
      );
    }
  }
  Map<String, int> get cart => Map.unmodifiable(_cart);
  Set<String> get favorites => Set.unmodifiable(_favorites);
  int get itemCount => _cart.values.fold(0, (sum, q) => sum + q);
  int get total => _cart.entries.fold(
    0,
    (sum, e) => sum + productById(e.key).price * e.value,
  );
  String get deliveryAddress =>
      '$apartment, $address\n$city${floor.isEmpty ? '' : ' · Floor $floor'}';
  String money(int value) => '\$$value';
  String get formattedPhone => '${region.split(' ').last} $phone';
  void add(String id) {
    productById(id);
    _cart.update(id, (q) => (q + 1).clamp(1, 99), ifAbsent: () => 1);
    save();
  }

  void quantity(String id, int value) {
    if (value <= 0) {
      _cart.remove(id);
    } else {
      productById(id);
      _cart[id] = value.clamp(1, 99);
    }
    save();
  }

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) {
      _favorites.add(id);
    }
    save();
  }

  String placeOrder() {
    if (_cart.isEmpty) {
      throw StateError('Your cart is empty');
    }
    final id =
        'BG${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    _cart.clear();
    save();
    return id;
  }

  void addReview(String id, String text) {
    if (text.trim().isEmpty) {
      return;
    }
    reviews.putIfAbsent(id, () => []).insert(0, text.trim());
    notifyListeners();
  }

  Future<void> get flushed => _pending;
  void save() {
    final snapshot = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'address': address,
      'apartment': apartment,
      'floor': floor,
      'notifications': notifications,
      'locationTracking': locationTracking,
      'onboarded': onboarded,
      'region': region,
      'cardLast4': cardLast4,
      'cardHolder': cardHolder,
      'cardExpiry': cardExpiry,
      'cart': Map.of(_cart),
      'favorites': _favorites.toList(),
    };
    _pending = _pending.then((_) => store.write(snapshot));
    notifyListeners();
  }

  void reset() {
    _cart.clear();
    _favorites.clear();
    reviews.clear();
    name = 'Micra Solution';
    email = 'hello@micrasolution.com';
    phone = '7069495636';
    city = 'Surat';
    address = 'Yogi Chowk Ground, Chikuwadi';
    apartment = '201';
    floor = '2';
    notifications = true;
    locationTracking = true;
    onboarded = false;
    region = 'India +91';
    cardLast4 = null;
    cardHolder = null;
    cardExpiry = null;
    save();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
