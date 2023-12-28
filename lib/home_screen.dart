import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emailpasslogin/login_screen.dart'; // Import your login screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userEmail;
  String? userfullName;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.reload(); // Reload the user to get the updated information
        user = FirebaseAuth
            .instance.currentUser; // Retrieve the updated user object

        setState(() {
          userfullName = user?.displayName;
          userEmail = user?.email;
        });

        print('Full Name: $userfullName');
        print('Email: $userEmail');
        if (user?.phoneNumber != null) {
          print('Phone Number: ${user?.phoneNumber}');
        } else {
          print('Phone Number not provided');
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const loginScreen(), // Replace with your login screen
        ),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome! You have logged in successfully'),
            const SizedBox(height: 20),
            if (userfullName != null) Text('Full Name: $userfullName'),
            if (userEmail != null) Text('Email: $userEmail'),
          ],
        ),
      ),
    );
  }
}
