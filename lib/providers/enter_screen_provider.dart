import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnterScreenProvider with ChangeNotifier {
  bool _isExpenses = true;
  bool _isIncome = false;
  bool _isTransaction = false;
  String _name = "";
  num _amount;
  String _expenseCategory = "";
  String _incomeCategory = "";
  String _currency = "";
  String _repeat = "Niemals";
  DateTime _selectedDate = DateTime.now();
  bool _editMode;

  final _formKey = GlobalKey<FormState>();

  EnterScreenProvider({
    num amount = 0.0,
    String category = "",
    String name = "",
    String repeat = "",
    String currency = "",
    String secondaryCategory = "",
    DateTime? selectedDate,
    bool editMode = false,
  })  : _amount = amount,
        _expenseCategory = amount <= 0 ? category : secondaryCategory,
        _incomeCategory = amount > 0 ? category : secondaryCategory,
        _name = name,
        _repeat = repeat,
        _currency = currency,
        _editMode = editMode,
        _selectedDate = selectedDate ?? DateTime.now();
  //amount: amount, category: category, currency: currency, name: name, time: time

  setIsExpenses(bool isExpenses) {
    _isExpenses = isExpenses;
    notifyListeners();
  }

  setIsIncome(bool isIncome) {
    _isIncome = isIncome;
    notifyListeners();
  }

  setIsTransaction(bool isTransaction) {
    _isTransaction = isTransaction;
    notifyListeners();
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }

  setAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  setCategory(String category) {
    if (amount <= 0) {
      _expenseCategory = category;
    } else {
      _incomeCategory = category;
    }
    notifyListeners();
  }

  setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  setSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  setRepeat(String repeat) {
    _repeat = repeat;
    notifyListeners();
  }

  bool get isExpenses {
    return _isExpenses;
  }

  bool get isIncome {
    return _isIncome;
  }

  bool get isTransaction {
    return _isTransaction;
  }

  String get name {
    return _name;
  }

  num get amount {
    return _amount;
  }

  String get category {
    log(_expenseCategory + " " + _incomeCategory);
    return amount <= 0 ? _expenseCategory : _incomeCategory;
  }

  String get currency {
    return _currency;
  }

  DateTime get selectedDate {
    return _selectedDate;
  }

  GlobalKey<FormState> get formKey {
    return _formKey;
  }

  String get repeat {
    return _repeat;
  }

  bool get editMode {
    return _editMode;
  }
}
