
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../main/mainscreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Validation for email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

// Validation for password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
  void _signUp() async {
    try {
      if (_formKey.currentState!.validate()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', _nameController.text);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('password', _passwordController.text);
        await prefs.setBool('isLoggedIn', true);

        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
// Get the newly created user's UID
        User? user = userCredential.user;
        if (user != null) {
          // Save additional user data to Firestore

          await _firestore.collection('users').doc(user.uid).set({
            'first_name': _nameController.text.trim(),
            'last_name': _lastnameController.text.trim(),
            'email': _emailController.text.trim(),
            // It’s not a good practice to store passwords in Firestore. Use this only for educational purposes.
            'password': _passwordController.text.trim(),
          });
          // On successful sign-up, navigate to main Screen
          if (userCredential.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        }}
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Unknown error occurred')),
      );
    }
  }

  // Function to save user data in SharedPreferences

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
        body: Center(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                        child: Image.asset('assets/images/logo.png')),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Set rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.blue, // Color when the field is focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.grey, // Color when the field is not focused
                          ),
                        ),),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),
                SizedBox(height: 20,),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Set rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.blue, // Color when the field is focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.grey, // Color when the field is not focused
                          ),
                        ),),
                      validator:_validateEmail ,
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Set rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.blue, // Color when the field is focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.grey, // Color when the field is not focused
                          ),
                        ),),
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width - 50,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: Text('Sign Up',style: TextStyle(color: Colors.white, fontSize: 25,),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ),
        ),

    );
  }
}
