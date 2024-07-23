import 'package:expense_tracker/core/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onMonthChange});
  final ValueChanged<String> onMonthChange;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = "";
  List<Map<String, dynamic>> categoryList = [];
  AppIcons appIcons = AppIcons();
  final ScrollController scrollController = ScrollController();

  void initState() {
    super.initState();
    setState(() {
      categoryList = appIcons.homeExpensesCategories;
      categoryList.insert(0, addCat);
    });
  }

  // scrollToSelectedMonth() {
  //   final selectedMonthIndex = month.indexOf(currentMonth);
  //   if (selectedMonthIndex != -1) {
  //     final scrollOffset = (selectedMonthIndex * 100.0) - 170;
  //     scrollController.animateTo(scrollOffset,
  //         duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  //   }
  // }
  var addCat = {"name": "All", "icon": FontAwesomeIcons.cartPlus};
  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
        height: 40,
        child: ListView.builder(
            itemCount: categoryList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var data = categoryList[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentCategory = data["name"];
                    widget.onMonthChange(currentCategory);
                  });
                },
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentCategory == data["name"]
                        ? Colors.grey[200]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Icon(data["icon"],
                            size: 15,
                            color: data["name"] == currentCategory
                                ? Colors.red
                                : Colors.black),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(data["name"],
                            style: TextStyle(
                                color: data["name"] == currentCategory
                                    ? Colors.red
                                    : Colors.black)),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
