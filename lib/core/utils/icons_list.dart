import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {
      "name": "Gas Fillings",
      "icon": FontAwesomeIcons.gasPump,
    },
    {
      "name": "Groceries",
      "icon": FontAwesomeIcons.cartShopping,
    },
    {
      "name": "milk",
      "icon": FontAwesomeIcons.mugHot,
    },
    {
      "name": "internet",
      "icon": FontAwesomeIcons.wifi,
    },
    {
      "name": "Electricity",
      "icon": FontAwesomeIcons.bolt,
    },
    {
      "name": "water",
      "icon": FontAwesomeIcons.water,
    },
    {
      "name": "Rent",
      "icon": FontAwesomeIcons.houseUser,
    },
    {
      "name": "phone bill",
      "icon": FontAwesomeIcons.phone,
    },
    {
      "name": "dining out",
      "icon": FontAwesomeIcons.utensils,
    },
    {
      "name": "transportation",
      "icon": FontAwesomeIcons.car,
    },
    {
      "name": "health",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "name": "clothing",
      "icon": FontAwesomeIcons.shirt,
    },
    {
      "name": "insurance",
      "icon": FontAwesomeIcons.handshake,
    },
    {
      "name": "Education",
      "icon": FontAwesomeIcons.graduationCap,
    },
    {
      "name": "other",
      "icon": FontAwesomeIcons.cartPlus,
    }
  ];

  IconData GetExpenseCategoryIcons(String categoryName) {
    final category = homeExpensesCategories.firstWhere(
        (category) => category["name"] == categoryName,
        orElse: () => {"icon": FontAwesomeIcons.cartPlus});
    return category["icon"];
  }
}
