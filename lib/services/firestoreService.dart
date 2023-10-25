import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fincon_app/models/user_complement.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //get collection of users
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");

  //get collection of categories
  final CollectionReference _categories =
      FirebaseFirestore.instance.collection("categories");

  //Add new category
  Future<void> addCategory(String categoryName) {
    return _categories.add({"category_name": categoryName});
  }

  //Get category from database
  Stream<QuerySnapshot> getCategoryStream() {
    final categoriesStream =
        _categories.orderBy('category_name', descending: false).snapshots();
    return categoriesStream;
  }

  //Update category
  Future<void> updateCategory(String docID, String newName) {
    return _categories.doc(docID).update({
      "category_name": newName,
    });
  }

  //Delete category
  Future<void> deleteCategory(String docID) {
    return _categories.doc(docID).delete();
  }

  //create a new user
  Future<void> createUser(UserComplement user) {
    return _users.add(user.toJson());
  }

  //Get user from database
  Stream<QuerySnapshot> getUserStreamById(String uid) {
    final userStream = _users.where('uid', isEqualTo: uid).snapshots();
    return userStream;
  }

  //Update category
  Future<void> updateUser(String docID, UserComplement user) {
    return _categories.doc(docID).update(user.toJson());
  }

  //Delete category
  Future<void> deleteUser(String docID) {
    return _users.doc(docID).delete();
  }
}
