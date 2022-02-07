import 'package:ebutler/model/product_model.dart';
import 'package:flutter/cupertino.dart';

class ProductNotifier with ChangeNotifier {
  
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  int get productCount {
    return _items.length;
  }

  void addProduct(
      String id, String name, String description, int price, String url) {
    _items.insert(
      0,
      Product(
        id: id,
        name: name,
        description: description,
        price: price,
        url: url,
      ),
    );
  }

  void clear() {
    _items = [];
  }
  
}