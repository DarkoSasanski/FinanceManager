import 'package:financemanager/models/results/ConversionResult.dart';
import 'package:financemanager/repositories/currency_conversion_repository.dart';
import 'package:flutter/material.dart';

import 'custom_action_button.dart';

class MakeAConversionAppBarButton extends StatefulWidget {
  final String actionButtonText;
  final List<String> currencies;
  final CurrencyConversionRepository currencyConversionRepository;

  const MakeAConversionAppBarButton(
      {super.key,
      required this.actionButtonText,
      required this.currencies,
      required this.currencyConversionRepository});

  @override
  State<MakeAConversionAppBarButton> createState() =>
      _MakeAConversionAppBarButtonState();
}

class _MakeAConversionAppBarButtonState
    extends State<MakeAConversionAppBarButton> {
  double result = 0;
  double amount = 0;
  final _formKey = GlobalKey<FormState>();

  void makeAConversion(String fromCurrency, String toCurrency, setState) async {
    if (fromCurrency == toCurrency) {
      setState(() {
        result = amount;
      });
      return;
    }
    try {
      ConversionResult result = await widget.currencyConversionRepository
          .getCurrencyConversionFromTo(
              amount: amount,
              fromCurrency: fromCurrency,
              toCurrency: toCurrency);

      setState(() {
        this.result = result.rates[0].rate;
      });
    } catch (e) {
      setState(() {
        result = 0;
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[350]),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[350]!)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent)),
    );
  }

  void _showMakeAConversionDialog() {
    String fromCurrency = 'USD';
    String toCurrency = 'EUR';

    setState(() {
      amount = 0;
      result = 0;
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Make a Conversion',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: fromCurrency,
                        icon: const Icon(Icons.arrow_downward,
                            color: Colors.white),
                        iconSize: 24,
                        elevation: 16,
                        decoration: _inputDecoration('From'),
                        onChanged: (String? newValue) {
                          setDialogState(() {
                            fromCurrency = newValue!;
                          });
                        },
                        items: widget.currencies
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a currency';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: toCurrency,
                        icon: const Icon(Icons.arrow_downward,
                            color: Colors.white),
                        iconSize: 24,
                        elevation: 16,
                        decoration: _inputDecoration('To'),
                        onChanged: (String? newValue) {
                          setDialogState(() {
                            toCurrency = newValue!;
                          });
                        },
                        items: widget.currencies
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a currency';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Amount'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setDialogState(() {
                            amount = double.parse(value);
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.parse(value) < 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            child: const Text('Convert',
                                style: TextStyle(color: Colors.tealAccent)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                makeAConversion(
                                    fromCurrency, toCurrency, setDialogState);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Result: $result $toCurrency',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionButton(
        actionButtonText: widget.actionButtonText,
        actionButtonOnPressed: _showMakeAConversionDialog,
        gradientColors: const [
          Color(0xFF00B686),
          Color(0xFF008A60),
          Color(0xff00573a),
        ]);
  }
}
