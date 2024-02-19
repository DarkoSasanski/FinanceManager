import 'package:flutter/material.dart';

class DeviceIsNotSupportedPage extends StatelessWidget {
  const DeviceIsNotSupportedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(16, 19, 37, 1),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mobile_off,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  'Device Not Supported',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
