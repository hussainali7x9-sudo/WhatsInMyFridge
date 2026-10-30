import 'package:flutter/material.dart';

// ==========================================
// 1. DATA MODELS
// ==========================================

class FridgeItem {
  final String name;
  final String emoji;
  final int days;

  FridgeItem(this.name, this.emoji, this.days);
}

class Recipe {
  final String name;
  final List<String> ingredients;

  Recipe(this.name, this.ingredients);
}

// ==========================================
// 2. GLOBAL VARIABLES (App State)
// ==========================================

// Fridge items ki list (ValueNotifier taake UI auto-update ho)
final ValueNotifier<List<FridgeItem>> fridge = ValueNotifier([
  FridgeItem('Milk', '🥛', 2),
  FridgeItem('Spinach', '🥬', 3),
  FridgeItem('Tomatoes', '🍅', 4),
  FridgeItem('Cheese', '🧀', 10),
  FridgeItem('Apples', '🍎', 7),
  FridgeItem('Bananas', '🍌', 1),
]);

// Recipes ki list
final List<Recipe> recipes = [
  Recipe('Spinach Omelette', ['Spinach', 'Eggs', 'Cheese']),
  Recipe('Tomato Cheese Toast', ['Tomatoes', 'Cheese', 'Bread']),
  Recipe('Milk Pancakes', ['Milk', 'Flour', 'Eggs']),
  Recipe('Banana Smoothie', ['Bananas', 'Milk', 'Honey']),
  Recipe('Apple Cinnamon Oatmeal', ['Apples', 'Oats', 'Milk']),
];

// Expiring soon ki limit (din mein)
int expiringDays = 4;

// ==========================================
// 3. HELPER FUNCTIONS
// ==========================================

String daysLabel(int days) {
  if (days == 0) return 'Expires today';
  if (days == 1) return 'Expires in 1 day';
  return 'Expires in $days days';
}