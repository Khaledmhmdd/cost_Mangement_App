import 'package:flutter/material.dart';
import '../services/invoice_report_service.dart';
import '../models/invoice_report_model.dart';
import '../models/invoice_status.dart';
import '../services/firebase_service.dart';

class SummaryReportScreen extends StatefulWidget {
  @override
  _SummaryReportScreenState createState() => _SummaryReportScreenState();
}

class _SummaryReportScreenState extends State<SummaryReportScreen> {
  final _reportService = InvoiceReportService();
  final _firebaseService = FirebaseService();

  List<InvoiceReportItem>? _reports;
  Map<String, dynamic>? _totals;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
    _loadTotals();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    _reports = await _reportService.generateReport(InvoiceReportFilter());
    setState(() => _isLoading = false);
  }

  Future<void> _loadTotals() async {
    final result = await _firebaseService.fetchInvoiceAndPaymentsSummary();
    setState(() {
      _totals = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _totals == null || _reports == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Invoice Summary Report')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final statusSummary = _reportService.getStatusSummary(_reports!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Summary Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadReports();
              _loadTotals();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          _buildTotalCard(),
          SizedBox(height: 8),
          _buildStatusSummaryCards(statusSummary),
          Divider(),
          Expanded(
            child: _reports!.isEmpty
                ? Center(child: Text('No invoices found.'))
                : ListView.builder(
                    itemCount: _reports!.length,
                    itemBuilder: (context, index) {
                      final item = _reports![index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.receipt),
                          title: Text('Invoice: ${item.invoiceId}'),
                          subtitle: Text(
                            'Amount: \$${item.amount.toStringAsFixed(2)}\n'
                            'Status: ${item.status.toString().split('.').last}',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCard('Total Invoices', _totals!['totalInvoices']),
        SizedBox(width: 10),
        _buildCard('Outstanding', _totals!['balance']),
      ],
    );
  }

  Widget _buildCard(String label, double value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('\$${value.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, color: Colors.green[800])),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSummaryCards(Map<InvoiceStatus, double> summary) {
    return Container(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: summary.entries.map((entry) {
          return Card(
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(entry.key.toString().split('.').last,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  Text('\$${entry.value.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.blueGrey)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
