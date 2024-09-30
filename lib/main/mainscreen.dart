
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/loginscreen.dart';
import 'bottomnaviagationbar/apiscreen.dart';
import 'bottomnaviagationbar/firebasescreen.dart';
import 'bottomnaviagationbar/localdbscreen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<MainScreen> {
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _currentIndex = 0;

  final List<Widget> _screens = [
    FirebaseScreen(),
    Apiscreen(),
    LocalDbScreen(),
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    fetchUserData();
  }
  // Method to fetch user data from Firestore
  void fetchUserData() async {
    try {
      // Fetch the document with a specific ID from the 'users' collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('userID') // Replace with the actual document ID
          .get();

      if (userSnapshot.exists) {
        // Extract the full name field from the document
        setState(() {


          _nameController.text = userSnapshot.get('full_name'); ;
          _emailController.text = userSnapshot.get('email');
          _passwordController.text =  userSnapshot.get('password');;// ssuming the field is 'full_name'
        });
      } else {
        setState(() {
          _nameController.text  = "User not found";
        });
      }
    } catch (e) {
      setState(() {
        _nameController.text  = "Error fetching data";
      });
      print(e);
    }
  }

  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _fullName = prefs.getString('name') ?? '';
  //     print(_fullName);
  //     _email = prefs.getString('email') ?? '';
  //     _password = prefs.getString('password') ?? '';
  //   });
  //   _nameController.text = _fullName;
  //   _emailController.text = _email;
  //   _passwordController.text = _password;
  // }

  // Future<void> _saveUserData() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('name', _fullName);
  //     await prefs.setString('email', _email);
  //     await prefs.setString('password', _password);
  //
  //     setState(() {
  //       _isEditing = false;
  //     });
  //   }
  // }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Do you want to logout?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('main Screen'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                _confirmLogout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_currentIndex],

      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Form(
      //     key: _formKey,
      //     child: Column(
      //       children: [
      //         SizedBox(
      //             height: 300,
      //             child: Image.asset('assets/images/logo.png')),
      //         SizedBox(height: 20,),
      //
      //         TextFormField(
      //           controller: _nameController,
      //           decoration: InputDecoration(labelText: 'Full Name',
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0), // Set rounded corners
      //             ),
      //             focusedBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0),
      //               borderSide: BorderSide(
      //                 color: Colors.blue, // Color when the field is focused
      //               ),
      //             ),
      //             enabledBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0),
      //               borderSide: BorderSide(
      //                 color: Colors.grey, // Color when the field is not focused
      //               ),
      //             ),),
      //
      //
      //           enabled: _isEditing,
      //           validator: (value) =>
      //           value!.isEmpty ? 'Please enter your full name' : null,
      //           onSaved: (value) =>  _nameController.text  = value!,
      //         ),
      //         SizedBox(height: 20,),
      //         TextFormField(
      //           decoration: InputDecoration(labelText: 'Email',
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0), // Set rounded corners
      //             ),
      //             focusedBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0),
      //               borderSide: BorderSide(
      //                 color: Colors.blue, // Color when the field is focused
      //               ),
      //             ),
      //             enabledBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0),
      //               borderSide: BorderSide(
      //                 color: Colors.grey, // Color when the field is not focused
      //               ),
      //             ),),
      //
      //           controller: _emailController,
      //           enabled: _isEditing,
      //           validator: (value) =>
      //           value!.isEmpty ? 'Please enter your email' : null,
      //           onSaved: (value) =>  _emailController.text  = value!,
      //         ),
      //         SizedBox(height: 20,),
      //         TextFormField(
      //           decoration: InputDecoration(labelText: 'Password',
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0), // Set rounded corners
      //             ),
      //             focusedBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0),
      //               borderSide: BorderSide(
      //                 color: Colors.blue, // Color when the field is focused
      //               ),
      //             ),
      //             enabledBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(30.0),
      //               borderSide: BorderSide(
      //                 color: Colors.grey, // Color when the field is not focused
      //               ),
      //             ),),
      //
      //           controller: _passwordController,
      //           enabled: _isEditing,
      //           obscureText: true,
      //           validator: (value) =>
      //           value!.isEmpty ? 'Please enter your password' : null,
      //           onSaved: (value) =>  _passwordController.text  = value!,
      //         ),
      //         SizedBox(height: 20),
      //         _isEditing
      //             ? ElevatedButton(
      //           onPressed: (){},
      //           child: Text('Done'),
      //         )
      //             : ElevatedButton(
      //           onPressed: () {
      //             setState(() {
      //               _isEditing = true;
      //             });
      //           },
      //           child: Text('Edit Profile'),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      //
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Firebase'),
          BottomNavigationBarItem(icon: Icon(Icons.api), label: 'API'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Local DB'),
        ],
      ),
    );
  }
}
