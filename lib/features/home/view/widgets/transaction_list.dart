// ignore_for_file: unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/utils/icons_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TransactionList extends StatelessWidget {
  TransactionList(
      {super.key,
      required this.type,
      required this.category,
      required this.monthYear});

  String userId = FirebaseAuth.instance.currentUser!.uid;

  AppIcons appIcons = AppIcons();

  final String type;

  final String category;

  final String monthYear;

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .where('type', isEqualTo: type)
        .where('monthyear', isEqualTo: monthYear);

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    return FutureBuilder<QuerySnapshot>(
        future: query.limit(150).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          var data = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 4),
                            )
                          ]),
                      child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: data[index]['type'] == 'credit'
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: FaIcon(
                              appIcons.GetExpenseCategoryIcons(
                                  '${data[index]['category']}'),
                              color: data[index]['type'] == 'credit'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(
                            "${data[index]['title']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Balance"),
                              Text(
                                  "${DateFormat("d MMM hh:mma").format(DateTime.fromMicrosecondsSinceEpoch(data[index]['timestamp']))}"),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹ ${data[index]['type'] == 'credit' ? '+' : '-'}${data[index]['amount']}",
                                style: TextStyle(
                                    color: data[index]['type'] == 'credit'
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text("₹ ${data[index]['remainingAmount']}")
                            ],
                          )),
                    ),
                  );
                }),
          );
        });
  }
}
