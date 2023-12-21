import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cartly/pages/home_page.dart';
import 'package:cartly/pages/shopping_cart_page.dart';
import 'package:cartly/theme/light_color.dart';
import 'package:cartly/theme/theme.dart';
import 'package:cartly/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:cartly/widgets/titletext.dart';
import 'package:cartly/widgets/extensions.dart';

import '../model/data.dart';
import 'favourite_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);


  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String userName = '';
  bool isHomePageSelected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserName();
  }
  Future<void> _loadUserName() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Print the user ID
        print('User ID: ${user.uid}');

        // User is signed in, fetch user data from Firestore
        DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        // Check if the "name" field exists in the document
        if (userData.exists && userData.data() != null && userData.data()!.containsKey('name')) {
          // Update the user name in the state
          setState(() {
            userName = userData['name'];
          });
          print(userName);
        } else {
          print('Document does not contain a "name" field.');
        }
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }
  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // RotatedBox(
          //   quarterTurns: 4,
          //   child: _icon(Icons.sort, color: Colors.black54),
          // ),
          
          Text("Welcome \n${userName}",style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xfff8f8f8),
                      blurRadius: 10,
                      spreadRadius: 10),
                ],
              ),
              child: Image.asset("assets/user.png"),
            ),
          ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)))
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: isHomePageSelected ? 'Our' : 'Shopping',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: isHomePageSelected ? 'Products' : 'Cart',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            !isHomePageSelected
                ? Container(
              // padding: EdgeInsets.all(10),
              // child: IconButton(
              //   icon: Icon(
              //     Icons.delete_outline,
              //     color: LightColor.orange,
              //   ),
              //   onPressed: (){
              //     _clearCart();
              //   },
              // ),

            ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)))
                : SizedBox()
          ],
        ));
  }

  void onBottomIconPressed(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        isHomePageSelected = true;
      });
    } else if(index==2){
      setState(() {
        isHomePageSelected = false;
      });
    }else{
      try {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavouritePage()),
        );
      } catch (e) {
        print('Error navigating to FavouritePage: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xfffbfbfb),
                      Color(0xfff7f7f7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBar(),
                    _title(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeOutBack,
                        child: isHomePageSelected
                            ? MyHomePage()
                            : Align(
                          alignment: Alignment.topCenter,
                          child: ShoppingCartPage(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                onIconPresedCallback: onBottomIconPressed,
              ),
            )
          ],
        ),
      ),
    );
  }

}
