import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../src/helper_widgets.dart';

class AdminAnalyticsView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminAnalyticsView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminAnalyticsView> createState() => _AdminAnalyticsViewState();
}

class _AdminAnalyticsViewState extends State<AdminAnalyticsView> {
  int touchedIndex = -1;
  String language = '';

  int contentCount = 1;
  int pressesCount = 1;
  int interviewsCount = 1;
  int jobsCount = 1;
  int eventsCount = 1;

  @override
  void initState() {
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
    getPressesCount();
    getInterviewsCount();
    getJobsCount();
    getEventsCount();
    getTotal();
  }

  getPressesCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XArticles')
        .doc('Presses')
        .collection('Dominant')
        .where('press_status', isEqualTo: '-')
        .get();

    setState(() {
      pressesCount = snapshot.docs.length;
    });
    getTotal();
  }

  getInterviewsCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('XArticles')
        .doc('Interviews')
        .collection('Dominant')
        .get();

    setState(() {
      interviewsCount = snapshot.docs.length;
    });
    getTotal();
  }

  getJobsCount() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('XJobs').get();

    setState(() {
      jobsCount = snapshot.docs.length;
    });
    getTotal();
  }

  getEventsCount() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('XEvents').get();

    setState(() {
      eventsCount = snapshot.docs.length;
    });
    getTotal();
  }

  getTotal() {
    setState(() {
      contentCount = pressesCount + interviewsCount + jobsCount + eventsCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.2,
          child: Column(
            children: <Widget>[
              addVerticalSpace(40),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: 90,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              addVerticalSpace(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Indicator(
                        color: const Color(0xff7C81AD),
                        text: language == 'ro'
                            ? 'Comunicate de presă'
                            : 'Press releases',
                        isSquare: false,
                      ),
                      addVerticalSpace(8.0),
                      Indicator(
                        color: const Color(0xff9EB384),
                        text: language == 'ro' ? 'Interviuri' : 'Interviews',
                        isSquare: false,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Indicator(
                        color: const Color(0xff78D6C6),
                        text: language == 'ro' ? 'Locuri de munca' : 'Jobs',
                        isSquare: false,
                      ),
                      addVerticalSpace(8.0),
                      Indicator(
                        color: const Color(0xffF4D160),
                        text: language == 'ro' ? 'Evenimente' : 'Events',
                        isSquare: false,
                      ),
                    ],
                  )
                ],
              ),
              addVerticalSpace(0),
            ],
          ),
        ),
        addVerticalSpace(40),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff7C81AD),
            value: pressesCount.toDouble(),
            title: "${((pressesCount / contentCount) * 100).toInt()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff9EB384),
            value: interviewsCount.toDouble(),
            title: "${((interviewsCount / contentCount) * 100).toInt()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff78D6C6),
            value: jobsCount.toDouble(),
            title: "${((jobsCount / contentCount) * 100).toInt()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xffF4D160),
            value: jobsCount.toDouble(),
            title: "${((jobsCount / contentCount) * 100).toInt()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
