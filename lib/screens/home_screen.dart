import 'package:flutter/material.dart';
import 'payment_logging_screen.dart';
import 'receipt_generator_screen.dart';
import 'invoice_status_screen.dart';
import 'payment_history_screen.dart';
import 'summary_report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            'Payment Logging',
            'Log new payments',
            Icons.payment,
            () => Navigator.push(context, 
              MaterialPageRoute(builder: (_) => PaymentLoggingScreen())),
          ),
          _buildMenuCard(
            context,
            'Generate Payment Receipt',
            'Create payment receipts',
            Icons.receipt,
            () => Navigator.push(context, 
              MaterialPageRoute(builder: (_) => ReceiptGeneratorScreen())),
          ),
          _buildMenuCard(
            context,
            'Invoice Status Tracker',
            'Track invoice statuses',
            Icons.track_changes,
            () => Navigator.push(context, 
              MaterialPageRoute(builder: (_) => InvoiceStatusScreen())),
          ),
          _buildMenuCard(
            context,
            'Payment History',
            'View payment records',
            Icons.history,
            () => Navigator.push(context, 
              MaterialPageRoute(builder: (_) => PaymentHistoryScreen())),
          ),
          _buildMenuCard(
            context,
            'Invoice Summary Report',
            'Generate reports',
            Icons.summarize,
            () => Navigator.push(context, 
              MaterialPageRoute(builder: (_) => SummaryReportScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, 
    IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
