class Product {
  final String id, name, image, category, description;
  final int price;
  const Product(
    this.id,
    this.name,
    this.image,
    this.category,
    this.description, {
    this.price = 25,
  });
}

class FoodCategory {
  final String name, image;
  const FoodCategory(this.name, this.image);
}

const categories = [
  FoodCategory('Burgers', 'aloo'),
  FoodCategory('Meals', 'meal'),
  FoodCategory('Rice Bowls', 'rice'),
  FoodCategory('Beverages', 'drink'),
  FoodCategory('Sides', 'fries'),
  FoodCategory('Desserts', 'dessert'),
];
const products = [
  Product(
    'veg',
    'Veg Burger',
    'veg',
    'Burgers',
    'A golden veggie patty, crisp lettuce and our signature sauce.',
  ),
  Product(
    'aloo',
    'Aloo Tikki Burger',
    'aloo',
    'Burgers',
    'Spiced potato patty, fresh greens and a soft sesame bun.',
  ),
  Product(
    'zinger',
    'Zinger Burger',
    'zinger',
    'Burgers',
    'Crispy chicken with a little heat and plenty of crunch.',
  ),
  Product(
    'chicken',
    'Chicken Burger',
    'chicken',
    'Burgers',
    'Tender chicken, red onion and creamy house dressing.',
  ),
  Product(
    'fries',
    'French Fries',
    'fries',
    'Sides',
    'Golden, lightly salted fries. A perfect side to your burger.',
  ),
  Product(
    'strips',
    'Chicken Strips',
    'sides',
    'Sides',
    'Crisp chicken strips, freshly cooked and ready to dip.',
  ),
  Product(
    'meal',
    'Burger Meal',
    'meal',
    'Meals',
    'Your favourite burger, served with a generous side.',
  ),
  Product(
    'rice',
    'Rice Bowl',
    'rice',
    'Rice Bowls',
    'A comforting bowl of rice with delicious savoury toppings.',
  ),
  Product(
    'drink',
    'Iced Cola',
    'drink',
    'Beverages',
    'Ice cold cola to refresh your day.',
  ),
  Product(
    'dessert',
    'Strawberry Sundae',
    'dessert',
    'Desserts',
    'Creamy soft serve with a swirl of strawberry.',
  ),
];
Product productById(String id) => products.firstWhere((p) => p.id == id);
