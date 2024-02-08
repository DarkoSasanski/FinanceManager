import 'Account.dart';
import 'Category.dart';

class Reminder {
  int id = 0;
  late String title;
  late int amount;
  DateTime date;
  late bool isComplete = false;
  late Category category;
  late Account account;

  Reminder(
      {required this.title,
      required this.amount,
      required this.date,
      required this.isComplete,
      required this.category});

  Reminder.withId(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.isComplete,
      required this.category});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder.withId(
        id: json['id'],
        title: json['title'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        isComplete: json['isComplete']=='1' ? true:false,
        category: Category.fromJson(json['category']));
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'isComplete': isComplete ? 1 : 0,
      'category_id': category.id
    };
  }
}
