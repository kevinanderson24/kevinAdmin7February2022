import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // static Future<FirebaseUser> signUp(String email, String password) async {
  //   try {
  //     AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  //     FirebaseUser user = result.user;
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     Fluttertoast.showToast(msg: e.toString());
  //     return null;
  //   }
  // }

  Future deleteUser(String email, password) async {
    try {
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      // print(user);
      UserCredential result =
          await _firebaseAuth.signInWithCredential(credentials);
      await result.user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
