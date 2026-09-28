import 'dart:async';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

/// Central state holder for expenses: subscribes to the Firestore stream,
/// exposes loading/error state, and applies category/date/search filters
/// without re-querying Firestore each time.
class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _service;
  StreamSubscription<List<Expense>>? _subscription;

  List<Expense> _expenses = [];
  bool _loading = true;
  String? _error;

  String? selectedCategory;
  String searchQuery = '';
  DateTimeRange? dateRange;

  ExpenseProvider(this._service) {
    _subscribe();
  }

  void _subscribe() {
    _loading = true;
    _subscription = _service.watchExpenses().listen((data) {
      _expenses = data;
      _loading = false;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _error = 'Could not load expenses. Please check your connection.';
      _loading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  bool get isLoading => _loading;
  String? get error => _error;
  List<Expense> get allExpenses => _expenses;

  List<Expense> get filteredExpenses {
    return _expenses.where((e) {
      if (selectedCategory != null && e.category != selectedCategory) {
        return false;
      }
      if (dateRange != null) {
        final d = DateTime(e.date.year, e.date.month, e.date.day);
        final start = DateTime(
            dateRange!.start.year, dateRange!.start.month, dateRange!.start.day);
        final end =
            DateTime(dateRange!.end.year, dateRange!.end.month, dateRange!.end.day);
        if (d.isBefore(start) || d.isAfter(end)) return false;
      }
      if (searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        if (!e.title.toLowerCase().contains(q) &&
            !e.note.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  double get currentMonthTotal {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> get currentMonthCategoryTotals {
    final now = DateTime.now();
    final Map<String, double> totals = {};
    for (final e in _expenses) {
      if (e.date.year == now.year && e.date.month == now.month) {
        totals[e.category] = (totals[e.category] ?? 0) + e.amount;
      }
    }
    return totals;
  }

  void setCategoryFilter(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    dateRange = range;
    notifyListeners();
  }

  void clearFilters() {
    selectedCategory = null;
    searchQuery = '';
    dateRange = null;
    notifyListeners();
  }

  Future<void> addExpense(Expense e) => _service.addExpense(e);
  Future<void> updateExpense(Expense e) => _service.updateExpense(e);
  Future<void> deleteExpense(String id) => _service.deleteExpense(id);
}