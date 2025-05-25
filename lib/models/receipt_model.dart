class Receipt {
  final String invoiceId;
  final double amount;
  final String paymentMethod;
  final DateTime paymentDate;
  final String customerName;
  final String receiptNumber;

  Receipt({
    required this.invoiceId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.customerName,
    required this.receiptNumber,
  });
}
