import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class UpdateProduct extends StatefulWidget {
  final Product value;
  const UpdateProduct({ Key key, this.value}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<UpdateProduct> {
  final _formkey = GlobalKey<FormState>();//formkey
  File image;
  final imagePicker = ImagePicker();
  String currentUrl;
  String newURL;
  String fileName;
  CollectionReference products = Firestore.instance.collection('product');
  Product productModel;

  TextEditingController _nameProductController;
  TextEditingController _priceProductController;
  TextEditingController _descriptionProductController;
  TextEditingController _idProductController;//controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idProductController = TextEditingController(text: "${widget.value.id}");
    _nameProductController = TextEditingController(text: "${widget.value.name}");
    _priceProductController = TextEditingController(text: "${widget.value.price}");
    _descriptionProductController = TextEditingController(text: "${widget.value.description}");
    currentUrl = "${widget.value.url}";
  }

  checkForm(BuildContext context) async {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      if(newURL == null){
        updateDataWithoutImageChanges(context);
      }
      uploadImageToFirebaseStorage(context);
    }else{
      Fluttertoast.showToast(
        msg: "Please fill form field correctly! Make sure there's no error",
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,       
      );
    }
  }

  //ambil gambar dari gallery
  pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(pick.path);
    });
  }

  //uploading the image to "Storage" in Firebase, then getting the download url and then
  //adding that download url to our "Firestore database" in Firebase
  uploadImageToFirebaseStorage(BuildContext context) async {
    fileName = basename(image.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('product/$fileName');
    StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    newURL = await snapshot.ref.getDownloadURL();
    updateDataWithImageChanges(context);
    print(newURL);
  }


  updateDataWithoutImageChanges(BuildContext context) async {
    products.document(_idProductController.text).updateData({
      'name': _nameProductController.text,
      'price': int.parse(_priceProductController.text),
      'description': _descriptionProductController.text,
    });
    setState(() {
      newURL = null;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product updated successfully!"), backgroundColor: Colors.greenAccent));
  }

  updateDataWithImageChanges(BuildContext context) async {
    products.document(_idProductController.text).updateData({
      'name': _nameProductController.text,
      'price': int.parse(_priceProductController.text),
      'description': _descriptionProductController.text,
      'url': newURL,
    });
    setState(() {
      newURL = null;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product updated successfully!"), backgroundColor: Colors.greenAccent));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Update Product", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Column(
              children: [
                Container(
                  height: 300.0,
                  child: InkWell(
                    onTap: () {
                      //KETIKA GAMBAR DIKLIK
                      pickImage();
                    },
                    child:
                      (image != null)
                      ? Image.file(
                        image,
                        fit: BoxFit.cover,

                      )
                      : Image.network(currentUrl)
                  )
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _idProductController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text('Product Id'),
                  ),
                  // validator: (value) {
                  //   if(value.isEmpty){
                  //     return ("Id cannot be empty");
                  //   }
                  //   return null;
                  // },
                  readOnly: true,
                  onSaved: (newValue) => _idProductController.text = newValue,
                ),
                TextFormField(
                  controller: _nameProductController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text('Product Name'),
                  ),
                  validator: (value) {
                    if (value.isEmpty){
                      return ("This field must be filled");
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _nameProductController.text = newValue;
                  },
                ),
                TextFormField(
                  controller: _priceProductController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text('Product Price'),
                  ),
                  validator: (value) {
                    if(value.isEmpty){
                      return ("This field must be filled");
                    }
                    return null;
                  },
                  onSaved: (newValue) => _priceProductController.text = newValue,
                ),
                TextFormField(
                  controller: _descriptionProductController,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    label: Text('Product Desciption'),
                  ),
                  validator: (value) {
                    if(value.isEmpty){
                      return ("This field must be filled");
                    }
                  },
                  onSaved: (newValue) => _descriptionProductController.text = newValue,
                ),
                SizedBox(
                  height: 20,
                ),
                Material(
                  elevation: 30,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[900],
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      checkForm(context);
                    },   
                    child: const Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}