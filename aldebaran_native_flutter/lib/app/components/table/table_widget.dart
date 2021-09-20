// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:aldebaran_native_flutter/app/controllers/contrainst.dart';
import 'package:aldebaran_native_flutter/app/controllers/init_controller.dart';
import 'package:aldebaran_native_flutter/app/models/params_model.dart';
import 'package:aldebaran_native_flutter/app/models/result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({Key? key}) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  final initController = Modular.get<InitController>();
  int currentIndex = 0;
  PageController? _tabController;
  List<Widget>? _tabList;
  List<ResultModel> resultYield = [];

  @override
  void initState() {
    _tabController = PageController(initialPage: currentIndex);
    _tabList = [
      _listComponent(initController.getYieldByWeek(ParamsModel(
        investimentPeriod: 13,
        investimentType: INVESTMENT.carteira,
        investmentValue: 10,
      ))),
      _listComponent(initController.getYieldByWeek(ParamsModel(
        investimentPeriod: 13,
        investimentType: INVESTMENT.poupanca,
        investmentValue: 10,
      ))),
      _listComponent(initController.getYieldByWeek(ParamsModel(
        investimentPeriod: 13,
        investimentType: INVESTMENT.cdi,
        investmentValue: 10,
      ))),
    ];
    super.initState();
  }

  Widget _option(String title, int index) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          currentIndex = index;
        });
        _tabController?.jumpToPage(currentIndex);
      },
      child: Container(
        height: 34,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: currentIndex == index
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF9EA1A580),
                    spreadRadius: 0.5,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  )
                ],
              )
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
        child: Align(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listComponent(List<ResultModel> resultYield) {
    return ListView.builder(
      itemCount: resultYield.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: index == 0 ? 10 : 20),
          height: 85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Semana ${resultYield[index].semana.toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF202021),
                ),
              ),
              SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Investimento: \$ ${resultYield[index].deposito!.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Rendimento: \$ ${resultYield[index].juros!.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Acumulado",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF777777),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "\$ ${resultYield[index].acumulado!.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontFamily: 'MavenPro',
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CB050),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(18),
              ),
              margin: EdgeInsets.only(top: 10),
              width: 38,
              height: 8,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 40,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _option('Carteira', 0),
                _option('Poupança', 1),
                _option('CDB', 2),
              ],
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Tabela detalhada',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF777777),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: _tabList!,
            ),
          ),
        ],
      ),
    );
  }
}
