// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/theme/app_pallete.dart';
import 'package:expense_tracker/core/utils/icons_list.dart';
import 'package:expense_tracker/features/auth/view/pages/login_page.dart';
import 'package:expense_tracker/features/home/view/widgets/add_transaction_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  logout() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  AppIcons appIcons = AppIcons();

  _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: AddTransactionForm());
        });
  }

  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late final Stream<DocumentSnapshot> _usersStream;
  @override
  void initState() {
    // TODO: implement initState
    _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          var data = snapshot.data!.data() as Map<String, dynamic>;

          return Container(
            color: Pallete.backgroundColor,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Balance",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${data['remainingAmount']}",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                height: 70,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("   Credit",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                          "${data['totalCredit']}",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green,
                                          size: 20,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                height: 70,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("   Debit",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                          "${data['totalDebit']}",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.red,
                                          size: 20,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "Recent Transactions",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "See all",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .collection('transactions')
                                .orderBy('timestamp', descending: true)
                                .limit(15)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Text("Document does not exist");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 4),
                                                )
                                              ]),
                                          child: ListTile(
                                              leading: Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                    color: data[index]
                                                                ['type'] ==
                                                            'credit'
                                                        ? Colors.green
                                                            .withOpacity(0.2)
                                                        : Colors.red
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: FaIcon(
                                                  appIcons.GetExpenseCategoryIcons(
                                                      '${data[index]['category']}'),
                                                  color: data[index]['type'] ==
                                                          'credit'
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              title: Text(
                                                "${data[index]['title']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Balance"),
                                                  Text(
                                                      "${DateFormat("d MMM hh:mma").format(DateTime.fromMicrosecondsSinceEpoch(data[index]['timestamp']))}"),
                                                ],
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "₹ ${data[index]['type'] == 'credit' ? '+' : '-'}${data[index]['amount']}",
                                                    style: TextStyle(
                                                        color: data[index]
                                                                    ['type'] ==
                                                                'credit'
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                      "₹ ${data[index]['remainingAmount']}")
                                                ],
                                              )),
                                        ),
                                      );
                                    }),
                              );
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
