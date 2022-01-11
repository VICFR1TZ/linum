import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/abstract/abstract_statistic_panel.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Provides the balance data from the database using the uid.
class BalanceDataProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _balance;

  /// The uid of the user
  late String _uid;

  late AlgorithmProvider _algorithmProvider;

  num _dontDispose = 0;

  static const Duration FUTURE_DURATION = Duration(days: 365 * 10);

  /// Creates the BalanceDataProvider. Inparticular it sets [_balance] correctly
  BalanceDataProvider(BuildContext context) {
    _uid = Provider.of<AuthenticationService>(context, listen: false).uid;
    _algorithmProvider = Provider.of<AlgorithmProvider>(context, listen: false);
    asynConstructor();
  }

  /// Async part of the constructor (so notifyListeners will be used after loading)
  void asynConstructor() async {
    DocumentSnapshot<Map<String, dynamic>> documentToUser =
        await FirebaseFirestore.instance
            .collection('balance')
            .doc("documentToUser")
            .get();
    if (documentToUser.exists) {
      List<dynamic>? docs = documentToUser.get(_uid);
      if (docs != null) {
        // Future support multiple docs per user
        _balance =
            FirebaseFirestore.instance.collection('balance').doc(docs[0]);
        _addRepeatablesToBalanceData();
        notifyListeners();
      } else {
        log("no docs found for user: " + _uid);
      }
    } else {
      log("no data found in documentToUser");
    }
  }

  void updateAuth(AuthenticationService? auth) {
    if (auth != null) {
      _uid = auth.uid;
      asynConstructor();
    }
  }

  void updateAlgorithmProvider(AlgorithmProvider? algorithm) {
    if (algorithm != null) {
      _algorithmProvider = algorithm;
      asynConstructor();
    }
  }

  /// Get the document-datastream. Maybe in the future it might be a public function
  Stream<DocumentSnapshot<Map<String, dynamic>>>? get _dataStream {
    return _balance?.snapshots();
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillListViewWithData(BalanceDataListView blistview,
      {required BuildContext context}) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          blistview.setBalanceData([
            {"Error": "snapshot.data == null"}
          ], context: context);
          return blistview.listview;
        } else {
          dynamic data = snapshot.data.data();
          List<dynamic> balanceData = data["balanceData"];

          // log(balanceData[0].runtimeType.toString());

          // Future there could be an sort algorithm provider
          // (and possibly also a filter algorithm provided)
          balanceData.sort(_algorithmProvider.currentSorter);
          balanceData.removeWhere(_algorithmProvider.currentFilter);

          blistview.setBalanceData(balanceData, context: context);
          return blistview.listview;
        }
      },
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillStatisticPanelWithData(
      AbstractStatisticPanel statisticPanel) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          statisticPanel.addStatisticData(null);
          return statisticPanel.widget;
        } else {
          List<dynamic> balanceData = snapshot.data["balanceData"];
          balanceData.removeWhere(_algorithmProvider.currentFilter);
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(balanceData as List<Map<String, dynamic>>);
          statisticPanel.addStatisticData(statisticsCalculations);
          return statisticPanel.widget;
        }
      },
    );
  }

  /// add a single Balance and upload it
  Future<bool> addSingleBalance({
    required num amount,
    required String category,
    required String currency,
    required String name,
    required Timestamp time,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    Map<String, dynamic> singleBalance = {
      "amount": amount,
      "category": category,
      "currency": currency,
      "name": name,
      "time": time,
    };
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    data["balanceData"].add(singleBalance);
    await _balance!.set(data);
    return true;
  }

  /// remove a single Balance and upload it (identified using the name and time)
  Future<bool> removeSingleBalance({
    required String name,
    required Timestamp time,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }

    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    int dataLength = data["balanceData"].length;
    data["balanceData"].removeWhere((value) {
      return value["name"] == name && value["time"] == time;
    });
    if (dataLength > data["balanceData"].length) {
      await _balance!.set(data);
      return true;
    }
    return false;
  }

  /// update a single Balance and upload it (identified using the name and time)
  Future<bool> updateSingleBalance({
    required num amount,
    required String category,
    required String currency,
    required String name,
    required Timestamp time,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    bool isEdited = false;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    data["balanceData"].forEach((value) {
      if (!isEdited && (value["name"] == name && value["time"] == time)) {
        isEdited = !(value["amount"] == amount &&
            value["category"] == category &&
            value["currency"] == currency);
        if (isEdited) {
          value["amount"] = amount;
          value["category"] = category;
          value["currency"] = currency;
        }
      }
    });
    if (isEdited) {
      await _balance!.set(data);
    }
    return isEdited;
  }

  void dontDisposeOneTime() {
    _dontDispose++;
  }

  @override
  void dispose() {
    if (_dontDispose-- == 0) {
      super.dispose();
    }
  }

  Future<void> _addRepeatablesToBalanceData() async {
    dynamic data = await _balance!.get();
    data = data.data();
    if (data["repeatedBalance"] == null) {
      return;
    }
    // log(data["repeatedBalance"].toString());
    for (int i = 0; i < data["repeatedBalance"].length; i++) {
      dynamic singleRepeatedBalance = data["repeatedBalance"][i];
      if (singleRepeatedBalance["lastUpdate"] == null) {
        singleRepeatedBalance["lastUpdate"] = Timestamp(0, 0);
      }
      if (singleRepeatedBalance != null &&
          ((singleRepeatedBalance["lastUpdate"] as Timestamp)
              .toDate()
              .add(Duration(seconds: singleRepeatedBalance["repeatDuration"]))
              .isBefore(DateTime.now()))) {
        _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
      }
    }
    await _balance!.set(data);
  }

  // .
  Future<bool> addRepeatedBalance({
    required num amount,
    required String category,
    required String currency,
    required String name,
    required Timestamp initialTime,
    required Duration repeatDuration,
    Timestamp? endTime,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    Map<String, dynamic> singleRepeatedBalance = {
      "amount": amount,
      "category": category,
      "currency": currency,
      "name": name,
      "initialTime": initialTime,
      "repeatDuration": repeatDuration.inSeconds,
      "endTime": endTime,
      "id": Uuid().v4(),
    };
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    data["repeatedBalance"].add(singleRepeatedBalance);
    _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
    await _balance!.set(data);
    return true;
  }

  // .
  Future<bool> updateRepeatedBalance({
    required String id,
    num? amount,
    String? category,
    String? currency,
    String? name,
    Timestamp? initialTime,
    Duration? repeatDuration,
    Timestamp? endTime,
    bool? resetEndTime,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    bool isEdited = false;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    data["repeatedBalance"].forEach((value) {
      if (!isEdited && (value["id"] == id)) {
        if (amount != null && amount != value["amount"]) {
          value["amount"] = amount;
          isEdited = true;
        }
        if (category != null && category != value["category"]) {
          value["category"] = category;
          isEdited = true;
        }
        if (currency != null && currency != value["currency"]) {
          value["currency"] = currency;
          isEdited = true;
        }
        if (name != null && name != value["name"]) {
          value["name"] = name;
          isEdited = true;
        }
        if (initialTime != null && initialTime != value["initialTime"]) {
          value["initialTime"] = initialTime;
          isEdited = true;
        }
        if (repeatDuration != null &&
            repeatDuration != value["repeatDuration"]) {
          value["repeatDuration"] = repeatDuration.inSeconds;
          isEdited = true;
        }
        if (endTime != null && endTime != value["endTime"]) {
          value["endTime"] = endTime;
          isEdited = true;
        }
        if (resetEndTime != null && resetEndTime) {
          value[endTime] = null;
          isEdited = true;
        }
      }
    });
    if (isEdited) {
      _redoRepeatable(
        (data["repeatedBalance"] as List<dynamic>)
            .firstWhere((element) => element["id"] != id),
        data,
      );
      await _balance!.set(data);
    }
    return isEdited;
  }

  // .
  Future<bool> removeRepeatedBalance(
      {required String id, required RemoveType removeType}) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    int length = (data["repeatedBalance"] as List<dynamic>).length;
    (data["repeatedBalance"] as List<dynamic>)
        .removeWhere((element) => element["id"] == id);
    if (length == (data["repeatedBalance"] as List<dynamic>).length) {
      return false;
    }
    switch (removeType) {
      case RemoveType.ALL:
        _deleteAllCopiesOfRepeatableLocally(id, data);
        break;
      case RemoveType.All_BEFORE:
        // TODO: Handle this case.
        break;
      case RemoveType.ALL_AFTER:
        // TODO: Handle this case.
        break;
      case RemoveType.NONE:
        break;
    }
    await _balance!.set(data);
    return true;
  }

  void _redoRepeatable(dynamic singleRepeatedBalance, dynamic data) {
    _deleteAllCopiesOfRepeatableLocally(singleRepeatedBalance["id"], data);
    _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
  }

  Future<void> _deleteAllCopiesOfRepeatable(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();

    _deleteAllCopiesOfRepeatableLocally(id, data);
    return _balance!.set(data);
  }

  void _deleteAllCopiesOfRepeatableLocally(String id, dynamic data) {
    (data["balanceData"] as List<dynamic>)
        .removeWhere((element) => element["repeatId"] == id);
  }

  Future<void> _addSingleRepeatableToBalanceData(
      dynamic singleRepeatedBalance) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
    return _balance!.set(data);
  }

  void _addSingleRepeatableToBalanceDataLocally(
      dynamic singleRepeatedBalance, dynamic data) {
    DateTime currentTime = singleRepeatedBalance["initialTime"].toDate();
    bool didUpdate = false;

    // while we are before 10 years after today / before endTime
    while ((singleRepeatedBalance["endTime"] != null)
        ? currentTime.isBefore(singleRepeatedBalance["endTime"].toDate())
        : currentTime.isBefore(DateTime.now().add(FUTURE_DURATION))) {
      // if (currentTime.isAfter(
      // (singleRepeatedBalance["lastUpdate"] as Timestamp).toDate())) {
      didUpdate = true;
      (data["balanceData"] as List<dynamic>).add({
        "amount": singleRepeatedBalance["amount"],
        "category": singleRepeatedBalance["category"],
        "currency": singleRepeatedBalance["currency"],
        "name": singleRepeatedBalance["name"],
        "time": Timestamp.fromDate(currentTime),
        "repeatId": singleRepeatedBalance["id"],
      });
      // }

      currentTime = currentTime
          .add(Duration(seconds: singleRepeatedBalance["repeatDuration"]));
    }
    if (didUpdate) {
      singleRepeatedBalance["lastUpdate"] = Timestamp.fromDate(DateTime.now());
    }
  }
}

enum RemoveType {
  ALL,
  All_BEFORE,
  ALL_AFTER,
  NONE,
}
