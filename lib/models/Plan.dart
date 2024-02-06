import 'Account.dart';

class Plan {
  int id = 0;
  late String type;
  late int amount;
  DateTime dateStart;
  DateTime dateEnd;
  Account account;

  Plan(
      {required this.type,
      required this.amount,
      required this.dateStart,
      required this.dateEnd,
      required this.account});

  Plan.withId(
      {required this.id,
      required this.type,
      required this.amount,
      required this.dateStart,
      required this.dateEnd,
      required this.account});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan.withId(
        id: json['id'],
        type: json['type'],
        amount: json['amount'],
        dateStart: DateTime.parse(json['dateStart']),
        dateEnd: DateTime.parse(json['dateEnd']),
        account: Account.fromJson(json['account']));
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'account_id': account.id,
    };
  }
}
