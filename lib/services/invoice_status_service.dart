import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invoice_status.dart';

class InvoiceStatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'invoice_statuses';

  // Get status stream for real-time updates
  Stream<List<Map<String, dynamic>>> getInvoiceStatusesStream() {
    return _firestore.collection(_collection)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {
              'id': doc.id,
              'status': InvoiceStatus.values.firstWhere(
                (e) => e.toString() == 'InvoiceStatus.${doc['status']}'),
              'lastUpdated': (doc['lastUpdated'] as Timestamp).toDate(),
              'amount': doc['amount'] ?? 0.0,
              'clientName': doc['clientName'] ?? '',
            }).toList());
  }

  // Update invoice status
  Future<void> updateInvoiceStatus(String invoiceId, InvoiceStatus status, {double? amount, String? clientName}) async {
    final data = {
      'status': status.toString().split('.').last,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
    
    if (amount != null) data['amount'] = amount;
    if (clientName != null) data['clientName'] = clientName;

    await _firestore.collection(_collection).doc(invoiceId).set(
      data,
      SetOptions(merge: true)
    );
  }

  // Create new invoice status
  Future<void> createInvoiceStatus(String invoiceId, {
    required InvoiceStatus status,
    required double amount,
    required String clientName,
  }) async {
    await _firestore.collection(_collection).doc(invoiceId).set({
      'status': status.toString().split('.').last,
      'amount': amount,
      'clientName': clientName,
      'lastUpdated': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get detailed invoice information
  Future<Map<String, dynamic>?> getInvoiceDetails(String invoiceId) async {
    final doc = await _firestore.collection(_collection).doc(invoiceId).get();
    if (!doc.exists) return null;
    
    return {
      'id': doc.id,
      'status': InvoiceStatus.values.firstWhere(
        (e) => e.toString() == 'InvoiceStatus.${doc['status']}'),
      'amount': doc['amount'] ?? 0.0,
      'clientName': doc['clientName'] ?? '',
      'lastUpdated': (doc['lastUpdated'] as Timestamp).toDate(),
    };
  }
}
