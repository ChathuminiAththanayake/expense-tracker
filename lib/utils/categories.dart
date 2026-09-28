import 'package:flutter/material.dart';

class ExpenseCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ExpenseCategory(this.name, this.icon, this.color);
}

const List<ExpenseCategory> kCategories = [
  ExpenseCategory('Food', Icons.restaurant, Colors.orange),
  ExpenseCategory('Transport', Icons.directions_bus, Colors.blue),
  ExpenseCategory('Shopping', Icons.shopping_bag, Colors.purple),
  ExpenseCategory('Bills', Icons.receipt_long, Colors.redAccent),
  ExpenseCategory('Entertainment', Icons.movie, Colors.pink),
  ExpenseCategory('Health', Icons.local_hospital, Colors.green),
  ExpenseCategory('Education', Icons.school, Colors.indigo),
  ExpenseCategory('Other', Icons.category, Colors.grey),
];

ExpenseCategory categoryByName(String name) {
  return kCategories.firstWhere(
    (c) => c.name == name,
    orElse: () => kCategories.last,
  );
}
