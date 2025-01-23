import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voicelung/screens/onboarding_screen.dart';
import 'package:voicelung/screens/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LUNGVOAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignupScreen(),
    );
  }
}


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _signupController = TextEditingController();
  int _currentId = 1;
  // final String _idPrefix = 'id';
  // int _currentNumber = 1;

  @override
  void initState() {
    super.initState();
    _initializeSignupIdentifier();
  }

  void _initializeSignupIdentifier() {
    _signupController.text = 'id${_currentId.toString().padLeft(5, '0')}';
    // _signupController.text = _currentNumber.toString().padLeft(5, '0');
  }

  void _incrementSignupIdentifier() {
    setState(() {
      _currentId++; // Increment ID
      _signupController.text = 'id${_currentId.toString().padLeft(5, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'LUNGVOAI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            // Mic Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.mic,
                  size: 48,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            // Signup Identifier Text Field
            TextField(
              controller: _signupController,
              readOnly: true, // Make the field read-only
              decoration: InputDecoration(
                hintText: 'Signup identifier',
                border: const UnderlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
            const SizedBox(height: 32.0),
            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () => _createAccount(context),
                child: const Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createAccount(BuildContext context) async {
    String username = _signupController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup identifier cannot be empty')),
      );
      return;
    }

    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Check if the user already exists
      DocumentSnapshot userDoc = await usersCollection.doc(username).get();

      if (userDoc.exists) {
        // User already exists, show an error or redirect
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskPage(userName: username)),
        );
      } else {
        // Create a new user document with the username as the document ID
        await usersCollection.doc(username).set({
          'name': username,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Increment the ID for the next signup
        _incrementSignupIdentifier();

        // Navigate to the Onboarding Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(userName: username),
          ),
        );
      }
    } catch (e) {
      // Handle Firestore errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}