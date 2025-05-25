import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invoice_report_model.dart';
import '../models/invoice_status.dart';

class InvoiceReportService {
  static final InvoiceReportService _instance = InvoiceReportService._internal();
  factory InvoiceReportService() => _instance;
  InvoiceReportService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<InvoiceReportItem>> generateReport(InvoiceReportFilter filter) async {
  Query<Map<String, dynamic>> query = _firestore.collection('invoice_statuses');

  if (filter.startDate != null) {
    query = query.where('lastUpdated', isGreaterThanOrEqualTo: filter.startDate);
  }
  if (filter.endDate != null) {
    query = query.where('lastUpdated', isLessThanOrEqualTo: filter.endDate);
  }
  if (filter.status != null) {
    query = query.where('status', isEqualTo: filter.status.toString().split('.').last);
  }
  if (filter.clientId != null) {
    query = query.where('clientName', isEqualTo: filter.clientId); 
  }

  final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

  return querySnapshot.docs.map((doc) {
    final data = doc.data();
    return InvoiceReportItem(
      invoiceId: doc.id,
      amount: (data['amount'] ?? 0.0).toDouble(),
      date: (data['lastUpdated'] as Timestamp).toDate(),
      status: InvoiceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => InvoiceStatus.pending,
      ),
      clientId: data['clientId'] ?? '',
    );
  }).toList();
}


  Map<InvoiceStatus, double> getStatusSummary(List<InvoiceReportItem> reports) {
    final summary = <InvoiceStatus, double>{};
    for (var report in reports) {
      summary[report.status] = (summary[report.status] ?? 0) + report.amount;
    }
    return summary;
  }
}
