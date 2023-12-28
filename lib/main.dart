import 'package:emailpasslogin/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FacebookAuth.instance;
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBpSC8S79LLLgPqjSaBBBfJognUIThTOVU',
      appId: 'com.example.emailpasslogin',
      messagingSenderId: '358988636746',
      projectId: 'emailpass-d5615',
    ),
  );
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // User is already signed in
    print(
        'User is already signed in: ${user.displayName}, ${user.email}, ${user.uid}');
  } else {
    // Sign-in failed
    print('Sign-in failed.');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const loginScreen(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
