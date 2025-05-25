import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/payment_history_service.dart';
import '../models/payment_history_model.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final PaymentHistoryService _paymentService = PaymentHistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment History Log')),
      body: StreamBuilder<List<PaymentHistoryModel>>(
        stream: _paymentService.getPaymentsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final payments = snapshot.data ?? [];

          if (payments.isEmpty) {
            return Center(child: Text('No payment records found'));
          }

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              return ListTile(
                title: Text('Invoice: ${payment.invoiceId}'),
                subtitle: Text(
                  'Amount: \$${payment.amount.toStringAsFixed(2)}\n'
                  'Method: ${payment.paymentMethod}\n'
                  'Date: ${payment.paymentDate.toString().split('.')[0]}',
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
