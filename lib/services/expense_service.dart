import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

/// Handles all Firestore CRUD operations for a single user's expenses.
/// Expenses are stored at: users/{uid}/expenses/{expenseId}
class ExpenseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;

  ExpenseService(this.uid);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection('users').doc(uid).collection('expenses');

  Stream<List<Expense>> watchExpenses() {
    return _collection.orderBy('date', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Expense.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addExpense(Expense expense) {
    return _collection.add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) {
    return _collection.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) {
    return _collection.doc(id).delete();
  }
}
