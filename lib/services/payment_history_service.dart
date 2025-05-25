import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_history_model.dart';

class PaymentHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'payments';

  // Get all payments
  Stream<List<PaymentHistoryModel>> getPaymentsStream() {
    return _firestore.collection(_collection)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentHistoryModel.fromMap(doc.data()))
            .toList());
  }

  // Add new payment
  Future<void> addPayment(PaymentHistoryModel payment) async {
    await _firestore.collection(_collection).add(payment.toMap());
  }

  // Delete payment
  Future<void> deletePayment(String paymentId) async {
    await _firestore.collection(_collection).doc(paymentId).delete();
  }
}
