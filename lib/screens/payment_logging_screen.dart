import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentLoggingScreen extends StatefulWidget {
  @override
  _PaymentLoggingScreenState createState() => _PaymentLoggingScreenState();
}

class _PaymentLoggingScreenState extends State<PaymentLoggingScreen> {
  final _formKey = GlobalKey<FormState>();
  String invoiceId = '';
  String amount = '';
  String paymentMethod = 'Cash';

  void logPayment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await FirebaseFirestore.instance.collection('payments').add({
          'invoiceId': invoiceId.trim(),
          'amount': double.parse(amount),
          'paymentMethod': paymentMethod,
          'paymentDate': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment logged successfully')),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Logging')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Invoice ID'),
                    validator: (value) => value!.isEmpty ? 'Enter invoice ID' : null,
                    onSaved: (value) => invoiceId = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Payment Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || double.tryParse(value) == null
                        ? 'Enter valid amount'
                        : null,
                    onSaved: (value) => amount = value!,
                  ),
                  DropdownButtonFormField<String>(
                    value: paymentMethod,
                    decoration: InputDecoration(labelText: 'Payment Method'),
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                    items: ['Cash', 'Credit'].map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: logPayment,
                    child: Text('Log Payment'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('payments')
                    .orderBy('paymentDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text('Invoice: ${data['invoiceId']}'),
                        subtitle: Text('Amount: ${data['amount']} - Method: ${data['paymentMethod']}'),
                        trailing: Text((data['paymentDate'] as Timestamp).toDate().toString().split('.')[0]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
