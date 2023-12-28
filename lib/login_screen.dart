import 'package:emailpasslogin/forgot_password.dart';
import 'package:emailpasslogin/home_screen.dart';
import 'package:emailpasslogin/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool emailError = false;
  bool passwordError = false;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Login_demo'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

                      // Use the EmailValidator to check the email format
                      String? emailValidationResult =
                          EmailValidator.validate(value);

                      return emailValidationResult;
                    },
                  ),
                  const SizedBox(height: 10),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const signUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const forgotPassword(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Validate the form before submitting
                          if (_formKey.currentState?.validate() ?? false) {
                            loginUser();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                      SignInButton(Buttons.Google, onPressed: () async {
                        User? user = await _handleSignIn();
                        if (user != null) {
                          print('User is signed in: ${user.displayName}');
                        } else {
                          print('Sign-in failed.');
                        }
                      }),
                      SignInButton(
                        Buttons.Facebook,
                        onPressed: () {
                          signInWithFacebook();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      print('User logged in: ${userCredential.user!.uid}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(), // Replace HomeScreen with your actual home screen widget
        ),
      );
    } catch (e) {
      print('Login failed: $e');

      if (e.toString().contains('wrong-password')) {
        setState(() {
          passwordError = true;
          emailError = false;
        });
      } else if (e.toString().contains('user-not-found') ||
          e.toString().contains('invalid-email')) {
        setState(() {
          emailError = true;
          passwordError = false;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email or password is incorrect'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        print('User logged in with Facebook: ${userCredential.user!.uid}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(), // Replace HomeScreen with your actual home screen widget
          ),
        );
      } else {
        print('Facebook login failed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Facebook login failed'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Facebook login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Facebook login failed'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<User?> _handleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User? user = authResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
