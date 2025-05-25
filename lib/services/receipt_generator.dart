import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/receipt_model.dart';

class ReceiptGenerator {
  Future<File> generateReceipt(Receipt receipt) async {
    try {
      if (receipt.amount <= 0) {
        throw Exception('Invalid receipt amount');
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Payment Receipt',
                      style: pw.TextStyle(fontSize: 24)),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Receipt Number: ${receipt.receiptNumber}'),
                pw.Text('Date: ${receipt.paymentDate.toString().split(' ')[0]}'),
                pw.SizedBox(height: 20),
                pw.Text('Customer: ${receipt.customerName}'),
                pw.Text('Invoice ID: ${receipt.invoiceId}'),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Payment Method:'),
                    pw.Text(receipt.paymentMethod),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Amount Paid:'),
                    pw.Text('\$${receipt.amount.toStringAsFixed(2)}'),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 40),
                pw.Text('Thank you for your payment!'),
              ],
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/receipt_${receipt.receiptNumber}.pdf');

      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      print('Error generating receipt: $e');
      throw Exception('Failed to generate receipt: $e');
    }
  }
}
