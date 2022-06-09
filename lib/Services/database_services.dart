import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/product_model.dart';
import 'package:flutter/cupertino.dart';

class DatabaseServices {
  final String uid;
  DatabaseServices({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('product');

  final CollectionReference informationCollection =
      FirebaseFirestore.instance.collection('information');

  Future deleteUser() {
    return userCollection
        .orderBy(uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              element.reference.delete();
            }));
  }

  // Future addUser(String uid, String email, String name, String password, Timestamp timestamp) async {
  //   return await userCollection.document(uid).setData({
  //     'uid': uid,
  //     'email': email,
  //     'name': name,
  //     'password': password,
  //     'timestamp': Timestamp.now(),
  //   });
  // }

  List<Product> _productSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Product(
        id: doc.data()['id'] ?? 'id',
        name: doc.data()['name'] ?? 'name',
        price: doc.data()['price'] ?? 0,
        description: doc.data()['description'] ?? 'desc',
        url: doc.data()['url'] ?? 'url',
      );
    }).toList();
  }

  Stream<List<Product>> get productStream {
    return productCollection.snapshots().map(_productSnapshot);
  }
}
