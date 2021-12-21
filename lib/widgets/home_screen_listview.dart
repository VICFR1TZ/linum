// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';

class HomeScreenListView implements BalanceDataListView {
  late ListView _listview;

  HomeScreenListView() {
    _listview = new ListView();
  }

  @override
  addBalanceData(List<dynamic> balanceData) {
    List<Widget> list = [];
    if (balanceData[0] != null && balanceData[0]["Error"] == null) {
      balanceData.forEach(
        (arrayElement) {
          arrayElement.forEach(
            (key, element) {
              log("key:  " + key);
              log("value: " + element.toString());
              //list.add(Text(key + ": " + element.toString()));

              //list.add(ListTile(title: ),);
              list.add(
                ListTile(
                  title: Text(arrayElement["name"]),
                  subtitle: Text(arrayElement["time"].toString()),
                  trailing: Text(arrayElement["amount"].toString()),
                ),
              );
              // list.add(
              //   Container(
              //     height: 60,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 50,
              //           height: 50,
              //           color: Colors.red,
              //         ),
              //         Column(
              //           children: [
              //             Text(arrayElement["category"]),
              //             Text(arrayElement["time"].toString().split(' ')[0]),
              //           ],
              //         ),
              //         Text(arrayElement["amount"].toString()),
              //       ],
              //     ),
              //   ),
              // );
            },
          );
        },
      );
    } else {
      log("HomeScreenListView: " + balanceData[0]["Error"].toString());
    }
    _listview = ListView(children: list);
  }

  @override
  ListView get listview => _listview;
}