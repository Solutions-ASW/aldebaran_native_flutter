import 'package:aldebaran_native_flutter/app/components/table/table_widget.dart';
import 'package:aldebaran_native_flutter/app/utils/color_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AreaChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  const AreaChart(
    this.seriesList, {
    Key? key,
    required this.animate,
  }) : super(key: key);

  factory AreaChart.withSampleData() {
    return AreaChart(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final staticTicks = <charts.TickSpec<int>>[
      const charts.TickSpec(
        1,
        label: 'Semana 1',
      ),
      charts.TickSpec(
        52,
        label: 'Semana 52',
        style: charts.TextStyleSpec(
          fontFamily: "MavenPro",
          color: charts.Color.fromHex(code: "#4CB050"),
        ),
      ),
    ];

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: charts.LineChart(
                  seriesList,
                  defaultRenderer: charts.LineRendererConfig(
                    includeArea: true,
                    stacked: true,
                  ),
                  animate: animate,
                  defaultInteractions: true,
                  primaryMeasureAxis: const charts.NumericAxisSpec(
                    renderSpec: charts.NoneRenderSpec(),
                  ),
                  // behaviors: [
                  //   charts.SeriesLegend(
                  //     position: charts.BehaviorPosition.bottom,
                  //     outsideJustification: charts.OutsideJustification.start,
                  //   ),
                  // ],
                  domainAxis: charts.NumericAxisSpec(
                    tickProviderSpec:
                        charts.StaticNumericTickProviderSpec(staticTicks),
                  ),
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: seriesList
                          .map(
                            (s) => Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    s.id,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: FittedBox(
                                      child: Text(
                                        NumberFormat.simpleCurrency(
                                                locale: "pt-BR", name: "\$")
                                            .format(
                                          (s.data.last as AreaChartData).value,
                                        ),
                                        style: TextStyle(
                                          fontSize:
                                              getAdaptiveText(context, 22.0),
                                          color: HexColor.fromHex(
                                            s.colorFn!(0).hexString,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) => Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: const TableWidget(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Ver tabela detalhada",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF4CB050),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getAdaptiveText(
    BuildContext context,
    double fontsize,
  ) {
    double heigth = MediaQuery.of(context).size.height;
    return (heigth * 0.0015) * fontsize;
  }

  static List<charts.Series<AreaChartData, int>> _createSampleData() {
    final myFakeDesktopData = [
      AreaChartData(0, 5),
      AreaChartData(1, 25),
      AreaChartData(2, 100),
      AreaChartData(3, 75),
    ];

    var myFakeTabletData = [
      AreaChartData(0, 10),
      AreaChartData(1, 50),
      AreaChartData(2, 200),
      AreaChartData(3, 150),
    ];

    var myFakeMobileData = [
      AreaChartData(0, 15),
      AreaChartData(1, 75),
      AreaChartData(2, 300),
      AreaChartData(3, 225),
    ];

    return [
      charts.Series<AreaChartData, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AreaChartData balance, _) => balance.week,
        measureFn: (AreaChartData balance, _) => balance.value,
        data: myFakeDesktopData,
      ),
      charts.Series<AreaChartData, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (AreaChartData balance, _) => balance.week,
        measureFn: (AreaChartData balance, _) => balance.value,
        data: myFakeTabletData,
      ),
      charts.Series<AreaChartData, int>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (AreaChartData balance, _) => balance.week,
        measureFn: (AreaChartData balance, _) => balance.value,
        data: myFakeMobileData,
      ),
    ];
  }
}

class AreaChartData {
  final int week;
  final double value;

  AreaChartData(this.week, this.value);
}
