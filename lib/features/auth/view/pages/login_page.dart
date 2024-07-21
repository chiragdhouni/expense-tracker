import 'package:expense_tracker/core/widgets/custom_field.dart';
import 'package:expense_tracker/features/auth/repository/auth_service.dart';
import 'package:expense_tracker/features/home/view/pages/dashboard_page.dart';
import 'package:expense_tracker/features/auth/view/pages/signup_page.dart';
import 'package:expense_tracker/features/auth/view/widgets/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _submitForm() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
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
      "email": emailController.text,
      "password": passwordController.text,
    };

    UserCredential? res = await AuthService().login(data, context);
    if (res != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login ',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),
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
                      ? const CircularProgressIndicator()
                      : GradientButton(
                          text: Text(
                            "Login",
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
                              builder: (context) => const SignUpPage()));
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: "SignUp",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
