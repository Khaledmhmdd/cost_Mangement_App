import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../models/receipt_model.dart';
import '../services/receipt_generator.dart';

class ReceiptGeneratorScreen extends StatefulWidget {
  @override
  _ReceiptGeneratorScreenState createState() => _ReceiptGeneratorScreenState();
}

class _ReceiptGeneratorScreenState extends State<ReceiptGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _generator = ReceiptGenerator();
  String invoiceId = '';
  String customerName = '';
  double amount = 0;
  String paymentMethod = 'Cash';

  Future<void> _generateReceipt() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final receipt = Receipt(
        invoiceId: invoiceId,
        amount: amount,
        paymentMethod: paymentMethod,
        paymentDate: DateTime.now(),
        customerName: customerName,
        receiptNumber: 'RCP${DateTime.now().millisecondsSinceEpoch}',
      );

      try {
        final file = await _generator.generateReceipt(receipt);
        await OpenFile.open(file.path);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating receipt: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Receipt Generator')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Invoice ID'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => invoiceId = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => customerName = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => amount = double.parse(v!),
              ),
              DropdownButtonFormField<String>(
                value: paymentMethod,
                decoration: InputDecoration(labelText: 'Payment Method'),
                items: ['Cash', 'Credit Card', 'Bank Transfer']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => paymentMethod = v!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateReceipt,
                child: Text('Generate Receipt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
