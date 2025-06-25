import 'dart:convert';

import 'package:expense_manager/models/expense_category.dart';
import 'package:expense_manager/models/tag.dart';
import 'package:expense_manager/models/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;

  List<Expense> _expenses = [];
  final List<ExpenseCategory> _categories = [ 
    ExpenseCategory(id: '1', name: 'Food', isDefault: true),
    ExpenseCategory(id: '2', name: 'Transport', isDefault: true),
    ExpenseCategory(id: '3', name: 'Entertainment', isDefault: true),
    ExpenseCategory(id: '4', name: 'Office', isDefault: true),
    ExpenseCategory(id: '5', name: 'Gym', isDefault: true),
  ];
  final List<Tag> _tags = [
    Tag(id: '1', name: 'Breakfast'),
    Tag(id: '2', name: 'Lunch'),
    Tag(id: '3', name: 'Dinner'),
    Tag(id: '4', name: 'Treat'),
    Tag(id: '5', name: 'Cafe'),
    Tag(id: '6', name: 'Restaurant'),
    Tag(id: '7', name: 'Train'),
    Tag(id: '8', name: 'Vacation'),
    Tag(id: '9', name: 'Birthday'),
    Tag(id: '10', name: 'Diet'),
    Tag(id: '11', name: 'MovieNight'),
    Tag(id: '12', name: 'Tech'),
    Tag(id: '13', name: 'CarStuff'),
    Tag(id: '14', name: 'SelfCare'),
    Tag(id: '15', name: 'Streaming'),
  ];

  List<Expense> get expenses => _expenses;
  List<ExpenseCategory> get categories => _categories;
  List<Tag> get tags => _tags;

  ExpenseProvider(this.storage) {
  _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() async {
    var data = storage.getItem('expenses');
    if (data == null) return;

    final List decoded = jsonDecode(data);
    _expenses = List<Expense>.from(
      decoded.map((item) => Expense.fromJson(item))
    );
    notifyListeners();
  }

  void _saveExpensesToStorage() {
    storage.setItem('expenses', jsonEncode(_expenses.map((expense) => expense.toJson()).toList()));
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    } else {
      _expenses.add(expense);
    }
    _saveExpensesToStorage();
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((element) => element.id == id);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addCategory(ExpenseCategory category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void removeCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      notifyListeners();
    }
  }

  void removeTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }
}