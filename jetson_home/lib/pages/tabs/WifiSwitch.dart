import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WifiSwitchPage extends StatefulWidget {
  @override
  _WifiSwitchPageState createState() => _WifiSwitchPageState();
}

class _WifiSwitchPageState extends State<WifiSwitchPage> {
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://192.168.3.27:8000/websocket');
  String temperature = '-';
  String humidity = '-';
  bool fanSwitchValue = false;
  bool humidifierSwitchValue = false;
  bool heaterSwitchValue = false;

  // double tempValue = 24.0;
  // double humValue = 45.0;
  RangeValues tempValues = RangeValues(15.0, 35.0);
  RangeValues humValues = RangeValues(30.0, 60.0);

  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      // 接收到消息时进行处理
      setState(() {
        final data = json.decode(message);
        temperature = data['temperature'].toString();
        humidity = data['humidity'].toString();
        fanSwitchValue = data['fan_plug_status'];
        humidifierSwitchValue = data['humidifier_plug_status'];
        heaterSwitchValue = data['heater_plug_status'];
      });

    });
  }

  @override
  //用于释放资源化和进行清理操作
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void sendControlCommand() {
    final message = json.encode({
      'fan_plug_status': fanSwitchValue,
      'humidifier_plug_status': humidifierSwitchValue,
      'heater_plug_status': heaterSwitchValue,
    });
    channel.sink.add(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('WiFi Switch'),
      // ),
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              // color: Colors.white,
              height: 140,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    // offset: Offset(5, 5),
                  ),
                ],
              ),
              child:
              ListView(
                children: [
                  Text("Current indoor conditions", textAlign: TextAlign.left, style: TextStyle(fontSize: 16,),),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    // color: Colors.white,
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          // offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        childAspectRatio: 1/0.25,
                      ),
                      children: [
                        Text("Temperature", textAlign: TextAlign.left,),
                        Text("$temperature°C", textAlign: TextAlign.center,),
                        Text("Humidity", textAlign: TextAlign.left,),
                        Text("$humidity%", textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   'Temperature: $temperature°C',
            //   style: TextStyle(fontSize: 20),
            // ),
            // SizedBox(height: 16),
            // Text(
            //   'Humidity: $humidity%',
            //   style: TextStyle(fontSize: 20),
            // ),
            // SizedBox(height: 16),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              // color: Colors.white,
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(239,146,115,0.5),
                    // offset: Offset(5, 5),
                  ),
                ],
              ),
              child:
              ListView(
                children: [
                  Text("Customize", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: Color.fromRGBO(13,13,13,1),),),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    // color: Colors.white,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(187,215,216,0),
                          // offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        childAspectRatio: 1/0.1,
                      ),
                      children: [
                        Text("Min temperature: ${tempValues.start.toStringAsFixed(2)}°C", textAlign: TextAlign.left,),
                        Text("Max temperature: ${tempValues.end.toStringAsFixed(2)}°C", textAlign: TextAlign.left,),
                        RangeSlider(
                          values: tempValues,
                          min: 15.0,
                          max: 35.0,
                          onChanged: (newValues) {
                            setState(() {
                              tempValues = newValues;
                            });
                          },
                        ),
                        Text("Min humidity: ${humValues.start.toStringAsFixed(2)}%", textAlign: TextAlign.left,),
                        Text("Max humidity: ${humValues.end.toStringAsFixed(2)}%", textAlign: TextAlign.left,),
                        RangeSlider(
                          values: humValues,
                          min: 30.0,
                          max: 60.0,
                          onChanged: (newValues) {
                            setState(() {
                              humValues = newValues;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              // color: Colors.white,
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    // offset: Offset(5, 5),
                  ),
                ],
              ),
              child:
              ListView(
                children: [
                  Text("Plugs' status", textAlign: TextAlign.left, style: TextStyle(fontSize: 16,),),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    // color: Colors.white,
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          // offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        childAspectRatio: 1/0.25,
                      ),
                      children: [
                        Text("Fan", textAlign: TextAlign.left,),
                        Switch(
                          value: fanSwitchValue,
                          onChanged: (newValue) {
                            setState(() {
                              fanSwitchValue = newValue;
                            });
                            sendControlCommand();
                          },
                        ),
                        Text("Humidifier", textAlign: TextAlign.left,),
                        Switch(
                          value: humidifierSwitchValue,
                          onChanged: (newValue) {
                            setState(() {
                              humidifierSwitchValue = newValue;
                            });
                            sendControlCommand();
                          },
                        ),
                        Text("Heater", textAlign: TextAlign.left,),
                        Switch(
                          value: heaterSwitchValue,
                          onChanged: (newValue) {
                            setState(() {
                              heaterSwitchValue = newValue;
                            });
                            sendControlCommand();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Switch(
            //       value: fanSwitchValue,
            //       onChanged: (newValue) {
            //         setState(() {
            //           fanSwitchValue = newValue;
            //         });
            //         sendControlCommand();
            //       },
            //     ),
            //     Switch(
            //       value: humidifierSwitchValue,
            //       onChanged: (newValue) {
            //         setState(() {
            //           humidifierSwitchValue = newValue;
            //         });
            //         sendControlCommand();
            //       },
            //     ),
            //     Switch(
            //       value: heaterSwitchValue,
            //       onChanged: (newValue) {
            //         setState(() {
            //           heaterSwitchValue = newValue;
            //         });
            //         sendControlCommand();
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
