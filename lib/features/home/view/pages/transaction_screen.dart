import 'package:expense_tracker/features/home/view/widgets/category_list.dart';
import 'package:expense_tracker/features/home/view/widgets/tab_bar_view.dart';
import 'package:expense_tracker/features/home/view/widgets/time_line_month.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String monthYear = "";

  String category = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Exansive")),
        body: Column(
          children: [
            TimeLineMonth(onMonthChange: (String? value) {
              if (value != null) {
                setState(() {
                  monthYear = value;
                });
              }
            }),
            CategoryList(onMonthChange: (String? value) {
              if (value != null) {
                setState(() {
                  category = value;
                });
              }
            }),
            TypeBarView(
              category: category,
              monthYear: monthYear,
            ),
          ],
        ));
  }
}
