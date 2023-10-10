import 'package:awesome_circular_chart/awesome_circular_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class CompanySubscriptionPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanySubscriptionPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanySubscriptionPage> createState() =>
      _CompanySubscriptionPageState();
}

class _CompanySubscriptionPageState extends State<CompanySubscriptionPage> {
  String language = '';
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();
  int total = 0;
  @override
  void initState() {
    super.initState();

    getTotal();
    setState(() {
      language = widget.userData['user_language'];
    });
  }

  getTotal() {
    setState(() {
      total = widget.userData['press_left_count'] +
          widget.userData['interview_left_count'] +
          widget.userData['interview_left_count'] +
          20;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: whiteTitleTextLarge(
            language == 'ro' ? 'Abonament' : 'Subscription',
          ),
          centerTitle: true,
          backgroundColor: TAppTheme.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: size.width,
                      width: size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/subscriptions.png"),
                            fit: BoxFit.cover),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whiteBoldTextWithSize(
                                language == 'ro'
                                    ? 'Prin tehnologia unică, apari în media locală și națională, la costuri foarte accesibile.'
                                    : 'Through the unique technology, you appear in the local and national media, at very affordable costs.',
                                16),
                            addVerticalSpace(30),
                            Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    color: Colors.white12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  child: whiteBoldTextWithSize(
                                      widget.userData['user_plan'] == '-'
                                          ? 'DEMO'
                                          : widget.userData['user_plan'],
                                      18),
                                )),
                            addVerticalSpace(40)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              addVerticalSpace(20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    blackBoldText(
                      language == 'ro' ? 'Echilibru' : 'Balance',
                    ),
                    addVerticalSpace(10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.teal.withOpacity(.03),
                        border: Border.all(
                          color: Colors.teal.withOpacity(.1),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedCircularChart(
                            holeRadius: 30,
                            key: _chartKey,
                            size: const Size(120, 120),
                            initialChartData: <CircularStackEntry>[
                              CircularStackEntry(
                                <CircularSegmentEntry>[
                                  CircularSegmentEntry(
                                    (widget.userData['interview_left_count'] /
                                            total) *
                                        100,
                                    Colors.blue[400],
                                    rankKey: 'completed',
                                  ),
                                  CircularSegmentEntry(
                                    (widget.userData['event_left_count'] /
                                            total) *
                                        100,
                                    Colors.green[600],
                                    rankKey: 'remaining',
                                  ),
                                  CircularSegmentEntry(
                                    (widget.userData['press_left_count'] /
                                            total) *
                                        100,
                                    Colors.red[600],
                                    rankKey: 'pending',
                                  ),
                                  CircularSegmentEntry(
                                    (20 / total) * 100,
                                    Colors.grey[100],
                                    rankKey: 'empty',
                                  ),
                                ],
                                rankKey: 'progress',
                              ),
                            ],
                            chartType: CircularChartType.Radial,
                            percentageValues: true,
                            holeLabel:
                                '${((total - 20) / total * 100).toInt()}%',
                            labelStyle: TextStyle(
                              color: Colors.blueGrey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          addHorizontalSpace(30),
                          Flexible(
                            child: Column(
                              children: [
                                bulletColoredBlackText(
                                    language == 'ro'
                                        ? '${widget.userData['press_left_count']} Comunicate de presă'
                                        : '${widget.userData['press_left_count']} Press releases',
                                    Colors.red),
                                bulletColoredBlackText(
                                    language == 'ro'
                                        ? '${widget.userData['interview_left_count']} Interviuri'
                                        : '${widget.userData['interview_left_count']} Interviews',
                                    Colors.blue),
                                bulletColoredBlackText(
                                    language == 'ro'
                                        ? '${widget.userData['event_left_count']} Evenimente de presă'
                                        : '${widget.userData['event_left_count']} Press events',
                                    Colors.green),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    addVerticalSpace(40),
                    Visibility(
                      visible: widget.userData['user_plan'] == '-',
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl('http://tudorpr.ro/pricing');
                        },
                        child: simpleDarkRoundedButton(
                          language == 'ro'
                              ? 'Cumpărați un abonament'
                              : 'Buy a subscription',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
