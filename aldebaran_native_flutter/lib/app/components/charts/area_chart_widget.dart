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

  static List<AreaChartData> mockDinheiro = [
    AreaChartData(1, 10.00),
    AreaChartData(2, 20.00),
    AreaChartData(3, 30.00),
    AreaChartData(4, 40.00),
    AreaChartData(5, 50.00),
    AreaChartData(6, 60.00),
    AreaChartData(7, 70.00),
    AreaChartData(8, 80.00),
    AreaChartData(9, 90.00),
    AreaChartData(10, 100.00),
    AreaChartData(11, 110.00),
    AreaChartData(12, 120.00),
    AreaChartData(13, 130.00),
    AreaChartData(14, 140.00),
    AreaChartData(15, 150.00),
    AreaChartData(16, 160.00),
    AreaChartData(17, 170.00),
    AreaChartData(18, 180.00),
    AreaChartData(19, 190.00),
    AreaChartData(20, 200.00),
    AreaChartData(21, 210.00),
    AreaChartData(22, 220.00),
    AreaChartData(23, 230.00),
    AreaChartData(24, 240.00),
    AreaChartData(25, 250.00),
    AreaChartData(26, 260.00),
    AreaChartData(27, 270.00),
    AreaChartData(28, 280.00),
    AreaChartData(29, 290.00),
    AreaChartData(30, 300.00),
    AreaChartData(31, 310.00),
    AreaChartData(32, 320.00),
    AreaChartData(33, 330.00),
    AreaChartData(34, 340.00),
    AreaChartData(35, 350.00),
    AreaChartData(36, 360.00),
    AreaChartData(37, 370.00),
    AreaChartData(38, 380.00),
    AreaChartData(39, 390.00),
    AreaChartData(40, 400.00),
    AreaChartData(41, 410.00),
    AreaChartData(42, 420.00),
    AreaChartData(43, 430.00),
    AreaChartData(44, 440.00),
    AreaChartData(45, 450.00),
    AreaChartData(46, 460.00),
    AreaChartData(47, 470.00),
    AreaChartData(48, 480.00),
    AreaChartData(49, 490.00),
    AreaChartData(50, 500.00),
    AreaChartData(51, 510.00),
    AreaChartData(52, 520.00),
  ];

  static List<AreaChartData> mockPoupanca = [
    AreaChartData(1, 10.00),
    AreaChartData(2, 20.00),
    AreaChartData(3, 30.00),
    AreaChartData(4, 40.00),
    AreaChartData(5, 50.03),
    AreaChartData(6, 60.06),
    AreaChartData(7, 70.09),
    AreaChartData(8, 80.12),
    AreaChartData(9, 90.18),
    AreaChartData(10, 100.25),
    AreaChartData(11, 110.31),
    AreaChartData(12, 120.37),
    AreaChartData(13, 130.46),
    AreaChartData(14, 140.55),
    AreaChartData(15, 150.64),
    AreaChartData(16, 160.74),
    AreaChartData(17, 170.86),
    AreaChartData(18, 180.98),
    AreaChartData(19, 191.11),
    AreaChartData(20, 201.23),
    AreaChartData(21, 211.38),
    AreaChartData(22, 221.54),
    AreaChartData(23, 231.69),
    AreaChartData(24, 241.85),
    AreaChartData(25, 252.03),
    AreaChartData(26, 262.22),
    AreaChartData(27, 272.40),
    AreaChartData(28, 282.59),
    AreaChartData(29, 292.80),
    AreaChartData(30, 303.02),
    AreaChartData(31, 313.23),
    AreaChartData(32, 323.45),
    AreaChartData(33, 333.70),
    AreaChartData(34, 343.95),
    AreaChartData(35, 354.19),
    AreaChartData(36, 364.44),
    AreaChartData(37, 374.72),
    AreaChartData(38, 385.00),
    AreaChartData(39, 395.28),
    AreaChartData(40, 405.56),
    AreaChartData(41, 415.87),
    AreaChartData(42, 426.18),
    AreaChartData(43, 436.49),
    AreaChartData(44, 446.80),
    AreaChartData(45, 457.14),
    AreaChartData(46, 467.48),
    AreaChartData(47, 477.83),
    AreaChartData(48, 488.17),
    AreaChartData(49, 498.54),
    AreaChartData(50, 508.92),
    AreaChartData(51, 519.29),
    AreaChartData(52, 529.66),
  ];

  static List<AreaChartData> mockCDB = [
    AreaChartData(1, 10.00),
    AreaChartData(2, 20.00),
    AreaChartData(3, 30.00),
    AreaChartData(4, 40.00),
    AreaChartData(5, 50.04),
    AreaChartData(6, 60.09),
    AreaChartData(7, 70.13),
    AreaChartData(8, 80.17),
    AreaChartData(9, 90.26),
    AreaChartData(10, 100.34),
    AreaChartData(11, 110.43),
    AreaChartData(12, 120.52),
    AreaChartData(13, 130.65),
    AreaChartData(14, 140.77),
    AreaChartData(15, 150.90),
    AreaChartData(16, 161.03),
    AreaChartData(17, 171.21),
    AreaChartData(18, 181.38),
    AreaChartData(19, 191.55),
    AreaChartData(20, 201.72),
    AreaChartData(21, 211.94),
    AreaChartData(22, 222.16),
    AreaChartData(23, 232.37),
    AreaChartData(24, 242.59),
    AreaChartData(25, 252.85),
    AreaChartData(26, 263.11),
    AreaChartData(27, 273.37),
    AreaChartData(28, 283.63),
    AreaChartData(29, 293.94),
    AreaChartData(30, 304.24),
    AreaChartData(31, 314.54),
    AreaChartData(32, 324.85),
    AreaChartData(33, 335.20),
    AreaChartData(34, 345.55),
    AreaChartData(35, 355.89),
    AreaChartData(36, 366.24),
    AreaChartData(37, 376.64),
    AreaChartData(38, 387.03),
    AreaChartData(39, 397.42),
    AreaChartData(40, 407.81),
    AreaChartData(41, 418.25),
    AreaChartData(42, 428.69),
    AreaChartData(43, 439.13),
    AreaChartData(44, 449.56),
    AreaChartData(45, 460.05),
    AreaChartData(46, 470.53),
    AreaChartData(47, 481.01),
    AreaChartData(48, 491.49),
    AreaChartData(49, 502.02),
    AreaChartData(50, 512.55),
    AreaChartData(51, 523.08),
    AreaChartData(52, 533.60),
  ];
}
