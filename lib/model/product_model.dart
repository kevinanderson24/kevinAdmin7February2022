import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class Product with ChangeNotifier{
  final String id;
  final String name;
  final String description;
  final int price;
  final String url;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.url,
  });
}
