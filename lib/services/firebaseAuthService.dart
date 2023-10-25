import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fincon_app/models/user_complement.dart';
import 'package:fincon_app/services/firestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  var instanceFB = FirebaseAuth.instance;
  var serviceFirestore = FirestoreService();

  getInstance() {
    return instanceFB;
  }

  //create account with e-mail and password
  Future<void> createAccountWithEmailAndPwd(
      name, income, email, password) async {
    print("Register");
    final credential = await instanceFB.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (instanceFB.currentUser != null) {
      var user = UserComplement(name, income, instanceFB.currentUser!.uid);
      serviceFirestore.createUser(user);
    }
  }

  //Login with e-mail and password
  Future<void> loginWithEmailAndPassword(email, password) async {
    final credential = await instanceFB.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //Logout
  Future<void> logout() async {
    await instanceFB.signOut();
  }
}
