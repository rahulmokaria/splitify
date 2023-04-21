import 'package:flutter/material.dart';
import 'package:splitify/ui/widgets/glassmorphic_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/colors.dart';

var showIndex = 0;
Color highlightColor = secondaryLight;

class PieChart extends StatefulWidget {
  PieChart({Key? key, required this.showIndex}) : super(key: key);
  var showIndex = 0;
  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Container(
      width: _width * 80,
      // padding: const EdgeInsets.all(20
      child: GlassMorphism(
        start: 0.25,
        end: 0,
        borderRadius: 20,
        child: Column(
          children: [
            SizedBox(
              height: _width * 5,
            ),
            const Text(
              "Expense Summary:",
              textScaleFactor: 1.4,
              style: TextStyle(color: white),
            ),
            // (totalExpense == 0)
            (0 == 1)
                ? Column(
                    children: [
                      SizedBox(
                        height: _width * 5,
                      ),
                      Text(
                        "No expense made",
                        textScaleFactor: 1.1,
                        style: TextStyle(color: black),
                      ),
                    ],
                  )
                : Center(
                    child: SfCircularChart(
                      series: <CircularSeries>[
                        // Renders doughnut chart
                        DoughnutSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) =>
                              double.parse(catValue[data.x].toString()),
                          // cornerStyle: CornerStyle.bothCurve,
                          innerRadius: '60%',
                          explode: true,
                          explodeIndex: showIndex,

                          animationDuration: 0.0,
                        )
                      ],
                    ),
                  ),
            // if (totalExpense != 0)
            if (1 != 0)
              for (var data in chartData) ...[
                if (double.parse(catValue[data.x].toString()) != 0)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        height:
                            showIndex == data.index ? _width * 12 : _width * 10,
                        decoration: BoxDecoration(
                          color: showIndex == data.index
                              ? purple.withOpacity(0.3)
                              : primary.withOpacity(0),
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showIndex = data.index;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: data.color,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                data.x,
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                  color:
                                      showIndex == data.index ? purple : white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
              ]
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData({
    required this.index,
    required this.x,
    required this.color,
  });
  var index;
  String x;
  Color color;
}

final List<ChartData> chartData = [
  ChartData(
    index: 0,
    x: 'Food',
    color: const Color.fromARGB(255, 249, 65, 68),
  ),
  ChartData(
    index: 1,
    x: 'Shopping',
    color: const Color.fromARGB(255, 243, 114, 44),
  ),
  ChartData(
    index: 2,
    x: 'Medicines',
    color: const Color.fromARGB(255, 248, 150, 30),
  ),
  ChartData(
    index: 3,
    x: 'Transport',
    color: const Color.fromARGB(255, 249, 132, 74),
  ),
  ChartData(
    index: 4,
    x: 'Utilities',
    color: const Color.fromARGB(255, 249, 199, 79),
  ),
  ChartData(
    index: 5,
    x: 'Education',
    color: const Color.fromARGB(255, 144, 190, 109),
  ),
  ChartData(
    index: 6,
    x: 'Entertainment',
    color: const Color.fromARGB(255, 67, 170, 139),
  ),
  ChartData(
    index: 7,
    x: 'Clothing',
    // y: double.parse(catValue["Clothing"].toString()),
    color: const Color.fromARGB(255, 77, 144, 142),
  ),
  ChartData(
    index: 8,
    x: 'Rent',
    // y: double.parse(catValue["Rent"].toString()),
    color: const Color.fromARGB(255, 87, 117, 144),
  ),
  ChartData(
    index: 9,
    x: 'Others',
    // y: double.parse(catValue["Others"].toString()),
    color: const Color.fromARGB(255, 39, 125, 161),
  ),
];

var catValue = {
  'Food': 20,
  'Shopping': 30,
  'Medicines': 20,
  'Transport': 100,
  'Utilities': 10,
  'Education': 50,
  'Entertainment': 200,
  'Clothing': 10,
  'Rent': 200,
  'Others': 5,
};
