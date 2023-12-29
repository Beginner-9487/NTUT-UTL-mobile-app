import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SimpleLineChart extends StatelessWidget {
  PageStorageKey pageStorageKey;
  SimpleLineChart(this.pageStorageKey, {super.key});

  static get ROUTER_NAME => '/SimpleLineChart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foot Icon Line Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            // Your line chart data configuration goes here

            // Example line data
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),

            // Add your line bar data here

            // Custom shapes
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: 2, // Y-coordinate where you want to place the foot icon
                  color: Colors.green, // Color of the line
                  strokeWidth: 2, // Width of the line
                  dashArray: [5, 2], // Optional dash pattern
                  // label: FlLineChartLabel (
                  //   // Custom label for the line
                  //   show: true,
                  //   alignment: Alignment.bottomRight,
                  //   style: TextStyle(color: Colors.black),
                  //   label: 'Foot',
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlLineChartLabel extends HorizontalLineLabel {
}