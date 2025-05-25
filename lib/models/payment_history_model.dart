import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryEntry {
  final String invoiceId;
  final double amount;
  final String paymentMethod;
  final DateTime paymentDate;
  final String transactionId;

  PaymentHistoryEntry({
    required this.invoiceId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate.toIso8601String(),
      'transactionId': transactionId,
    };
  }
}

class PaymentHistoryModel {
  final String id;
  final String invoiceId;
  final double amount;
  final String paymentMethod;
  final DateTime paymentDate;

  PaymentHistoryModel({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentDate': Timestamp.fromDate(paymentDate),
    };
  }

  // Create from Firestore data
  factory PaymentHistoryModel.fromMap(Map<String, dynamic> map) {
    return PaymentHistoryModel(
      id: map['id'] ?? '',
      invoiceId: map['invoiceId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      paymentDate: (map['paymentDate'] as Timestamp).toDate(),
    );
  }
}
