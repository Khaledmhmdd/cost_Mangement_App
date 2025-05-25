import 'package:flutter/material.dart';
import '../models/invoice_status.dart';
import '../services/invoice_status_service.dart';

class InvoiceStatusScreen extends StatefulWidget {
  @override
  _InvoiceStatusScreenState createState() => _InvoiceStatusScreenState();
}

class _InvoiceStatusScreenState extends State<InvoiceStatusScreen> {
  final InvoiceStatusService _statusService = InvoiceStatusService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Status Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddInvoiceDialog(),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _statusService.getInvoiceStatusesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final invoices = snapshot.data!;
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text('Invoice ID: ${invoice['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Client: ${invoice['clientName']}'),
                      Text('Amount: \$${invoice['amount']}'),
                      Text('Status: ${invoice['status'].toString().split('.').last}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showStatusUpdateDialog(invoice['id']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showStatusUpdateDialog(String invoiceId) async {
    final details = await _statusService.getInvoiceDetails(invoiceId);
    if (details == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Status'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<InvoiceStatus>(
                value: details['status'] as InvoiceStatus,
                items: InvoiceStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (newStatus) async {
                  if (newStatus != null) {
                    await _statusService.updateInvoiceStatus(
                      invoiceId,
                      newStatus,
                      amount: details['amount'],
                      clientName: details['clientName'],
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddInvoiceDialog() {
    final formKey = GlobalKey<FormState>();
    String clientName = '';
    double amount = 0;
    InvoiceStatus status = InvoiceStatus.pending;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Invoice'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Client Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => clientName = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid amount' : null,
                onSaved: (value) => amount = double.parse(value ?? '0'),
              ),
              DropdownButtonFormField<InvoiceStatus>(
                value: status,
                items: InvoiceStatus.values.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.toString().split('.').last),
                )).toList(),
                onChanged: (value) => status = value ?? InvoiceStatus.pending,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                await _statusService.createInvoiceStatus(
                  DateTime.now().millisecondsSinceEpoch.toString(),
                  status: status,
                  amount: amount,
                  clientName: clientName,
                );
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
