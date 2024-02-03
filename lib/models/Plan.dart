import 'Account.dart';

class Plan {
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
}
