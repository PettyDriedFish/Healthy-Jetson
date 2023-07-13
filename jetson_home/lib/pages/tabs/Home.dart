import 'package:flutter/material.dart';
import 'package:jetson_home/pages/tabs/DisplayTH.dart';
import 'package:jetson_home/pages/tabs/SetTH.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import '../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateFormat? dateFormat;//date format

  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://192.168.3.27:8000/websocket');
  String temperature = '';
  String humidity = '-';
  bool fanSwitchValue = false;
  bool humidifierSwitchValue = false;
  bool heaterSwitchValue = false;
  bool hasNewMessage = false; // 新消息标志变量

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('MMMM d');
    channel.stream.listen((message) {
      // 接收到消息时进行处理
      // 将消息打印到Android运行输出栏
      print('Received JSON message: $message');
      setState(() {
        final data = json.decode(message);
        temperature = data['temperature'].toString();
        humidity = data['humidity'].toString();
        fanSwitchValue = data['fan_plug_status'];
        humidifierSwitchValue = data['humidifier_plug_status'];
        heaterSwitchValue = data['heater_plug_status'];
        hasNewMessage = true; // 收到新消息，设置标志变量为true
      });
      refreshPage(); // 在接收到新消息后调用 refreshPage()
    });
  }

  // void sendControlCommand() {
  //   final message = json.encode({
  //     'fan_plug_status': fanSwitchValue,
  //     'humidifier_plug_status': humidifierSwitchValue,
  //     'heater_plug_status': heaterSwitchValue,
  //   });
  //   channel.sink.add(message);
  // }

  @override
  //用于释放资源化和进行清理操作
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void refreshPage() {
    Future.delayed(Duration.zero, () {
      setState(() {}); // 触发界面刷新
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = dateFormat!.format(now);
    final appState = Provider.of<AppState>(context);//global variable

    return Scaffold(
      backgroundColor: Color.fromRGBO(243,243,231,1),//D8CFBC,EDE6D7,F3F3E7
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                    SizedBox(height: 10), // 调整选项之间的垂直间距
                    Text(
                      'Manage Your',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'Lilita',
                        fontWeight: FontWeight.bold, // 设置字体加粗
                        color: Color.fromRGBO(15,15,17,0.9),
                      ),
                      textAlign: TextAlign.center, // 设置文本居中对齐
                    ),
                    SizedBox(height: 10), // 调整选项之间的垂直间距
                    Text(
                      'Temperature and Humidity',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Lilita',
                        // fontWeight: FontWeight.bold, // 设置字体加粗
                        color: Color.fromRGBO(15,15,17,0.9),
                      ),
                      textAlign: TextAlign.center, // 设置文本居中对齐
                    )
                  ],
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                // color: Colors.white,
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(231,220,201,1),
                      // offset: Offset(5, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage('lib/images/best-smart-plugs-2020.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                //两个上下的矩形框
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        width: 190,
                        height: 140,
                        margin: EdgeInsets.fromLTRB(140, 10, 0, 10),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Current Environment:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                // fontWeight: FontWeight.bold, // 设置字体加粗
                                color: Color.fromRGBO(15,15,17,0.9),
                              ),
                            ),
                            Divider(),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.thermostat), // 显示温度图标
                                    Text(
                                      "Temperature",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color.fromRGBO(15, 15, 17, 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5), // 调整选项之间的垂直间距
                                Text(
                                  "$appState.temperature°C",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Lilita',
                                    color: Color.fromRGBO(15, 15, 17, 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 80,
                        margin: EdgeInsets.fromLTRB(140, 0, 0, 0),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.air), // 显示温度图标
                                Text(
                                  "Humidity",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color.fromRGBO(15, 15, 17, 0.9),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5), // 调整选项之间的垂直间距
                            Text(
                              "$appState.humidity %",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Lilita',
                                color: Color.fromRGBO(15, 15, 17, 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                // color: Colors.white,
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(231,220,201,0),
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
                        Text("My Plugs", textAlign: TextAlign.left, style: TextStyle(fontSize: 16,),),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                // color: Colors.white,
                // height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(231,220,201,0),
                      // offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                            // color: Colors.white,
                            height: 50,
                            width: 165,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(231,220,201,1),
                                  // offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.wind_power, color: Colors.black12,),
                                SizedBox(width: 5),
                                Text(
                                  "Fan",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(15, 15, 17, 0.9),
                                  ),
                                ),//
                              ],
                            ),
                        ),

                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                            // color: Colors.white,
                            height: 50,
                            width: 165,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(231,220,201,1),
                                  // offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child:Row(
                              children: [
                                Icon(Icons.water, color: Colors.black12),
                                SizedBox(width: 5),
                                Text(
                                  "Humidifier",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(15, 15, 17, 0.9),
                                  ),
                                ),//
                              ],
                            ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            // color: Colors.white,
                            height: 50,
                            width: 165,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(231,220,201,1),
                                  // offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.heat_pump, color: Colors.black12),
                                SizedBox(width: 5),
                                Text(
                                  "Heater",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(15, 15, 17, 0.9),
                                  ),
                                ),//
                              ],
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // // 显示新消息的文本
              // Visibility(
              //   visible: hasNewMessage,
              //   child: Text(
              //     'New Message Received!',
              //     style: TextStyle(
              //       fontSize: 12,
              //       color: Color.fromRGBO(15, 15, 17, 0.9),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}