import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  DateFormat? dateFormat;//date format
  DateFormat? timeFormat;//time format
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('MMMM d');
    timeFormat = DateFormat('HH:mm:ss');
    selectedOption = 'temperature';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = dateFormat!.format(now);
    final formattedTime = timeFormat!.format(now);

    return Scaffold(
      backgroundColor: Color(0xFFE7DCC9),//D8CFBC,EDE6D7,F3F3E7
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              // color: Colors.white,
              height: 220,
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
                  Text(
                    '$formattedDate',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Lilita',
                      color: Color.fromRGBO(15,15,17,0.9),
                    ),
                  ),
                  Text(
                    'Table generated at $formattedTime',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lilita',
                      color: Color.fromRGBO(15,15,17,0.9),
                    ),
                  ),
                  SizedBox(height: 0), // 调整选项之间的垂直间距
                  ListTileTheme(
                    contentPadding: EdgeInsets.zero, // 设置选项的内边距为零
                    child: RadioListTile<String>(
                      title: Text('Temperature'),
                      value: 'temperature',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: Colors.black, // 设置选中时的颜色
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  ListTileTheme(
                    contentPadding: EdgeInsets.zero, // 设置选项的内边距为零
                    child: RadioListTile<String>(
                      title: Text('Humidity'),
                      value: 'humidity',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: Colors.black, // 设置选中时的颜色
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: selectedOption == 'temperature' ? TemperatureChart() : HumidityChart(),
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureChart extends StatelessWidget {
  final List<double> temperatureData = [
    // 假数据，每个数据点代表一小时的温度
    20.50, 21.22, 20.82, 20.33, 19.74, 19.25, 18.96, 18.87,
    19.28, 19.80, 20.57, 21.18, 21.68, 21.91, 22.12, 22.03,
    21.75, 21.25, 20.85, 20.33, 19.95, 19.56, 19.22, 19.19,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: temperatureData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true, // 设置曲线是否平滑
              dotData: FlDotData(show: false), // 设置数据点是否显示
              belowBarData: BarAreaData(show: false), // 设置曲线下方区域是否显示
              colors: [Color.fromRGBO(243,243,231,1),], // 设置曲线颜色
              barWidth: 3, // 设置曲线宽度
            ),
          ],
          minY: 15, // 设置Y轴最小值
          maxY: 35, // 设置Y轴最大值
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22, // 留出底部空间以显示刻度标签
              margin: 10, // 刻度标签距离底部的距离
              getTitles: (value) {
                // 根据value返回对应的时间
                int hour = value.toInt();
                String time = hour.toString().padLeft(2, '0') ;
                return time;
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              interval: 5, // 设置刻度间隔
            ),
            topTitles: SideTitles(
              showTitles: false,
            ),
            rightTitles: SideTitles(
              showTitles: false,
            ),
          ),
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              showTitle: true,
              titleText: 'Temperature/°C',
              textStyle: TextStyle(fontSize: 14),
            ),
            bottomTitle: AxisTitle(
              showTitle: true,
              titleText: 'Time',
              textStyle: TextStyle(fontSize: 14),
            ),
          ),
          borderData: FlBorderData(show: false), // 不显示边框
        ),
      ),
    );
  }
}

class HumidityChart extends StatelessWidget {
  final List<double> humidityData = [
    // 假数据，每个数据点代表一小时的湿度
    49.43, 50.21, 50.05, 51.77, 51.92, 52.11, 52.32, 52.45,
    51.66, 50.89, 50.99, 49.12, 49.27, 48.87, 48.41, 48.55,
    48.67, 48.73, 48.89, 49.01, 49.16, 49.23, 49.32, 49.45
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: humidityData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true, // 设置曲线是否平滑
              dotData: FlDotData(show: false), // 设置数据点是否显示
              belowBarData: BarAreaData(show: false), // 设置曲线下方区域是否显示
              colors: [Color.fromRGBO(243,243,231,1),], // 设置曲线颜色
              barWidth: 3, // 设置曲线宽度
            ),
          ],
          minY: 30, // 设置Y轴最小值
          maxY: 60, // 设置Y轴最大值
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22, // 留出底部空间以显示刻度标签
              margin: 10, // 刻度标签距离底部的距离
              getTitles: (value) {
                // 根据value返回对应的时间
                int hour = value.toInt();
                String time = hour.toString().padLeft(2, '0') ;
                return time;
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              interval: 5, // 设置刻度间隔
            ),
            topTitles: SideTitles(
              showTitles: false,
            ),
            rightTitles: SideTitles(
              showTitles: false,
            ),
          ),
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              showTitle: true,
              titleText: 'Humidity/ %',
              textStyle: TextStyle(fontSize: 14),
            ),
            bottomTitle: AxisTitle(
              showTitle: true,
              titleText: 'Time',
              textStyle: TextStyle(fontSize: 14),
            ),
          ),
          borderData: FlBorderData(show: false), // 不显示边框
        ),
      ),
    );
  }
}