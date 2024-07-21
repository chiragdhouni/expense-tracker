import 'package:expense_tracker/core/widgets/custom_field.dart';
import 'package:expense_tracker/features/auth/repository/auth_service.dart';
import 'package:expense_tracker/features/home/view/pages/dashboard_page.dart';
import 'package:expense_tracker/features/auth/view/pages/login_page.dart';
import 'package:expense_tracker/features/auth/view/widgets/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false;
  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('submitted'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
    }
    var data = {
      "username": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "remainingAmount": 0,
      "totalCredit": 0,
      "totalDebit": 0
    };
    UserCredential? res = await AuthService().createUser(data, context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SignUp ',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    CustomField(
                      hintText: 'enter your name',
                      controller: nameController,
                      suffixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 20),
                    CustomField(
                      hintText: 'enter your email',
                      controller: emailController,
                      suffixIcon: const Icon(Icons.email),
                    ),
                    const SizedBox(height: 20),
                    CustomField(
                      hintText: 'enter your password',
                      controller: passwordController,
                      isObscureText: true,
                      suffixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GradientButton(
                            text: const Text(
                              "SignUp",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              _submitForm();
                            }),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
