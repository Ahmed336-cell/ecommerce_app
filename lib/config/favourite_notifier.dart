import 'package:flutter/foundation.dart';

import '../model/product.dart';

class FavoriteNotifier extends ChangeNotifier {
  List<Product> _favoriteList = [];

  List<Product> get favoriteList => _favoriteList;

  void toggleFavorite(Product product) {
    if (_favoriteList.contains(product)) {
      _favoriteList.remove(product);
    } else {
      _favoriteList.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favoriteList.contains(product);
  }
}