import 'package:financemanager/components/buttons/make_a_conversion_app_bar_button.dart';
import 'package:financemanager/models/results/ConversionResult.dart';
import 'package:financemanager/repositories/currency_conversion_repository.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/sideMenu/side_menu.dart';

class Currencies extends StatefulWidget {
  const Currencies({super.key});

  @override
  State<Currencies> createState() => _CurrenciesState();
}

class _CurrenciesState extends State<Currencies> {
  final CurrencyConversionRepository _currencyConversionRepository =
      CurrencyConversionRepository();
  ConversionResult? _currencyConversionResult;
  String _selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    ConversionResult result = await _currencyConversionRepository
        .getCurrencyConversionRates(fromCurrency: _selectedCurrency);

    setState(() {
      _currencyConversionResult = result;
    });
  }

  List<String> getCurrencies() {
    if (_currencyConversionResult == null) {
      return [];
    }

    List<String> currencies =
        _currencyConversionResult!.rates.map((rate) => rate.code).toList();
    currencies.insert(0, _currencyConversionResult!.base);
    return currencies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Currencies',
        appBarButton: MakeAConversionAppBarButton(
            actionButtonText: "Convert",
            currencies: getCurrencies(),
            currencyConversionRepository: _currencyConversionRepository),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: _currencyConversionResult == null
            ? const CircularProgressIndicator(
                color: Colors.grey, // Adjust the color to match your theme
              )
            : Column(
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        child: DropdownButton<String>(
                          value: _selectedCurrency,
                          items: getCurrencies()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _currencyConversionResult = null;
                              _selectedCurrency = value!;
                            });
                            _loadCurrencies();
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _currencyConversionResult!.rates.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                      itemBuilder: (context, index) {
                        final rate = _currencyConversionResult!.rates[index];
                        return ListTile(
                          tileColor: Colors.teal,
                          contentPadding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            rate.code,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            rate.rate.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
