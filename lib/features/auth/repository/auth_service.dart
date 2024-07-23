import 'dart:developer';

import 'package:expense_tracker/features/home/view/pages/dashboard_page.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future<UserCredential?> createUser(data, context) async {
    Db db = Db();
    try {
      UserCredential res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data['email'], password: data['password']);

      await db.addUser(data, context);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));

      return res;
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              ));
      return null;
    }
  }

  Future<UserCredential?> login(data, context) async {
    try {
      UserCredential res = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: data['email'], password: data['password']);
      log(res.user!.email.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
        ),
      );
      return res;
    } catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              ));
      return null;
    }
  }
}
