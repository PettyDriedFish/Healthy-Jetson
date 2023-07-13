import 'package:flutter/material.dart';

class SliderExamplePage extends StatefulWidget {
  @override
  _SliderExamplePageState createState() => _SliderExamplePageState();
}

class _SliderExamplePageState extends State<SliderExamplePage> {
  // double _value = 0.0;
  RangeValues _values = RangeValues(0.0, 100.0);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Slider Example'),
    //   ),
    //   body: Container(
    //     padding: EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           'Value: ${_value.toStringAsFixed(2)}',
    //           style: TextStyle(fontSize: 20),
    //         ),
    //         SizedBox(height: 16),
    //         Slider(
    //           value: _value,
    //           min: 0.0,
    //           max: 100.0,
    //           onChanged: (newValue) {
    //             setState(() {
    //               _value = newValue;
    //             });
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Range Slider Example'),
      // ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Min Value: ${_values.start.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Max Value: ${_values.end.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            RangeSlider(
              values: _values,
              min: 0.0,
              max: 100.0,
              onChanged: (newValues) {
                setState(() {
                  _values = newValues;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
