import 'dart:convert';

import 'package:financemanager/models/results/ConversionResult.dart';
import 'package:http/http.dart' as http;

class CurrencyConversionRepository {
  final String _baseUrl = 'https://api.frankfurter.app/latest';

  Future<ConversionResult> getCurrencyConversionFromTo(
      {required double amount,
      required String fromCurrency,
      required String toCurrency}) async {
    String url = '$_baseUrl?amount=$amount&from=$fromCurrency&to=$toCurrency';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return ConversionResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load conversion result');
    }
  }

  Future<ConversionResult> getCurrencyConversionRates(
      {required String fromCurrency}) async {
    String url = '$_baseUrl?from=$fromCurrency';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return ConversionResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load conversion result');
    }
  }
}
