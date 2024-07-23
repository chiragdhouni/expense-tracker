// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineMonth extends StatefulWidget {
  const TimeLineMonth({super.key, required this.onMonthChange});
  final ValueChanged<String> onMonthChange;

  @override
  State<TimeLineMonth> createState() => _TimeLineMonthState();
}

class _TimeLineMonthState extends State<TimeLineMonth> {
  String currentMonth = "";
  List<String> month = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = -23; i <= 0; i++) {
      month.add(
          DateFormat('MMM y').format(DateTime(now.year, now.month + i, 1)));
    }
    currentMonth = DateFormat('MMM y').format(now);
    Future.delayed(Duration(seconds: 1), () {
      scrollToSelectedMonth();
    });
  }

  scrollToSelectedMonth() {
    final selectedMonthIndex = month.indexOf(currentMonth);
    if (selectedMonthIndex != -1) {
      final scrollOffset = (selectedMonthIndex * 100.0) - 170;
      scrollController.animateTo(scrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: ListView.builder(
            itemCount: month.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentMonth = month[index];
                    widget.onMonthChange(currentMonth);
                  });
                  scrollToSelectedMonth();
                },
                child: Container(
                  width: 80,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentMonth == month[index]
                        ? Colors.grey[200]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(month[index],
                        style: TextStyle(
                            color: month[index] == currentMonth
                                ? Colors.red
                                : Colors.black)),
                  ),
                ),
              );
            }));
  }
}
