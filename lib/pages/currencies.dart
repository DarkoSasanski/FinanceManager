import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:financemanager/components/buttons/make_a_conversion_app_bar_button.dart';
import 'package:financemanager/models/results/ConversionResult.dart';
import 'package:financemanager/repositories/currency_conversion_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _loadCurrencies();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Couldn\'t check connectivity status: $e');
      }
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> _loadCurrencies() async {
    try {
      ConversionResult result = await _currencyConversionRepository
          .getCurrencyConversionRates(fromCurrency: _selectedCurrency);
      setState(() {
        _currencyConversionResult = result;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load conversion result: $e');
      }
    }
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
    if (_connectionStatus == ConnectivityResult.none) {
      return const Scaffold(
        appBar: CustomAppBar(
          title: 'Currencies',
        ),
        drawer: SideMenu(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              Text(
                'No internet connection, please try again later.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Currencies',
        appBarButton: MakeAConversionAppBarButton(
            actionButtonText: "Convert",
            currencies: getCurrencies(),
            currencyConversionRepository: _currencyConversionRepository),
      ),
      drawer: const SideMenu(),
      body: _currencyConversionResult == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.grey,),
            )
          : Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(16, 19, 37, 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 16),
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
                    ],
                  ),
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
    );
  }
}
