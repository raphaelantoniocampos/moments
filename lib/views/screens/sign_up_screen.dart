import 'package:flutter/material.dart';

import '../../constants.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    authController.registerUser(_usernameController.text,
        _emailController.text, _passwordController.text);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            const Text(
              "moments",
              style: TextStyle(color: primaryColor, fontSize: 50),
            ),
            const SizedBox(
              height: 24,
            ),

            // text field input username
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Enter your username'),
                    keyboardType: TextInputType.text,
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input email
                  TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input password
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Enter your password'),
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //button signup
                  ElevatedButton(
                    onPressed: () async {
                      if (!_isLoading) {
                        setState(() {
                          _isLoading = true;
                        });
                        signUpUser();
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const ShapeDecoration(
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign up'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      )),
    );
  }
}
