import 'package:flutter/material.dart';
import 'package:splitify/ui/widgets/glassmorphic_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/colors.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// import './show_snackbar.dart';

Color highlightColor = secondaryLight;

class PieChart extends StatefulWidget {
  const PieChart({Key? key, this.totalExpense}) : super(key: key);
  final totalExpense;
  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  // var catValue;
  var showIndex = null;
  var catValue = {
    'Food': 0,
    'Shopping': 0,
    'Medicines': 0,
    'Transport': 0,
    'Utilities': 0,
    'Education': 0,
    'Entertainment': 0,
    'Clothing': 0,
    'Rent': 0,
    'Others': 0,
  };

  getpiechart() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http.post(Uri.parse("$endPoint/userApi/getPieChart"),
          body: {"token": value});
      // print(response.body);
      // print(response.body.runtimeType);
      Map<String, dynamic> res =
          jsonDecode(response.body) as Map<String, dynamic>;
      // int length = res['message'].length;
      // print(length);
      // print('type = ');
      // print(res.runtimeType);

      for (var item in res['message']) {
        if (item['key'] != null && item['value'] != null) {
          // Ensure that value is treated as an integer
          if (item['value'] is String) {
            catValue[item['key']] = int.parse(item['value']);
          } else if (item['value'] is int) {
            catValue[item['key']] = item['value'];
          } else {
            throw Exception("Unexpected value type");
          }
        }
      }
      // print("catValue");
      // print(catValue);
      setState(() {});
    } catch (e) {
      // print(e);
      // print("Pie chart error: " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getpiechart();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;

    return SizedBox(
      width: width * 80,
      // padding: const EdgeInsets.all(20
      child: GlassMorphism(
        start: 0.25,
        end: 0,
        accent: purple,
        borderRadius: 20,
        child: Column(
          children: [
            SizedBox(
              height: width * 5,
            ),
            const Text(
              "Expense Summary:",
              // textScaleFactor: 1.4,
              textScaler: TextScaler.linear(1.4),
              style: TextStyle(color: white),
            ),
            (widget.totalExpense == 0)
                // (0 == 1)
                ? Column(
                    children: [
                      SizedBox(
                        height: width * 5,
                      ),
                      Text(
                        "No expense made",
                        // textScaleFactor: 1.1,
                        textScaler: const TextScaler.linear(1.1),
                        style: TextStyle(color: purple),
                      ),
                      SizedBox(
                        height: width * 5,
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
                            showIndex == data.index ? width * 12 : width * 10,
                        decoration: BoxDecoration(
                          color: showIndex == data.index
                              ? purple.withOpacity(0.3)
                              : primary.withOpacity(0),
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (showIndex != data.index) {
                                showIndex = data.index;
                              } else {
                                showIndex = null;
                              }
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
                                // textScaleFactor: 1.2,
                                textScaler: const TextScaler.linear(1.2),
                                style: TextStyle(
                                  color:
                                      showIndex == data.index ? white : purple,
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
  int index;
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
