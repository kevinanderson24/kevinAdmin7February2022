import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/product_model.dart';

class DatabaseServices{
  final String uid;
  DatabaseServices({this.uid});

  final CollectionReference userCollection =
    Firestore.instance.collection('users');

  final CollectionReference productCollection =
    Firestore.instance.collection('product');

  final CollectionReference informationCollection =
    Firestore.instance.collection('information');
  
  Future deleteUser(){
    return userCollection.document(uid).delete();
  }

  List<Product> _productSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return Product(
        id: doc.data['id'] ?? 'id',
        name: doc.data['name'] ?? 'name',
        price: doc.data['price'] ?? 0,
        description: doc.data['description'] ?? 'desc',
        url: doc.data['url'] ?? 'url',
      );
    }).toList();
  }

  Stream<List<Product>> get productStream {
    return productCollection.snapshots().map(_productSnapshot);
  }


}