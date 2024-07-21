import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_tracker/features/home/view/widgets/category_dropdown.dart';

class AddTransactionForm extends StatefulWidget {
  AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = 'credit';
  var category = 'others';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoader = false;
  var uid = Uuid();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final User = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      var title = titleEditController.text;
      DateTime date = DateTime.now();

      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(User!.uid)
          .get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];

      if (type == 'credit') {
        totalCredit += amount;
        remainingAmount += amount;
      } else {
        totalDebit += amount;
        remainingAmount -= amount;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(User.uid)
          .update({
        'remainingAmount': remainingAmount,
        'totalCredit': totalCredit,
        'totalDebit': totalDebit,
        'updatedAt': timestamp
      });

      var data = {
        "id": id,
        "title": titleEditController.text,
        "amount": amount,
        "type": type,
        "timestamp": timestamp,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount,
        "monthyear": monthyear,
        "category": category,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(User.uid)
          .collection('transactions')
          .doc(id)
          .set(data);

      Navigator.pop(context);

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleEditController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: amountEditController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              CategoryDropdown(
                  cattype: category,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        category = value;
                      });
                    }
                  }),
              DropdownButtonFormField(
                  value: type,
                  items: [
                    DropdownMenuItem(child: Text('Credit'), value: 'credit'),
                    DropdownMenuItem(child: Text('debit'), value: 'debit'),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        type = value;
                      });
                    }
                  }),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: isLoader
                    ? Center(
                        child: SingleChildScrollView(),
                      )
                    : Text("Add Transaction"),
              )
            ],
          )),
    );
  }
}
