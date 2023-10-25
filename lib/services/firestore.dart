import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fincon_app/models/fixed_expenses.dart';

class FirestoreService {
  //get collection of categories
  final CollectionReference _categories =
      FirebaseFirestore.instance.collection("categories");
  final CollectionReference _expenses =
      FirebaseFirestore.instance.collection("expenses");

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

  Future<void> addExpense(Expense expense) {
    return _expenses.add(expense.toJson());
  }


  Stream<QuerySnapshot> getExpenseStream() {
    final expensesStream =
        _expenses.where('expense_dtmExclusion', isNull: true).snapshots();
    return expensesStream;
  }

  //Update category
  Future<void> updateExpense(String docID, Expense newExpense) {
    return _expenses.doc(docID).update(newExpense.toJson());
  }

  //Delete category
  Future<void> deleteExpense(String docID) {
    return _expenses.doc(docID).update({
      "expense_dtmExclusion":  DateTime.now(),
    });
  }
}
