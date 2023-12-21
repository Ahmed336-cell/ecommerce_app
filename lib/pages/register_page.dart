import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cartly/pages/mainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/constants.dart';
import '../widgets/roundbtn.dart';
class RegistrationScreen extends StatefulWidget {
  static String id = "register_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth =  FirebaseAuth.instance;
  late String email;
  late String password;
  late String name;
  late String number;
  bool showSpinner = false;
  final _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/logo.jpg'),
                  ),
                ),
              ),
              TextField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;              },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your Name"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  number = value;              },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your Phone Number"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;              },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                obscureText: true,
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your password" ,),
              ),
              SizedBox(
                height: 14.0,
              ),
              RoundButton(text: "Register", onPressed: () async{
                setState(() {
                  showSpinner= true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if(newUser !=null){
                    await _firestore.collection("users").doc(newUser.user!.uid).set(
                      {
                        "name":name,
                        "phone":number,
                        "email":email,
                      }
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MainPage()),
                    );

                  }else{
                    print("Error");
                    setState(() {
                      showSpinner = false;
                    });
                  }
                }catch(e){
                  print(e);
                }
              }, color: Colors.orange.shade900),
            ],
          ),
        ),
      ),
    );
  }
}