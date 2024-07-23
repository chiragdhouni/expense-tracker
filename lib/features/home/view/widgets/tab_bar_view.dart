// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expense_tracker/features/home/view/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

class TypeBarView extends StatelessWidget {
  const TypeBarView(
      {super.key, required this.category, required this.monthYear});
  final String category;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(
              text: "credit",
            ),
            Tab(
              text: "debit",
            )
          ]),
          Expanded(
              child: TabBarView(children: [
            TransactionList(
                type: "credit", category: category, monthYear: monthYear),
            TransactionList(
                type: "debit", category: category, monthYear: monthYear)
          ]))
        ],
      ),
    ));
  }
}
