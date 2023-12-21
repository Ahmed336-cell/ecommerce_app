import 'package:cartly/pages/mainPage.dart';
import 'package:cartly/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/constants.dart';
import '../widgets/roundbtn.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth =  FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall:showSpinner ,
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
              SizedBox(
                height: 35.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your email"),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password =value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                obscureText: true,
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your password"),
              ),
              TextButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  RegistrationScreen()),
                );
              }, child: Text("If you don't have account can Register",style: TextStyle(fontSize: 16),)),
              SizedBox(
                height: 14.0,
              ),
              RoundButton(text: "Log In", onPressed: () async{
                setState(() {
                  showSpinner = true;
                });
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(user != null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MainPage()),
                    );
                  }else{
                    print("error");
                  }
                  setState(() {
                    showSpinner=false;
                  });
                }catch(e){
                  print(e);
                  showSpinner=false;

                }

              }, color: Colors.orange.shade900)
            ],
          ),
        ),
      ),
    );
  }
}