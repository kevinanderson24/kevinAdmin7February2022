import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUser extends StatefulWidget {
  const AddUser({key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formkey = GlobalKey<FormState>(); //formkey
  final TextEditingController nameController =
      TextEditingController(); //controller
  final TextEditingController emailController =
      TextEditingController(); //controller
  final TextEditingController passwordController =
      TextEditingController(); //controller
  final TextEditingController confirmPasswordController =
      TextEditingController(); //controller
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          "Add User",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(-5, 0),
                blurRadius: 15,
                spreadRadius: 3)
          ]),
          width: double.infinity,
          height: 300,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 240,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //FORM "NAME"
                      TextFormField(
                        autofocus:
                            false, //KALO DI ON dia bakal langsung di colomnya
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.poppins(),
                        textInputAction: TextInputAction
                            .next, //kalo tekan "ENTER" dia bakal next kebawah
                        decoration: const InputDecoration(hintText: "Name"),
                        validator: (value) {
                          RegExp regex =
                              new RegExp(r'^.{3,}$'); //Minimal 3 characters

                          if (value.isEmpty) {
                            return ("Name is required");
                          }

                          if (!regex.hasMatch(value)) {
                            return ("Enter valid first name(Min. 3 Characters)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          nameController.text = value;
                        },
                      ),
                      //-----------------------------------------------------//

                      //FORM "EMAIL"
                      TextFormField(
                        autofocus:
                            false, //KALO DI ON dia bakal langsung di colomnya
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(),
                        textInputAction: TextInputAction
                            .next, //kalo tekan "ENTER" dia bakal next kebawah
                        decoration: InputDecoration(hintText: "Email"),
                        validator: (value) {
                          RegExp regex = new RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"); //harus ada @, . , alphabet setelah titik

                          if (value.isEmpty) {
                            return ("Email is required");
                          }

                          if (!regex.hasMatch(value)) {
                            return ("Please Enter a valid Email");
                          }

                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value;
                        },
                      ),
                      //-----------------------------------------------------------------//

                      TextFormField(
                        autofocus:
                            false, //KALO DI ON dia bakal langsung di colomnya
                        controller: passwordController,
                        obscureText:
                            true, //ngehidden tulisan kita ketik jadi .....
                        textInputAction: TextInputAction
                            .next, //kalo tekan "ENTER" dia bakal next kebawah
                        decoration: const InputDecoration(hintText: "Password"),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');

                          if (value.isEmpty) {
                            return ("Password is required");
                          }

                          if (!regex.hasMatch(value)) {
                            return ("Enter valid password(Min. 6 Characters)");
                          }

                          return null;
                        },
                        onSaved: (value) {
                          passwordController.text = value;
                        },
                      ),
                      TextFormField(
                        autofocus:
                            false, //KALO DI ON dia bakal langsung di colomnya
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (passwordController.text != value) {
                            return ("Password don't match !");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          confirmPasswordController.text = value;
                        },
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(hintText: "Confirm Password"),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 250,
                width: 210,
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: MaterialButton(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.blue[900],
                  child: Text(
                    "Add User",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    final key = _formkey.currentState;
                    if (key.validate()) {
                      try {
                        //daftar akun user ke "Authentication"
                        UserCredential result =
                            await _firebaseAuth.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        User user = result.user;
                        //------------------------------//

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(user.uid)
                            .set({
                          'uid': user.uid,
                          'email': emailController.text,
                          'name': nameController.text,
                          'password': passwordController.text,
                          'createdAt': Timestamp.now()
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Account created successfully!"),
                                backgroundColor: Colors.greenAccent));
                      } on Exception catch (e) {
                        // TODO
                        print(e.toString());
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please! Make sure theres no error.",
                          textColor: Colors.red);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
