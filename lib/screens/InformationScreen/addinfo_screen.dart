import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddInformation extends StatefulWidget {
  const AddInformation({Key key}) : super(key: key);

  @override
  _AddInformationState createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController titleController =
      TextEditingController(); //controller //controller
  final TextEditingController descriptionController =
      TextEditingController(); //controller
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('information');

  checkForm(BuildContext context) {
    final key = _formkey.currentState;
    if (key.validate()) {
      addInformation(context);
    }
  }

  addInformation(BuildContext context) async {
    await collectionReference.doc(titleController.text).set({
      'title': titleController.text,
      'description': descriptionController.text,
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Information added successfully!"),
        backgroundColor: Colors.greenAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Add Information",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(80.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: collectionReference.snapshots(),
              builder: (context, snapshot) {
                return Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            label: const Text("Title"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return ("This field must be filled");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        maxLines: 7,
                        decoration: InputDecoration(
                            label: const Text("Description"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return ("This field must be filled");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.blue[900],
                        child: MaterialButton(
                          minWidth: 180,
                          height: 80,
                          onPressed: () {
                            checkForm(context);
                          },
                          child: const Text(
                            "Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
