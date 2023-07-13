import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartTestPage extends StatefulWidget {
  const ChartTestPage({super.key});

  _ChartTestPageState createState() => _ChartTestPageState();
}

class _ChartTestPageState extends State<ChartTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Chart Page'),
      // ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 5),
                  FlSpot(1, 2),
                  FlSpot(2, 4),
                  FlSpot(3, 3),
                  FlSpot(4, 6),
                ],
                isCurved: true,
                colors: [Colors.blue],
                barWidth: 2,
              ),
            ],
            minY: 0,
            maxY: 10,
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Jan';
                    case 1:
                      return 'Feb';
                    case 2:
                      return 'Mar';
                    case 3:
                      return 'Apr';
                    case 4:
                      return 'May';
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  if (value == 0) {
                    return '0';
                  } else if (value == 5) {
                    return '5';
                  } else if (value == 10) {
                    return '10';
                  }
                  return '';
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
