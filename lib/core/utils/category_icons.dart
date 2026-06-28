import 'package:flutter/material.dart';

class CategoryIcons {
  CategoryIcons._();

  static IconData fromName(String name) {
    return switch (name) {
      'burger' => Icons.lunch_dining,
      'cup' => Icons.local_drink,
      'french_fries' => Icons.fastfood_outlined,
      'ice_cream' => Icons.icecream_outlined,
      'plus' => Icons.add_circle_outline,
      'pizza' => Icons.local_pizza_outlined,
      'salad' => Icons.eco_outlined,
      'coffee' => Icons.coffee_outlined,
      'cake' => Icons.cake_outlined,
      'sandwich' => Icons.breakfast_dining_outlined,
      'local_drink' => Icons.emoji_food_beverage_outlined,
      _ => Icons.restaurant_outlined,
    };
  }
}
