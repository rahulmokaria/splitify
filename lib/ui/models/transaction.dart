class UserTransaction {
  UserTransaction({
    required this.amount,
    required this.remark,
    required this.category,
    required this.transactionId,
    required this.transactionDate,
  });
  String transactionId;
  String remark;
  String category;
  DateTime transactionDate;
  double amount;

  static UserTransaction fromJson(Map<String, dynamic> json) => UserTransaction(
        amount: json['amount'],
        category: json['category'],
        remark: json['remark'],
        transactionDate: (json['date']).toDate(),
        transactionId: '',
      );
}
