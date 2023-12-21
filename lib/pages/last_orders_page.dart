import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text('Your Orders'),
      ),
      body: user != null
          ? StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData ||
              (snapshot.data as QuerySnapshot).docs.isEmpty) {
            return Center(
              child: Text('No orders yet.'),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index) {
              var order = (snapshot.data as QuerySnapshot).docs[index];

              // Access the list of products in the order
              var productList = order['cart'] as List<dynamic>;

              // Build a ListView to display details of each item in the order
              var productListView = ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (context, productIndex) {
                  var product = productList[productIndex];
                  return ListTile(
                    title:
                    Column(children: [
                      Image.network(product['image'],width: 100,height: 100,),
                      Text('Product: ${product['title']}')
                    ]),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${product['quantity']}',style: TextStyle(fontSize: 16)),
                        Text('Price: \$${product['price']}',style: TextStyle(fontSize: 16),),
                        // Add more details as needed
                      ],
                    ),
                  );
                },
              );

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text('Order ID: ${order.id}'),
                      Text('Total Amount: \$${order['totalAmount']}',style: TextStyle(
                        fontSize: 24
                      ),),
                      productListView,
                    ],
                  ),
                ),
              );
            },
          );
        },
      )
          : Center(
        child: Text('Please sign in to view your orders.'),
      ),
    );
  }
}
