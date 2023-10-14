import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:two_value/src/theme.dart';

import '../../src/helper_widgets.dart';
import '../../src/time_ago_eng.dart';

class AdminNotificationsPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot myUserInfo;
  const AdminNotificationsPage(
      {super.key, required this.userId, required this.myUserInfo});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  int currentMills = DateTime.now().millisecondsSinceEpoch;

  String language = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.myUserInfo['user_language'];
    });
    DocumentReference ds =
        FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
    Map<String, dynamic> tasks = {
      'notification_count': 0,
    };
    ds.update(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: whiteTitleTextLarge("Notifications"),
          centerTitle: true,
          backgroundColor: TAppTheme.primaryColor,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Notifications')
              .doc('system')
              .collection(widget.userId)
              .orderBy('notification_time', descending: true)
              .limit(100)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: Colors.grey.withOpacity(.2),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myNotifications =
                        snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _displayNotifications(index, myNotifications,
                          widget.myUserInfo, snapshot.data!.docs.length),
                    );
                  },
                ),
              );
            } else {
              return Container(
                color: Colors.grey.withOpacity(.2),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _displayNotifications(index, DocumentSnapshot myNotifications,
      DocumentSnapshot myRealtimeInfo, int length) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              blackBoldText(language == 'ro'
                  ? myNotifications['notification_tittle_ro']
                  : myNotifications['notification_tittle_eng']),
              blackNormalText(
                language == 'ro'
                    ? myNotifications['notification_body_ro']
                    : myNotifications['notification_body_eng'],
              ),
              const SizedBox(
                height: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  miniBlackText(
                    _handleTime(myNotifications['notification_time'], language),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _handleTime(Timestamp timestamp, String language) {
    int mills =
        DateTime.parse(timestamp.toDate().toString()).millisecondsSinceEpoch;

    if (currentMills - mills > 172800000) {
      //172800000
      final theFormat = DateFormat('dd MMM, HH:mm');
      return theFormat.format(DateTime.fromMillisecondsSinceEpoch(mills));
    } else {
      return (timeAgoEn(mills));
    }
  }
}
