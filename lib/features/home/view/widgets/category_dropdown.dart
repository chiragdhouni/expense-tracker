import 'package:expense_tracker/core/utils/icons_list.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({super.key, this.cattype, required this.onChanged});

  final String? cattype;
  final ValueChanged<String?> onChanged;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    // Ensure all categories have unique names
    final categories = appIcons.homeExpensesCategories;

    // Check if cattype is in the list of category names
    final validCattype =
        categories.any((category) => category['name'] == cattype)
            ? cattype
            : null;

    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text('Select Category'),
      value: validCattype,
      onChanged: onChanged,
      items: categories.map((e) {
        return DropdownMenuItem<String>(
          value: e['name'],
          child: Row(
            children: [
              Icon(e['icon']),
              SizedBox(width: 10),
              SizedBox(
                width: 10,
              ),
              Text(
                e['name'],
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
