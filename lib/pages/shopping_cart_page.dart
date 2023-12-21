import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cartly/model/data.dart';
import 'package:cartly/model/product.dart';
import 'package:cartly/theme/light_color.dart';
import 'package:cartly/theme/theme.dart';
import 'package:cartly/widgets/titletext.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  int num=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(""),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.delete,color: Colors.orange.shade900,),
            onPressed: () {
              _clearCart();
            },
          ),
        ],),
      body: Container(
        padding: AppTheme.padding,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _cartItems(),
              Divider(
                thickness: 1,
                height: 70,
              ),
              _price(),
              SizedBox(height: 30),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartItems() {
    return Column(
      children: AppData.cartList.map((x) => _item(x)).toList(),
    );
  }

  Widget _item(Product model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Container(
        height: 80,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 70,
                      width: 70,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: -20,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.network(model.image,width: 100,height: 80,),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListTile(
                title: TitleText(
                  text: model.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                subtitle: Row(
                  children: <Widget>[
                    TitleText(
                      text: '\$ ',
                      color: LightColor.red,
                      fontSize: 12,
                    ),
                    TitleText(
                      text: model.price.toString(),
                      fontSize: 14,
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (num > 1) {
                           num--;
                          }
                        });
                      },
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TitleText(
                        text: 'x${num}',
                        fontSize: 12,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                         num++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: '${AppData.cartList.length} Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: '\$${getPrice()}',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return TextButton(
      onPressed: () {

        AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Confirm Order',
            desc: 'if you want confirm order press ok otherwise press cancel',
            btnCancelOnPress: () {},
        btnOkOnPress: () {
          // Get the current user
          User? user = FirebaseAuth.instance.currentUser;

          // Check if the user is signed in
          if (user != null) {
            // Create a list to store cart data
            List<Map<String, dynamic>> cartDataList = [];

            // Iterate through each product in the cart and add its data
            AppData.cartList.forEach((product) {
              cartDataList.add({
                "productId": product.id,
                "title":product.title,
                "quantity": num,
                "image":product.image,
                "price":product.price,

              });
            });

            // Calculate the total amount
            double totalAmount = getPrice();

            // Create a map to represent the order
            Map<String, dynamic> orderData = {
              "userId": user.uid,
              "cart": cartDataList,
              "totalAmount": totalAmount,
              "timestamp": FieldValue.serverTimestamp(),
            };

            FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("orders").add(orderData);

            _clearCart();


          }
        },
        )..show();

      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(LightColor.orange),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 4),
        width: AppTheme.fullWidth(context) * .75,
        child: TitleText(
          text: 'Place Order',
          color: LightColor.background,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  double getPrice() {
    double price = 0;
    AppData.cartList.forEach((x) {
      price += x.price * num;
    });
    return price;
  }

  void _clearCart() {
    setState(() {
      // Clear the cart list
      AppData.cartList.clear();
    });
  }
}
