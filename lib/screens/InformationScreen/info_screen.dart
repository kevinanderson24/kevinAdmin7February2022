import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/info_model.dart';
import 'package:ebutler/screens/InformationScreen/updateinfo_screen.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key key}) : super(key: key);

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('information');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data.docs.map((data) {
              return Card(
                color: Colors.blueAccent,
                child: ListTile(
                  title: Text(data['title'].toString()),
                  onTap: () {
                    var route = MaterialPageRoute(
                      builder: (context) => UpdateInformation(
                        value: Information(
                          title: data['title'].toString(),
                          description: data['description'].toString(),
                        ),
                      ),
                    );
                    Navigator.of(context).push(route);
                  },
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.navigate_next,
                          size: 30,
                        ),
                        onPressed: () {
                          var route = MaterialPageRoute(
                            builder: (context) => UpdateInformation(
                              value: Information(
                                title: data['title'].toString(),
                                description: data['description'].toString(),
                              ),
                            ),
                          );
                          Navigator.of(context).push(route);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
