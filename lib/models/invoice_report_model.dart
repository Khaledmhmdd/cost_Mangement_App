import 'invoice_status.dart';

class InvoiceReportFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final InvoiceStatus? status;
  final String? clientId;

  InvoiceReportFilter({
    this.startDate,
    this.endDate,
    this.status,
    this.clientId,
  });
}

class InvoiceReportItem {
  final String invoiceId;
  final double amount;
  final DateTime date;
  final InvoiceStatus status;
  final String clientId;

  InvoiceReportItem({
    required this.invoiceId,
    required this.amount,
    required this.date,
    required this.status,
    required this.clientId,
  });
}
