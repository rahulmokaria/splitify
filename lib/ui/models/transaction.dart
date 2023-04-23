class UserTransaction {
  UserTransaction({
    required this.amount,
    required this.remark,
    required this.category,
    required this.balance,
    required this.transactionDate,
  });
  String remark;
  String category;
  double balance;
  DateTime transactionDate;
  double amount;

  static UserTransaction fromJson(Map<String, dynamic> json) => UserTransaction(
        amount: json['amount'],
        balance: json['balance'],
        category: json['category'],
        remark: json['remark'],
        transactionDate: (json['date']).toDate(),
      );
}
