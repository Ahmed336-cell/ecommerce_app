import 'package:cartly/pages/product_detail.dart';
import 'package:flutter/material.dart';

import 'package:cartly/model/product.dart';
import 'package:cartly/theme/light_color.dart';
import 'package:cartly/widgets/titletext.dart';
import 'package:cartly/widgets/extensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onSelected;
  ProductCard({ Key? key, required this.product, required this.onSelected}) : super(key: key);

//   @override
//   _ProductCardState createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard> {
//   Product product;
//   @override
//   void initState() {
//     product = widget.product;
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ProductDetailPage(product: product)),
        );

      },
      child: Container(
        decoration: BoxDecoration(
          color: LightColor.background,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: !product.isSelected ? 20 : 0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Positioned(
              //   left: 0,
              //   top: 0,
              //   child: IconButton(
              //     icon: Icon(
              //       //product.isLiked ? Icons.favorite : Icons.favorite_border,
              //       //color:
              //       //product.isLiked ? LightColor.red : LightColor.iconColor,
              //     ),
              //     onPressed: () {},
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: product.isSelected ? 15 : 0),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: LightColor.orange.withAlpha(40),
                        ),
                        Image.network(product.image)
                      ],
                    ),
                  ),
                  // SizedBox(height: 5),
                  TitleText(
                    text: product.title,
                    fontSize: product.isSelected ? 16 : 14,
                  ),
                  TitleText(
                    text: product.category,
                    fontSize: product.isSelected ? 14 : 12,
                    color: LightColor.orange,
                  ),
                  TitleText(
                    text: "\$${product.price.toString()}",
                    fontSize: product.isSelected ? 18 : 16,
                  ),
                  RatingBar.builder(
                    initialRating: product.rating?.rate ?? 0.0,
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
                ],
              ),
            ],
          ),
        ).ripple(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ProductDetailPage(product: product)),
          );
          onSelected(product);
        }, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
