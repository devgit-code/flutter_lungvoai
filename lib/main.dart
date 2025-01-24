import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voicelung/screens/onboarding_screen.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/user_data.dart';  // Import the UserData class

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

  @override
  void initState() {
    super.initState();

    // Increase ID before loading the SignupScreen and set the new ID in the controller
    UserData.increaseId();  // Increment the ID
    _signupController.text = UserData.idName;  // Set the new ID as text in the controller
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
            // Signup Identifier TextField
            TextField(
              controller: _signupController,
              readOnly: true,  // Make the field read-only
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
                onPressed: () => _createAccount(context),  // Create account action
                child: const Text(
                  'Sign UP',
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
    String username = _signupController.text.trim();  // Get value from TextField

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup identifier cannot be empty')),
      );
      return;
    }

    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Check if the user already exists in Firestore
      DocumentSnapshot userDoc = await usersCollection.doc(username).get();

      if (userDoc.exists) {
        // If user exists, navigate to TaskPage and set UserData
        UserData.idName = username;  // Save the ID to UserData
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskPage()),  // Navigate to TaskPage
        );
      } else {
        // If user doesn't exist, navigate to OnboardingPage for registration
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
