import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
              height: 300,
              child:
              Image.asset('images/top.jpeg', height: 20, fit: BoxFit.fill)),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Image.asset('images/pic4.png'),
          ),
          SizedBox(
            height: 40,
          ),

          Container(
            width: 200,
            height: 100,
            child: TextField(
              controller: nameController,
              //keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                focusColor: Colors.yellow,
                hintText: 'Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF7C12B), width: 3.0),
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 100,
            child: TextField(
              controller: emailController,
              //keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                focusColor: Colors.yellow,
                hintText: 'Email-id',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF7C12B), width: 3.0),
                ),
              ),
            ),
          ),
          Container(
            width: 319,
            height: 48,
            child: ElevatedButton(
              onPressed: () async{
                _firestore.collection('users').add({
                  'name': nameController.text,
                  'email': emailController.text,
                  'date and time': DateTime.now().toString(),

                });
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF7C12B),
                fixedSize: Size(100, 48),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     //Implement send functionality.
          //     _firestore.collection('users').add({
          //       'name': nameController.text,
          //       'email': emailController.text,
          //       'date and time': DateTime.now().toString(),
          //
          //     });
          //   },
          //   child: Text(
          //     'Submit',
          //
          //   ),
          // ),
          ],
            ),
    );
  }
}

