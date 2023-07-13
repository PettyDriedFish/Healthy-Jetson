import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CustomizePage extends StatefulWidget {
  @override
  _CustomizePageState createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://192.168.3.27:8000/websocket');

  RangeValues tempValues = RangeValues(15.0, 35.0);
  RangeValues humValues = RangeValues(30.0, 60.0);

  String temperature = '-';
  String humidity = '-';
  bool fanSwitchValue = false;
  bool humidifierSwitchValue = false;
  bool heaterSwitchValue = false;

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

  void sendControlCommand() {
    final message = json.encode({
      'fan_plug_status': fanSwitchValue,
      'humidifier_plug_status': humidifierSwitchValue,
      'heater_plug_status': heaterSwitchValue,
      'min_temperature': tempValues.start.toStringAsFixed(2),
      'max_temperature': tempValues.end.toStringAsFixed(2),
      'min_humidity': humValues.start.toStringAsFixed(2),
      'max_humidity':humValues.end.toStringAsFixed(2),
    });
    channel.sink.add(message);
  }

  @override
  //用于释放资源化和进行清理操作
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243,243,231,1),//D8CFBC,EDE6D7,F3F3E7
      // appBar: AppBar(
      //   title: Text('WiFi Switch'),
      // ),
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                // color: Colors.white,
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(243,243,231,1)
                      // offset: Offset(5, 5),
                    ),
                  ],
                ),
                child:ListView(
                  children: [
                    // Text(
                    //   '$formattedDate',
                    //   style: TextStyle(
                    //     fontSize: 40,
                    //     fontFamily: 'Lilita',
                    //     color: Color.fromRGBO(15,15,17,0.9),
                    //   ),
                    // ),
                    SizedBox(height: 10), // 调整选项之间的垂直间距
                    Text(
                      'Customsize',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Lilita',
                        fontWeight: FontWeight.bold, // 设置字体加粗
                        color: Color.fromRGBO(15,15,17,0.9),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                // color: Colors.white,
                height: 320,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(231,220,201,1),
                      // offset: Offset(5, 5),
                    ),
                  ],
                ),
                child:
                ListView(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      // color: Colors.white,
                      height: 300,
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.thermostat), // 显示温度图标
                              Text(
                                "Temperature",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromRGBO(15, 15, 17, 0.9),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 5), // 调整选项之间的垂直间距
                          Text(
                            "Min temperature: ${tempValues.start.toStringAsFixed(2)}°C",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Max temperature: ${tempValues.end.toStringAsFixed(2)}°C",
                            textAlign: TextAlign.left,
                          ),
                          RangeSlider(
                            values: tempValues,
                            min: 15.0,
                            max: 35.0,
                            onChanged: (newValues) {
                              setState(() {
                                tempValues = newValues;
                              });
                              sendControlCommand();
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.air), // 显示温度图标
                              Text(
                                "Humidity",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromRGBO(15, 15, 17, 0.9),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 5),
                          Text(
                            "Min humidity: ${humValues.start.toStringAsFixed(2)}%",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Max humidity: ${humValues.end.toStringAsFixed(2)}%",
                            textAlign: TextAlign.left,
                          ),
                          RangeSlider(
                            values: humValues,
                            min: 30.0,
                            max: 60.0,
                            onChanged: (newValues) {
                              setState(() {
                                humValues = newValues;
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
                      color: Color.fromRGBO(231,220,201,1),
                      // offset: Offset(5, 5),
                    ),
                  ],
                ),
                child:
                ListView(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.power),
                        Text("Plugs' status", textAlign: TextAlign.left, style: TextStyle(fontSize: 16,),),
                      ],
                    ),
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
                            color: Color.fromRGBO(231,220,201,1),
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

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                // color: Colors.white,
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(243,243,231,1)
                      // offset: Offset(5, 5),
                    ),
                  ],
                ),
                child:ListView(
                  children: [
                    // Text(
                    //   '$formattedDate',
                    //   style: TextStyle(
                    //     fontSize: 40,
                    //     fontFamily: 'Lilita',
                    //     color: Color.fromRGBO(15,15,17,0.9),
                    //   ),
                    // ),
                    Text(
                      'What is custom temperature and humidity?',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold, // 设置字体加粗
                        color: Color.fromRGBO(15,15,17,0.9),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'You can customize your Healthy Jetson by setting the maximum and minimum values, which will adjust the temperature and humidity of your house based on the values you set.',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        color: Color.fromRGBO(15,15,17,0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
