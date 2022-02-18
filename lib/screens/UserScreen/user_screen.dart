import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/Screens/UserScreen/adduser_screen.dart';
import 'package:ebutler/Services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListUser extends StatefulWidget {
  const ListUser({ Key key }) : super(key: key);

  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  CollectionReference collectionReference = Firestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            // width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('users').orderBy('createdAt', descending: false).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                  showBottomBorder: true,
                  dataRowHeight: 80,
                  columns: const [
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('')), //delete 
                  ],
                  rows: _buildList(context, snapshot.data.documents),
                );
              },
            ),
          ),
        ],
      ),

      //--------------------- Button (+) ----------------------//
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          //menuju ke page "Add Product"
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser(),));
        },
        child: const Icon(Icons.add),
      ),

    );
  }
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      DataCell(Text(data['name'].toString())),
      DataCell(Text(data['email'].toString())),
      DataCell(Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          highlightColor: Colors.orange[100],
          splashColor: Colors.green[100],
          onPressed: () async {
            await AuthenticationService().deleteUser(data['email'], data['password']).whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User deleted successfully!"), 
                  backgroundColor: Colors.redAccent
                )
              );
            });
          }, 
          icon: const Icon(Icons.delete, color: Colors.white, size: 20.0,),
        ),
      )),
    ]);
  }
}

class OrderBy{
  String status;
}