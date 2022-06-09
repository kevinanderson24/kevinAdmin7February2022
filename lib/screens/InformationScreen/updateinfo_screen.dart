import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/info_model.dart';
import 'package:flutter/material.dart';

class UpdateInformation extends StatefulWidget {
  final Information value;
  const UpdateInformation({Key key, this.value}) : super(key: key);

  @override
  _UpdateInformationState createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {
  final _formkey = GlobalKey<FormState>();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('information');
  TextEditingController titleController; //controller //controller
  TextEditingController descriptionController; //controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController(text: "${widget.value.title}");
    descriptionController =
        TextEditingController(text: "${widget.value.description}");
  }

  checkForm(BuildContext context) {
    final key = _formkey.currentState;
    if (key.validate()) {
      key.save();
      updateInformation(context);
    }
  }

  updateInformation(BuildContext context) async {
    await collectionReference.doc(titleController.text).update({
      'description': descriptionController.text,
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Information updated successfully!"),
        backgroundColor: Colors.greenAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Update Information",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(80.0),
          child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      label: Text("Title"),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.0)))),
                  readOnly: true,
                  onSaved: (newValue) => titleController.text = newValue,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLines: 7,
                  decoration: const InputDecoration(
                      label: Text("Description"),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.0)))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return ("This field must be filled");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50.0),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.purpleAccent,
                  child: MaterialButton(
                    minWidth: 200,
                    height: 80,
                    onPressed: () {
                      checkForm(context);
                    },
                    child: const Text(
                      "Update",
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
          ),
        ),
      ),
    );
  }
}
