import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invoice_report_model.dart';
import '../models/invoice_status.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<InvoiceReportItem>> fetchInvoices(InvoiceReportFilter filter) async {
    Query<Map<String, dynamic>> query = _firestore.collection('payments');

    if (filter.clientId != null) {
      query = query.where('clientName', isEqualTo: filter.clientId);
    }
    if (filter.status != null) {
      query = query.where('status', isEqualTo: filter.status.toString().split('.').last);
    }
    if (filter.startDate != null) {
      query = query.where('paymentDate', isGreaterThanOrEqualTo: filter.startDate);
    }
    if (filter.endDate != null) {
      query = query.where('paymentDate', isLessThanOrEqualTo: filter.endDate);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => InvoiceReportItem(
      invoiceId: doc.id,
      amount: (doc.data()['amount'] ?? 0).toDouble(),
      date: (doc.data()['paymentDate'] as Timestamp).toDate(),
      status: InvoiceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == doc.data()['status'],
        orElse: () => InvoiceStatus.pending,
      ),
      clientId: doc.data()['clientName'],
    )).toList();
  }

  Future<Map<String, dynamic>> fetchInvoiceAndPaymentsSummary() async {
    final paymentSnapshot = await _firestore.collection('payments').get();

    double totalInvoices = 0;
    double totalPayments = 0;

    for (var doc in paymentSnapshot.docs) {
      totalInvoices += (doc.data()['amount'] ?? 0).toDouble();
      if (doc.data()['status'] == 'paid') {
        totalPayments += (doc.data()['amount'] ?? 0).toDouble();
      }
    }

    return {
      'totalInvoices': totalInvoices,
      'totalPayments': totalPayments,
      'balance': totalInvoices - totalPayments,
    };
  }
}
