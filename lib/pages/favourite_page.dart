import 'package:cartly/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cartly/model/product.dart';
import '../model/data.dart';
import '../theme/light_color.dart';
import '../widgets/titletext.dart'; // Import the widget responsible for displaying a product

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Choose your desired color
        title: Text('Favorite Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: AppData.favoriteList.length,
          itemBuilder: (context, index) {
            Product product = AppData.favoriteList[index];
            return _item( product); // Use your product item widget here
          },
        ),
      ),
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

              ),
            ),
          ],
        ),
      ),
    );
  }
}
