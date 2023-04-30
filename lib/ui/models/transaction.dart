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
  String fromFriend;
  String toFriend;
  double amount;
  DateTime transactionDate;
  String remark;

  BillSplitTransaction({
    required this.fromFriend,
    required this.toFriend,
    required this.amount,
    required this.remark,
    required this.id,
    required this.transactionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromFriend': fromFriend,
      'toFriend': toFriend,
      'amount': amount,
      'transactionDate': transactionDate,
      'remark': remark,
    };
  }

  BillSplitTransaction.fromMap(Map<String, dynamic> map, {required this.id})
      : fromFriend = map['fromFriend'],
        toFriend = map['toFriend'],
        amount = map['amount'],
        transactionDate = map['transactionDate'],
        remark = map['remark'];

  void printTransaction() {
    print(
        "$fromFriend paid $amount to $toFriend on $transactionDate with remark: $remark.");
  }
}
