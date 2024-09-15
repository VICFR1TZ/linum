import 'dart:async';

import 'package:collection/collection.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/core/balance/domain/balance_data_adapter.dart';
import 'package:linum/core/balance/domain/balance_data_repository.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/domain/utils/transaction_generation.dart';
import 'package:linum/core/budget/domain/models/changes.dart';

typedef TransactionProcessor = void Function(List<Transaction>);

class BalanceDataRepositoryImpl implements IBalanceDataRepository {
  final Map<String, Map<String, Transaction>> _transactionStorage = {};
  final Map<String, SerialTransaction> _serialTransactionStorage = {};
  final List<TransactionProcessor> _transactionProcessors;

  final previewSpan = Jiffy.now().add(years: 1).dateTime; // TODO: Set previewSpan from outside

  final IBalanceDataAdapter _adapter;

  final Completer<bool> _initialized = Completer();

  BalanceDataRepositoryImpl({
    required IBalanceDataAdapter adapter,
    List<TransactionProcessor>? transactionProcessors,
  }): _adapter = adapter, _transactionProcessors = transactionProcessors ?? [] {
    Future.wait([
      _adapter.getAllSerialTransactions().then((data) async {
        return await _setSerialTransactionsStorage(data);
      }),
      _adapter.getAllTransactions().then((data) async {
        return await _setTransactionsStorage(data);
      }),
    ]).then((_) {
      _initialized.complete(true);
    });
  }

  String _getStorageKey(DateTime date) => Jiffy.parseFromDateTime(date).yMMM;

  Future<void> _setTransactionsStorage(List<Transaction> transactions) async {
    for (final processor in _transactionProcessors) {
      processor(transactions);
    }

    for (final transaction in transactions) {
      final key = _getStorageKey(transaction.date);
      if (!_transactionStorage.containsKey(key)) {
        _transactionStorage[key] = {};
      }
      _transactionStorage[key]?[transaction.id] = transaction;
    }
  }

  Future<void> _setSerialTransactionsStorage(List<SerialTransaction> serialTransactions) async {
    final transactions = generateTransactions(serialTransactions, previewSpan);

    _setTransactionsStorage(transactions);
    for (final serialTransaction in serialTransactions) {
      _serialTransactionStorage[serialTransaction.id] = serialTransaction;
    }
  }

  void _removeSerialTransactionFromStorage(SerialTransaction serialTransaction) {
    _serialTransactionStorage.remove(serialTransaction.id);

    // Remove all transactions generated by this serialTransaction
    for (final dateMap in _transactionStorage.values) {
      dateMap.removeWhere((k, t) => t.repeatId == serialTransaction.id);
    }
  }

  void _removeTransactionFromStorage(Transaction transaction) {
    final key = _getStorageKey(transaction.date);
    final removed = _transactionStorage[key]?.remove(transaction.id) != null;
    if (!removed) {
      for (final value in _transactionStorage.values) {
        value.remove(transaction.id);
      }
    }

    // TODO: Warning if there is no index?
  }

  void _persistSerialTransactionInStorage(SerialTransaction serialTransaction) {
    // Clean up everything before adding again (generated Transactions)
    _removeSerialTransactionFromStorage(serialTransaction);

    _serialTransactionStorage[serialTransaction.id] = serialTransaction;

    final transactions = generateTransactions([serialTransaction], previewSpan);
    _setTransactionsStorage(transactions);
  }

  void _persistTransactionInStorage(Transaction transaction) {
    _removeTransactionFromStorage(transaction); // Ensure there is no duplicate in case of a date change
    final key = _getStorageKey(transaction.date);
    final map = _transactionStorage[key];
    if (map == null) {
      _transactionStorage[key] = {
        transaction.id: transaction,
      };
    } else {
      _transactionStorage[key]![transaction.id] = transaction;
    }
  }

  @override
  Future<List<SerialTransaction>> getAllSerialTransactions() async {
    return List.of(_serialTransactionStorage.values);
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final listOfLists = _transactionStorage.values.map((values) => values.values);
    return List.of(listOfLists.flattened);
  }

  @override
  Future<List<SerialTransaction>> getSerialTransactionsForMonth(DateTime month) async {
    return _serialTransactionStorage.values.where((s) => s.containsDate(month)).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsForMonth(DateTime month) async {
    return _transactionStorage[_getStorageKey(month)]?.values.toList() ?? [];
  }

  @override
  Future<void> removeSerialTransaction(SerialTransaction serialTransaction) async {
    _removeSerialTransactionFromStorage(serialTransaction);
    _adapter.executeSerialTransactionChanges([
      ModelChange(ChangeType.delete, serialTransaction),
    ]);
  }

  @override
  Future<void> removeTransaction(Transaction transaction) async {
    _removeTransactionFromStorage(transaction);

    _adapter.executeTransactionChanges([
      ModelChange(ChangeType.delete, transaction),
    ]);
    return;
  }

  @override
  Future<void> createSerialTransaction(SerialTransaction serialTransaction) async {
    _persistSerialTransactionInStorage(serialTransaction);
    await _adapter.executeSerialTransactionChanges([
      ModelChange(ChangeType.create, serialTransaction),
    ]);
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    _persistTransactionInStorage(transaction);
    await _adapter.executeTransactionChanges([
      ModelChange(ChangeType.create, transaction),
    ]);
  }

  @override
  Future<void> updateSerialTransaction(SerialTransaction serialTransaction) async {
    _persistSerialTransactionInStorage(serialTransaction);
    await _adapter.executeSerialTransactionChanges([
      ModelChange(ChangeType.update, serialTransaction),
    ]);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    _persistTransactionInStorage(transaction);
    await _adapter.executeTransactionChanges([
      ModelChange(ChangeType.update, transaction),
    ]);
  }

  @override
  Future<void> executeSerialTransactionChanges(List<ModelChange<SerialTransaction>> changes) async {
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          _persistSerialTransactionInStorage(change.model);
        case ChangeType.update:
          _persistSerialTransactionInStorage(change.model);
        case ChangeType.delete:
          _removeSerialTransactionFromStorage(change.model);
      }
    }

    _adapter.executeSerialTransactionChanges(changes);
  }

  @override
  Future<void> executeTransactionChanges(List<ModelChange<Transaction>> changes) async {
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          _persistTransactionInStorage(change.model);
        case ChangeType.update:
          _persistTransactionInStorage(change.model);
        case ChangeType.delete:
          _removeTransactionFromStorage(change.model);
      }
    }
  }

  @override
  Future<SerialTransaction?> getSerialTransactionById(String id) async {
    return _serialTransactionStorage[id];
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    for (final dateMap in _transactionStorage.values) {
      final transaction = dateMap[id];
      if (transaction != null) {
        return transaction;
      }
    }
    return null;
  }

  @override
  Future<bool> ready() => _initialized.future;

}
