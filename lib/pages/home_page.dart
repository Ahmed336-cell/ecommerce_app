import 'dart:convert';

import 'package:cartly/model/product.dart';
import 'package:cartly/pages/last_orders_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cartly/model/data.dart';
import 'package:cartly/theme/light_color.dart';
import 'package:cartly/theme/theme.dart';
import 'package:cartly/widgets/extensions.dart';
import 'package:cartly/widgets/product_card.dart';
import 'package:cartly/widgets/proudct_icon.dart';
import 'package:http/http.dart'as http;

import '../model/category.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Product>> _products;
  late Future<List<Category>> _categories; // Add this line
  TextEditingController _searchController = TextEditingController(); // Add this line


  Future<List<Category>> _fetchCategories() async {
    // Fetch category names from the API
    String apiUrl = 'https://fakestoreapi.com/products/categories';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Category> categories = jsonResponse
          .map((categoryName) => Category(
        id: jsonResponse.indexOf(categoryName),
        title: categoryName,
        // You can set a default image if needed
        isSelected: false,
      ))
          .toList();

      // Select the first category by default
      categories.first.isSelected = true;
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
  Future<List<Product>> _fetchProducts(Category selectedCategory) async {
    // Fetch products from the API based on the selected category
    String apiUrl = 'https://fakestoreapi.com/products/category/${selectedCategory.title}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonResponse = List<Map<String, dynamic>>.from(json.decode(response.body));

      List<Product> productList = jsonResponse.map((data) => Product.fromJson(data)).toList();

      return productList;
    } else {
      throw Exception('Failed to load products');
    }
  }
  @override
  void initState() {
    super.initState();
    _categories = _fetchCategories();
    _products = _fetchProducts(AppData.categoryList.firstWhere((c) => c.isSelected));
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

  Widget _categoryWidget() {
    return FutureBuilder<List<Category>>(
      future: _categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Category> categories = snapshot.data!;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: AppTheme.fullWidth(context),
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories
                  .map(
                    (category) => ProductIcon(
                  model: category,
                  onSelected: (model) {
                    setState(() {
                      categories.forEach((item) {
                        item.isSelected = false;
                      });
                      model.isSelected = !(model.isSelected ?? false); // Change here
                      _products = _fetchProducts(model);
                    });
                  },
                ),
              )
                  .toList(),
            ),
          );
        }
      },
    );
  }

  Widget _productWidget() {
    return FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          print("error: ${snapshot.error}");
          return Text('Error: ${snapshot.error}');
        } else {
          List<Product> products = snapshot.data!;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: AppTheme.fullWidth(context),
            height: AppTheme.fullWidth(context) * .7,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Update the crossAxisCount to 2 for a grid view
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              padding: EdgeInsets.all(20),
              scrollDirection: Axis.horizontal,
              children: products
                  .map(
                    (product) => ProductCard(
                  product: product,
                  onSelected: (model) {
                    setState(() {
                      products.forEach((item) {
                        item.isSelected = false;
                      });
                      model.isSelected = true;
                    });
                  },
                ),
              )
                  .toList(),
            ),
          );
        }
      },
    );
  }
  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: LightColor.lightGrey.withAlpha(100),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  // Update the displayed products based on the search query
                  _updateSearchResults(query);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Products",
                  hintStyle: TextStyle(fontSize: 12),
                  contentPadding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.shopping_cart,color: Colors.black,),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  OrdersPage()),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 210,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _search(),
            _categoryWidget(),
            _productWidget(),
          ],
        ),
      ),
    );
  }

  void _updateSearchResults(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all products again
      _products = _fetchProducts(AppData.categoryList.firstWhere((c) => c.isSelected));
    } else {
      _products.then((products) {
        List<Product> filteredProducts = products.where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase())).toList();

        setState(() {
          _products = Future.value(filteredProducts);
        });
      });
    }
  }


}
