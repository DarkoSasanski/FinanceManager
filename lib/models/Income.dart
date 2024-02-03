import 'Account.dart';
import 'Category.dart';

class Income {
  String source;
  String description;
  int amount;
  DateTime date;
  Account account;
  Category category;

  Income(
      {required this.source,
      required this.description,
      required this.amount,
      required this.date,
      required this.account,
      required this.category});
}
