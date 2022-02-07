import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/product_model.dart';

class DatabaseServices{
  final String id;
  DatabaseServices({this.id});
  //--------- PRODUCT -----------------------//
  final CollectionReference productCollection =
    Firestore.instance.collection('product');

  final CollectionReference informationCollection =
    Firestore.instance.collection('information');

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
  //---------------------- END of PRODUCT ----------------------------//

}