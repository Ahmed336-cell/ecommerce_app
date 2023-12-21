import 'package:cartly/pages/login_page.dart';
import 'package:cartly/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/favourite_notifier.dart';
import 'config/route.dart';
import 'package:cartly/pages/mainPage.dart';
import 'package:cartly/pages/product_detail.dart';
import 'model/product.dart';
import 'widgets/customRoute.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/theme.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce ',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }


}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading indicator or splash screen
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // User is signed in
          return MainPage();
        } else {
          // User is not signed in
          return LoginScreen();
        }
      },
    );
  }
}
