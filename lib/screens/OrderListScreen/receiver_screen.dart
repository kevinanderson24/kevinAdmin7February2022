import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Receiver extends StatefulWidget {
  const Receiver({Key key}) : super(key: key);
  static const routeName = '/receiver';
  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  @override
  Widget build(BuildContext context) {
    String roomNumber;
    bool visibility = true;
    String uid;
    String time;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Cart').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotCart) {
          if (!snapshotCart.hasData) {
            return Center(
              child: Text('No Order yet'),
            );
          }
          if (snapshotCart.data.docs.isEmpty) {
            return Center(
              child: Text('No Order yet'),
            );
          }
          return Column(
            children: [
              AppBar(
                title: Text('Current Orders',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.blue[900],
              ),
              Expanded(
                child: ListView(
                  children: snapshotCart.data.docs.map((doc) {
                    roomNumber = null;
                    uid = null;
                    time = null;

                    for (var i in doc.data().values) {
                      roomNumber = i['Room Number'].toString();
                      uid = i['User Id'].toString();
                      time = i['Time'].toString();
                      break;
                    }

                    if (roomNumber == null) {
                      visibility = false;
                    } else {
                      visibility = true;
                    }
                    return Visibility(
                      visible: visibility,
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Room: " + roomNumber.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: SelectableText(
                                uid ?? 'hi',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: [
                                for (var i in doc.data().values)

                                  // width: MediaQuery.of(context).size.width,
                                  Text(
                                    i['Title'] +
                                        " x " +
                                        i['Quantity'].toString(),
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.start,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Ordered at: ' + time.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
