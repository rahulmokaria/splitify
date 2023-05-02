class UserTransaction {
  UserTransaction({
    required this.amount,
    required this.remark,
    required this.category,
    required this.transactionId,
    required this.transactionDate,
  });
  // String user1ID;
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

class BillSplitTransaction {
  String id;
  double userShare;
  double friendShare;
  String paidBy;
  double amount;
  DateTime transactionDate;
  String remark;

  BillSplitTransaction({
    required this.friendShare,
    required this.userShare,
    required this.paidBy,
    required this.amount,
    required this.remark,
    required this.id,
    required this.transactionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'transactionDate': transactionDate,
      'remark': remark,
    };
  }
}
