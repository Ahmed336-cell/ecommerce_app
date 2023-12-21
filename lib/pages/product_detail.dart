import 'package:flutter/material.dart';
import 'package:cartly/model/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../config/favourite_notifier.dart';
import '../model/data.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.product.image, height: 200, width: double.infinity),
            SizedBox(height: 20),
            Text(
              widget.product.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ Text(
                widget.product.category,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),

                // IconButton(onPressed: (){
                //   setState(() {
                //     favoriteNotifier.toggleFavorite(widget.product);
                //   });
                // },
                //     icon: Icon(
                //       favoriteNotifier.isFavorite(widget.product)
                //           ? Icons.favorite
                //           : Icons.favorite_border,
                //       color: Colors.red,
                //     ),
                //   color: Colors.white,
                // ),
        ]
            ),
            SizedBox(height: 10),
            Text(
              'Price: \$${widget.product.price.toString()}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 10),

            RatingBar.builder(
              initialRating: widget.product.rating?.rate ?? 0.0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                // Handle rating update if needed
                print(rating);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            // Add your logic for handling the button press
            AppData.cartList.add(widget.product);
          },
          child: Icon(Icons.add_shopping_cart),
          backgroundColor: Colors.orange.shade900,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

    );
  }
}
