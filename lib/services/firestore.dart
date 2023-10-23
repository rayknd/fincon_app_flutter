import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
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
}
