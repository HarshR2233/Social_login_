import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailpasslogin/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailValidator {
  static String? validate(String value) {
    const Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }
}

class signUpScreen extends StatefulWidget {
  const signUpScreen({Key? key}) : super(key: key);

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person_off_outlined),
                        hintText: "Full Name",
                        contentPadding: EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: emailError
                              ? const BorderSide(color: Colors.red)
                              : const BorderSide(),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: emailError ? 'Incorrect email' : null,
                      ),
                      onChanged: (_) => setState(() => emailError = false),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        String? emailValidationResult =
                            EmailValidator.validate(value);

                        return emailValidationResult;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Phone Number",
                        contentPadding: EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: passwordError
                              ? const BorderSide(color: Colors.red)
                              : const BorderSide(),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: passwordError ? 'Incorrect password' : null,
                      ),
                      onChanged: (_) => setState(() => passwordError = false),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: reEnterPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Re-enter Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: passwordError
                              ? const BorderSide(color: Colors.red)
                              : const BorderSide(),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: passwordError ? 'Incorrect password' : null,
                      ),
                      onChanged: (_) => setState(() => passwordError = false),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Validate the form before submitting
                            if (_formKey.currentState?.validate() ?? false) {
                              registerUser();
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        phoneNumber: phoneNumberController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'uid': userCredential.user!.uid,
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const loginScreen()),
      );

      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
      reEnterPasswordController.clear();
      phoneNumberController.clear();
    } catch (e) {
      print('Registration failed: $e');
      // Handle registration failure, e.g., show an error message.
    }
  }
}
