import 'package:cartly/model/rating.dart';

class Product {
  int id;
  String title;
  String category;
  String image;
  double price;
  String description;
  bool? isLiked; // Change here
  bool isSelected;
   Rating ?rating;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.description,
     this.rating,
    this.isLiked, // Change here
    this.isSelected = false,
    required this.image,
  });



  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      price: json['price'].toDouble(),
      description: json['description'],
      isLiked: json['isLiked'],
      isSelected: false,
      image: json['image'],
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,

    );
  }
}
