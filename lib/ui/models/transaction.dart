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
  String transactionId;
  String friendDebtId;
  double shareOfPayer;
  double shareOfBorrower;
  String paidBy;
  double amount;
  DateTime transactionDate;
  String remark;

  BillSplitTransaction({
    required this.shareOfBorrower,
    required this.shareOfPayer,
    required this.paidBy,
    required this.amount,
    required this.remark,
    required this.friendDebtId,
    required this.transactionId,
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

class GroupTransaction {
  String groupId;
  Map<String, Map<String, double>> participants; // userId, userName, amount
  double totalAmount;
  String transactionId;
  String paidById;

  String remark;
  DateTime date;
  String paidByName;

  GroupTransaction({
    required this.groupId,
    required this.participants,
    required this.transactionId,
    required this.totalAmount,
    required this.paidById,
    required this.remark,
    required this.date,
    required this.paidByName,
  });
}
