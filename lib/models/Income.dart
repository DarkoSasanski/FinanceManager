import 'Account.dart';

class Income {
  int id = 0;
  String source;
  String description;
  int amount;
  DateTime date;
  Account account;
  bool isReceived;

  Income(
      {required this.source,
      required this.description,
      required this.amount,
      required this.date,
      required this.account,
      required this.isReceived});

  Income.withId(
      {required this.id,
      required this.source,
      required this.description,
      required this.amount,
      required this.date,
      required this.account,
      required this.isReceived});

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income.withId(
        id: json['id'],
        source: json['source'],
        description: json['description'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        account: Account.fromJson(json['account']),
        isReceived: json['isReceived']);
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'account_id': account.id,
      'isReceived': isReceived,
    };
  }
}
