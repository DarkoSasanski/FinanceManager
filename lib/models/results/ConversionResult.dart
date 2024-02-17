import '../Currency.dart';

class ConversionResult {
  final double amount;
  final String base;
  final DateTime date;
  final List<Currency> rates;

  ConversionResult(
      {required this.amount,
      required this.base,
      required this.date,
      required this.rates});

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    return ConversionResult(
        amount: json['amount'],
        base: json['base'],
        date: DateTime.parse(json['date']),
        rates: (json['rates'] as Map<String, dynamic>)
            .entries
            .map((e) =>
                Currency(code: e.key, rate: double.parse(e.value.toString())))
            .toList());
  }
}
