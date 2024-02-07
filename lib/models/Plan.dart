import 'Account.dart';

class Plan {
  int id = 0;
  late String type;
  late int goalAmount;
  late int currentAmount = 0;
  DateTime dateStart;
  DateTime dateEnd;
  late Account account;

  Plan(
      {required this.type,
      required this.goalAmount,
      required this.dateStart,
      required this.dateEnd});

  Plan.withId(
      {required this.id,
      required this.type,
      required this.goalAmount,
      required this.dateStart,
      required this.dateEnd});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan.withId(
        id: json['id'],
        type: json['type'],
        goalAmount: json['goalAmount'],
        dateStart: DateTime.parse(json['dateStart']),
        dateEnd: DateTime.parse(json['dateEnd']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'goalAmount': goalAmount,
      'currentAmount': currentAmount,
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String()
    };
  }
}
