import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_value/src/theme.dart';

import '../../src/helper_widgets.dart';

class AdminPurchasesView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminPurchasesView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminPurchasesView> createState() => _AdminPurchasesViewState();
}

class _AdminPurchasesViewState extends State<AdminPurchasesView> {
  final Duration animDuration = const Duration(milliseconds: 250);

  String language = '';
  int touchedIndex = -1;

  ///Data
  int companiesCount = 0;
  int demoAccounts = 0;
  int premiumAccounts = 0;
  int bapAccounts = 0;
  int pymAccounts = 0;
  int gtbAccounts = 0;
  int incAccounts = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
    _getNumberOfCompanies();
    _getDemoAccounts();
    _getPremiumAccounts();
    _getBAPAccounts();
    _getPYMAccounts();
    _getGTBAccounts();
  }

  _getNumberOfCompanies() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Company')
        .get();

    setState(() {
      companiesCount = snapshot.docs.length;
    });
  }

  _getDemoAccounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Company')
        .where('user_plan', isEqualTo: '-')
        .get();

    setState(() {
      demoAccounts = snapshot.docs.length;
    });
  }

  _getPremiumAccounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Company')
        .where('user_plan', isNotEqualTo: '-')
        .get();

    setState(() {
      premiumAccounts = snapshot.docs.length;
    });
  }

  _getBAPAccounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Company')
        .where('user_plan', isEqualTo: 'BE A PUBLISHER')
        .get();

    setState(() {
      bapAccounts = snapshot.docs.length;
    });
  }

  _getPYMAccounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Company')
        .where('user_plan', isEqualTo: 'PROMOTE YOUR MESSAGE')
        .get();

    setState(() {
      pymAccounts = snapshot.docs.length;
    });
  }

  _getGTBAccounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Company')
        .where('user_plan', isEqualTo: 'GET THE BRAND')
        .get();

    setState(() {
      gtbAccounts = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                blueGreyBoldTextWithSize(
                  language == 'ro' ? 'Companii' : 'Companies',
                  24,
                ),
                addVerticalSpace(4),
                blueGreyNormalTextWithSize(
                  language == 'ro'
                      ? 'Denumirea abonamentelor'
                      : 'Subscriptions denomination',
                  14,
                ),
                addVerticalSpace(38),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    // barColor ??= const Color(0xffecc63d);
    barColor ??= Colors.teal;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? TAppTheme.primaryColor : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.grey)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: companiesCount.toDouble(),
            color: Colors.grey.withOpacity(.4),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, companiesCount.toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, demoAccounts.toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, premiumAccounts.toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, bapAccounts.toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, pymAccounts.toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, gtbAccounts.toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipMargin: 20,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'TOTAL COMPANIES ${group.x}';
                break;
              case 1:
                weekDay = 'DEMO ACCOUNTS';
                break;
              case 2:
                weekDay = 'PREMIUM ACCOUNTS';
                break;
              case 3:
                weekDay = 'BE A PUBLISHER';
                break;
              case 4:
                weekDay = 'PROMOTE YOUR MESSAGE';
                break;
              case 5:
                weekDay = 'GET THE BRAND';
                break;
              case 6:
                weekDay = 'INCOMPLETE ACCOUNTS';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    letterSpacing: .5,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14.0,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('ALL', style: style);
        break;
      case 1:
        text = const Text('DEMO', style: style);
        break;
      case 2:
        text = const Text('PRO', style: style);
        break;
      case 3:
        text = const Text('BAP', style: style);
        break;
      case 4:
        text = const Text('PYM', style: style);
        break;
      case 5:
        text = const Text('GTB', style: style);
        break;
      case 6:
        text = const Text('INC', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
